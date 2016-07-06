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
    
    
    params[:result].each do | item |
      model = LineRequestModel.new item
      unless model.content.contentType == 1
        # Unsupported content type
        next
      end
      
      # Work with Watson
      
      # Send message to LINE service
      response = post(model.content.from, model.content.text)
      info('RequestController#callback', "LINE service response=#{response.inspect}")
    end

    render json: [], status: :ok
  end

  private
  # LINE Request Validation
  #   info: https://developers.line.me/bot-api/getting-started-with-bot-api-trial#signature_validation
  def is_validate_signature
    signature = request.headers["X-LINE-ChannelSignature"]
    http_request_body = request.raw_post
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, CHANNEL_SECRET, http_request_body)
    signature_answer = Base64.strict_encode64(hash)
    signature == signature_answer
  end
end
