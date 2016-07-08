module LineClient
  include LabelLogger
  
  END_POINT = "https://trialbot-api.line.me"
  #END_POINT = "https://api.line.me"
  TO_CHANNEL = 1383378250 # this is fixed value
  EVENT_TYPE = "138311608800106203" # this is fixed value

  CHANNEL_ID = ENV['LINE_CHANNEL_ID']
  CHANNEL_SECRET = ENV['LINE_CHANNEL_SECRET']
  CHANNEL_MID = ENV['LINE_CHANNEL_MID']
  OUTBOUND_PROXY = ENV['FIXIE_URL']

  def post(to, text)
    debug('LineClient#post', "to=#{to.inspect}, text=#{text.inspect}")
    
    connection = Faraday.new(:url => END_POINT) do | builder |
      builder.request :json
      builder.response :json, :content_type => /\bjson$/
      builder.adapter Faraday.default_adapter
      builder.proxy OUTBOUND_PROXY
    end

    response = connection.post do | request |
      request.url '/v1/events'
      request.headers = {
        'Content-type' => 'application/json; charset=UTF-8',
        'X-Line-ChannelID' => CHANNEL_ID,
        'X-Line-ChannelSecret' => CHANNEL_SECRET,
        'X-Line-Trusted-User-With-ACL' => CHANNEL_MID
      }
      request.body = {
        to: [to],
        toChannel: TO_CHANNEL,
        eventType: EVENT_TYPE,
        content: {
          contentType: 1,
          toType: 1,
          text: text
        }
      }
    end

    error('LineClient#post', "response=#{response.inspect}") unless response.status == 200
    return response
  end
end
