module LineClient
  include LabelLogger
  
  END_POINT = "https://api.line.me"

  CHANNEL_ACCESS_TOKEN = ENV['LINE_CHANNEL_ACCESS_TOKEN']

  def post(to, text)
    info('LineClient#post', "to=#{to.inspect}, text=#{text.inspect}")
    
    connection = Faraday.new(:url => END_POINT) do | builder |
      builder.request :json
      builder.response :json, :content_type => /\bjson$/
      builder.adapter Faraday.default_adapter
#      builder.proxy OUTBOUND_PROXY
    end

    response = connection.post do | request |
      request.url '/v2/bot/message/push'
      request.headers = {
        'Content-Type' => 'application/json; charset=UTF-8',
        'Authorization' => "Bearer #{CHANNEL_ACCESS_TOKEN}"
      }
      request.body = {
        to: [to],
        messages: [{
          type: 'text',
          text: text
        }]
      }
    end

    error('LineClient#post', "response=#{response.inspect}") unless response.status == 200
    return response
  end
end
