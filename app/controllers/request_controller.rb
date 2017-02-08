class RequestController < ApplicationController
  include LineClient
  protect_from_forgery :except => [:callback] # For CSRF

  def callback
    # for production
    if Rails.env == 'production'
      # Reject request comes from other services
      unless is_validate_signature
        render json: [], status: 470
      end
    end
    
    params[:events].each do | item |
      model = LineRequestModel.new item
      case model.content.type
      when 'text' then
        # text message
        text = model.content.text;
      when 'voice' then
        # voice message
        # work with Watson STT
        client = WatsonSpeechToTextClient.new
        response = client.getText(model.content.id)
        next unless response.status == 200
        text = response.body
      else
        # Unsupported content type
        next
      end
      
      # work with Watson RaR
#      if text =~ /^@@/
#        text[0, 2] = ''
        client = WatsonRankClient.new
#      else
#        client = WatsonSolrClient.new
#      end
      response = client.get(text)

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
      
      # Send message to LINE service
      response = post(model.userId, text)
    end

    render json: [], status: :ok
  end

  private
  # LINE Request Validation
  #   info: https://developers.line.me/bot-api/getting-started-with-bot-api-trial#signature_validation
  def is_validate_signature
    signature = request.headers["X-LINE-Signature"]
    http_request_body = request.raw_post
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, LINE_CHANNEL_SECRET, http_request_body)
    signature_answer = Base64.strict_encode64(hash)
    signature == signature_answer
  end
end
