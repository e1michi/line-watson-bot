class RequestController < ApplicationController
  include LineClient
  
  protect_from_forgery :except => [:callback] # For CSRF

  # CHANNEL_ID = ENV['LINE_CHANNEL_ID']
  # CHANNEL_SECRET = ENV['LINE_CHANNEL_SECRET']
  # CHANNEL_MID = ENV['LINE_CHANNEL_MID']
  # OUTBOUND_PROXY = ENV['LINE_OUTBOUND_PROXY']

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
        next
      end
      post([model.content.from], model.content.text)
    end

    # container = result[:content]
    # mid = container[:from]
    
    # type = container[:contentType]
    # unless type == 1
    #   # Not text message
    #   render json: [], status: 470
    # end

    # text = container[:text]

    # client = LineClient.new(CHANNEL_ID, CHANNEL_SECRET, CHANNEL_MID, OUTBOUND_PROXY)
    # res = client.send([mid], text)

    # if res.status == 200
    #   info(:status, {success: res})
    # else
    #   info(:status, {fail: res})
    # end
    render json: [], status: :ok
  end

  private
  # LINEからのアクセスか確認.
  # 認証に成功すればtrueを返す。
  # ref) https://developers.line.me/bot-api/getting-started-with-bot-api-trial#signature_validation
  def is_validate_signature
    signature = request.headers["X-LINE-ChannelSignature"]
    http_request_body = request.raw_post
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, CHANNEL_SECRET, http_request_body)
    signature_answer = Base64.strict_encode64(hash)
    signature == signature_answer
  end
end
