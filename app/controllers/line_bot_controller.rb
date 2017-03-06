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
      result = rc.reply_message(model.replyToken, text)
      debug("result=#{result.inspect}")
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
          text = "おすすめの候補がありませんでした。\n文章を変えてみてください。"
        end
      else
        text = 'エラーが起きました。'
      end

      if text != ""
        # LINEサービスへのテキスト送信(エラー、低スコア)
        rc = LineModule::ReplyClient.new(LINE_ENDPOINT, LINE_CHANNEL_ACCESS_TOKEN)
        rc.reply_text_message(model.replyToken, text)
        next
      end

      # クラスの取り出し
      cond = result.body['classes'][0]['class_name'].split('@')

      # レストラン検索
      rs = GnaviModule::RestaurantSearch.new(GNAVI_ENDPOINT, GNAVI_ACCESS_KEY)
      result = rs.search_with_category_area(cond[0], cond[1])

      text = ""
      if result.status == 0
        if result.body['total_hit_count'] == 0
          text = "おすすめの情報がありませんでした。\n文章を変えてみてください。"
        end
      else
        text = 'エラーが起きました。'
      end

      if text != ""
        # LINEサービスへのテキスト送信(エラー、該当レコードなし)
        rc = LineModule::ReplyClient.new(LINE_ENDPOINT, LINE_CHANNEL_ACCESS_TOKEN)
        rc.reply_text_message(model.replyToken, text)
        next
      end

      # LINEテンプレートメッセージの作成
      columns = []
      result.body['rest'].each do | item |
        col = {}
        col[:thumbnailImageUrl] = 'https://c-cpnt.gnst.jp/header/img/logo.png'
        if item['image_url']['shop_image1'].length > 0
          col[:thumbnailImageUrl] = item['image_url']['shop_image1']
        end
        col[:title] = 'No Title'
        if item['name'].length > 0
          col[:title] = item['name'][0,40]
        end
        col[:text] = '説明は詳細にて確認してください。'
        if item['pr']['pr_short'].length > 0
          col[:text] = item['pr']['pr_short'][0,60]
        end
        action1 = {}
        action1[:type] = 'uri'
        action1[:label] = '詳細を表示'
        action1[:uri] = item['url']
        # action2 = {}
        # action2[:type] = 'uri'
        # action2[:label] = '評価する'
        # action2[:uri] = item['url']
        # col[:actions] = [action1, action2]
        col[:actions] = [action1]
        columns.push(col)
      end

      msg = [
        {
          :type => 'text',
          :text => 'おすすめのお店が見つかりました。'
        },
        {
          :type => 'template',
          :altText => 'おすすめのお店',
          :template => {
            :type => 'carousel',
            :columns => columns
          }
        }
      ]

      # LINEサービスへのメッセージ送信
      rc = LineModule::ReplyClient.new(LINE_ENDPOINT, LINE_CHANNEL_ACCESS_TOKEN)
      result = rc.reply_template_message(model.replyToken, msg)
      debug("result=#{result.inspect}")
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
