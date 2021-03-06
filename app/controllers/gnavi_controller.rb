#
# LINE Messaging API Request Controller for Gnavi
#
class GnaviController < ApplicationController
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
      response = rc.reply_message(model.replyToken, text)
    end

    # 常に正常ステータスを返す（仕様）
    render json: [], status: :ok
  end
end
