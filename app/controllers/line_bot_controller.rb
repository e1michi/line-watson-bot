#
# LINE Bot Controller
#
class LineBotController < ApplicationController
  #
  # Webhook以外の処理を除外
  #
  protect_from_forgery :except => [:universe, :gnavi] # For CSRF

  #
  # Webhook処理(universe)
  #
  def universe
    # リクエスト元のチェック
    unless is_validated_request
      render json: [], status: 470
    end

    # リクエストデータ処理（複数）
    params[:events].each do | item |
      # イベントモデルの生成
      model = LineModule::EventModel.new item

      # テキストの抽出
      case model.message.type
      when 'text' then
        # テキストの場合はそのまま
        text = model.message.text;
      when 'audio' then
        # 音声データはWatson STT経由でテキストを抽出
        sttc = WatsonModule::SpeechToTextClient.new
        response = sttc.getText(model.message.id)
        next unless response.status == 200
        text = response.body
      else
        next
      end

      # Watson R&Rの呼び出し
      rarc = WatsonModule::RetrieveAndRankClient.new(
        WATSON_RAR_ENDPOINT, WATSON_RAR_USERNAME, WATSON_RAR_PASSWORD,
        WATSON_RAR_CLUSTER_ID, WATSON_RAR_RANKER_ID,
        WATSON_RAR_DATA_FIELDS, WATSON_RAR_DATA_ROWS)
      result = rarc.think(text)

      if result.status == 0
        body = result.body
        if body['response']['numFound'] > 0
          text = body['response']['docs'][0]['body'][0]
        else
          text = '答えが見つかりませんでした。'
        end
      else
        text = 'エラーが起きました。'
      end
      
      # LINEサービスへのテキスト送信
      rc = LineModule::ReplyClient.new(LINE_ENDPOINT, LINE_CHANNEL_ACCESS_TOKEN)
      rc.reply_message(model.replyToken, text)
    end

    # 常に正常ステータスを返す（仕様）
    render json: [], status: :ok
  end

  #
  # Webhook処理(gnavi)
  #
  def gnavi
    # リクエスト元のチェック
    unless is_validated_request
      render json: [], status: 470
    end

    # リクエストデータ処理（複数）
    params[:events].each do | item |
      # イベントモデルの生成
      model = LineModule::EventModel.new item

      # テキストの抽出
      case model.message.type
      when 'text' then
        # テキストの場合はそのまま
        text = model.message.text;
      else
        next
      end

      # Watson NLCの呼び出し
      nlcc = WatsonModule::NaturalLanguageClassifierClient.new(
        WATSON_NLC_ENDPOINT, WATSON_NLC_USERNAME, WATSON_NLC_PASSWORD,
        WATSON_NLC_CLASSIFIER_ID)
      result = nlcc.think(text)

      text = ""
      if result.status == 0
        if result.body['classes'][0]['confidence'] < 0.8
          text = '条件を変更してください。'
        end
      else
        text = 'エラーが起きました。'
      end

      if text != ""
        # LINEサービスへのテキスト送信(エラー、低スコア時)
        rc = LineModule::ReplyClient.new(LINE_ENDPOINT, LINE_CHANNEL_ACCESS_TOKEN)
        rc.reply_text_message(model.replyToken, text)
        next
      end

      # クラスの取り出し
      cond = result.body['classes'][0]['class_name'].split('@')

      # レストラン検索
      rs = GnaviModule::RestaurantSearch.new(GNAVI_ENDPOINT, GNAVI_ACCESS_KEY)
      result = rs.search_with_pref(cond[0], 'PREF13')

      # LINEテンプレートメッセージの作成
      columns = []
      result['rest'].each do | item |
        col = {
          thumbnailImageUrl: item['image_url']['shop_image1'],
          title: item['name'],
          text: item['pr']['pr_short'],
          actions: [
            {
              type: "postback",
              label: "Buy",
              data: "action=buy&itemid=111"
            },
            {
              type: "postback",
              label: "Add to cart",
              data: "action=add&itemid=111"
            },
            {
              type: "uri",
              label: "View detail",
              uri: "http://example.com/page/111"
            }
          ]
        }
        columns.push(col)
      end

      msg = {
        type: 'template',
        altText: 'template'
        template: {
          type: 'carousel',
          columns: columns
      }

      # LINEサービスへのメッセージ送信
      rc = LineModule::ReplyClient.new(LINE_ENDPOINT, LINE_CHANNEL_ACCESS_TOKEN)
      rc.reply_template_message(model.replyToken, msg)
    end

    # 常に正常ステータスを返す（仕様）
    render json: [], status: :ok
  end

  private
  def is_validated_request
    if Rails.env == 'production'
      # プロダクション環境時のみ
      unless is_validate_signature
        # 他サイトからのリクエストを除外
        return false
      end
    end
    
    return true
  end
end
