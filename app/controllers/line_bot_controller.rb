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

      if result.status == 0
        body = result.body
        if body['classes'][0]['confidence'] >= 0.8
          text = body['classes'][0]['class_name']
        else
          text = '条件を変更してください。'
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

{
  "classifier_id" : "12d0fcx34-nlc-1594",
  "url" : "https://gateway.watson-j.jp/natural-language-classifier/api/v1/classifiers/12d0fcx34-nlc-1594",
  "text" : "フレンチ",
  "top_class" : "french@all",
  "classes" : [ {
    "class_name" : "french@all",
    "confidence" : 1.0
  }, {
    "class_name" : "all@shinjuku",
    "confidence" : 0.0
  }, {
    "class_name" : "bar@shibuya",
    "confidence" : 0.0
  }, {
    "class_name" : "french@ueno",
    "confidence" : 0.0
  }, {
    "class_name" : "italian@aoyama",
    "confidence" : 0.0
  }, {
    "class_name" : "french@ginza",
    "confidence" : 0.0
  }, {
    "class_name" : "izakaya@aoyama",
    "confidence" : 0.0
  }, {
    "class_name" : "italian@shibuya",
    "confidence" : 0.0
  }, {
    "class_name" : "izakaya@ginza",
    "confidence" : 0.0
  }, {
    "class_name" : "izakaya@shibuya",
    "confidence" : 0.0
  } ]
}
