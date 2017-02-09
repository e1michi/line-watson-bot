class LineClient
  include LabelLogger
  
  private
  def init(endpoint, token)
    info('LineClient#init', "endpoint=#{endpoint.inspect}, token=#{token.inspect}")
    @endpoint = endpoint
    @token = token
  end

  def post(to, text)
    info('aLineClient#post', "to=#{to.inspect}, text=#{text.inspect}")
    
    connection = Faraday.new(:url => @endpoint) do | builder |
      builder.request :json
      builder.response :json, :content_type => /\bjson$/
      builder.adapter Faraday.default_adapter
    end

    response = connection.post do | request |
      request.url '/v2/bot/message/push'
      request.headers = {
        'Content-Type' => 'application/json; charset=UTF-8',
        'Authorization' => "Bearer #{@token}"
      }
      request.body = {
        to: to,
        messages: [{
          type: 'text',
          text: text
        }]
      }
    end

    error('aLineClient#post', "response=#{response.inspect}") unless response.status == 200
    return response
  end
end
