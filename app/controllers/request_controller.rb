#
# LINE Messaging API Request Controller
#
class RequestController < ApplicationController
  #
  # callback以外の処理を除外
  #
  protect_from_forgery :except => [:callback] # For CSRF

  #
  # Webhook処理
  #
  def callback
    # リクエスト元のチェック（プロダクション環境時のみ）
    if Rails.env == 'production'
      unless is_validate_signature
        # 他サイトからのリクエストを除外
        render json: [], status: 470
      end
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
        WATSON_ENDPOINT, WATSON_USERNAME, WATSON_PASSWORD,
        WATSON_CLUSTER_ID, WATSON_RANKER_ID,
        WATSON_DATA_FIELDS, WATSON_DATA_ROWS)
      response = rarc.search(text)

      if response.status == 200
        body = response.body
        if body['response']['numFound'] > 0
          text = body['response']['docs'][0]['body'][0]
        else
          text = '答えが見つかりませんでした。'
        end
      else
        text = 'エラーが起きました。'
      end
      
      # LINEサービスへのテキスト送信
      pc = LineModule::PushClient.new(LINE_ENDPOINT, LINE_CHANNEL_ACCESS_TOKEN)
      response = pc.post(model.userId, text)
    end

    # 常に正常ステータスを返す（仕様）
    render json: [], status: :ok
  end

  private
  # リクエストの整合性チェック
  #   info: https://developers.line.me/bot-api/getting-started-with-bot-api-trial#signature_validation
  def is_validate_signature
    signature = request.headers["X-LINE-Signature"]
    http_request_body = request.raw_post
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, LINE_CHANNEL_SECRET, http_request_body)
    signature_answer = Base64.strict_encode64(hash)
    signature == signature_answer
  end
end
