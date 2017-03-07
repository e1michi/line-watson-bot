class ApplicationController < ActionController::Base
  include LoggerModule
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected
  # リクエストの整合性チェック
  #   info: https://developers.line.me/bot-api/getting-started-with-bot-api-trial#signature_validation
  def is_validate_signature(channel_secret)
    signature = request.headers["X-LINE-Signature"]
    http_request_body = request.raw_post
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, channel_secret, http_request_body)
    signature_answer = Base64.strict_encode64(hash)
    signature == signature_answer
  end
end
