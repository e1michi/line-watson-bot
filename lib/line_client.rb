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

#
# Old style class implimentation
#
# class LineClient
#   module ContentType
#     TEXT = 1
#     IMAGE = 2
#     VIDEO = 3
#     AUDIO = 4
#     LOCATION = 7
#     STICKER = 8
#     CONTACT = 10
#   end
#   module ToType
#     USER = 1
#   end

#   END_POINT = "https://trialbot-api.line.me"
#   TO_CHANNEL = 1383378250 # this is fixed value
#   EVENT_TYPE = "138311608800106203" # this is fixed value

#   def initialize(channel_id, channel_secret, channel_mid, proxy = nil)
#     @channel_id = channel_id
#     @channel_secret = channel_secret
#     @channel_mid = channel_mid
#     @proxy = proxy
#   end

#   def post(path, data)
#     client = Faraday.new(:url => END_POINT) do |conn|
#       conn.request :json
#       conn.response :json, :content_type => /\bjson$/
#       conn.adapter Faraday.default_adapter
#       conn.proxy @proxy
#     end

#     res = client.post do |request|
#       request.url path
#       request.headers = {
#           'Content-type' => 'application/json; charset=UTF-8',
#           'X-Line-ChannelID' => @channel_id,
#           'X-Line-ChannelSecret' => @channel_secret,
#           'X-Line-Trusted-User-With-ACL' => @channel_mid
#       }
#       request.body = data
#     end
#     res
#   end

#   def send(line_ids, message)
#     post('/v1/events', {
#         to: line_ids,
#         content: {
#             contentType: ContentType::TEXT,
#             toType: ToType::USER,
#             text: message
#         },
#         toChannel: TO_CHANNEL,
#         eventType: EVENT_TYPE
#     })
#   end
# end
