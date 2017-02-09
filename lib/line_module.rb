module LineModule
  class EventModel
    include LabelLogger
    include ActiveModel::Model
    attr_accessor :type, :replyToken, :userId, :message
  
    validates :userId, presence: true
  
    def initialize(event)
      debug("event=#{event.inspect}")
      
      @type = event[:type]
      @replyToken = event[:replyToken]
      @userId = event[:source][:userId]
      @message = MessageModel.new event[:message]
    end
  end

  class MessageModel
    include LabelLogger
    include ActiveModel::Model
    attr_accessor :type, :id, :text
  
    validates :id, presence: true
  
    def initialize(message)
      debug("#{self.class}##{__method__}", "message=#{message.inspect}")
      
      @type = message[:type]
      @id = message[:id]
      @text = message[:text]
    end
  end

  class PushClient
    include LabelLogger

    def initialize(endpoint, token)
      debug("#{self.class}##{__method__}", "endpoint=#{endpoint.inspect}, token=#{token.inspect}")
      
      @endpoint = endpoint
      @token = token
    end

    def post(to, text)
      debug("#{self.class}##{__method__}", "to=#{to.inspect}, text=#{text.inspect}")
    
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

      error("#{self.class}##{__method__}", "response=#{response.inspect}") unless response.status == 200
      return response
    end
  end

end
