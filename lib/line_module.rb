module LineModule
  include LabelLogger

  class RequestModel
    include ActiveModel::Model
    attr_accessor :type, :replyToken, :userId, :content
  
    validates :id, presence: true
  
    def initialize(data)
      debug(__method__, "data=#{data.inspect}")
      @type = data[:type]
      @replyToken = data[:replyToken]
      @userId = data[:source][:userId]
      @content = ContentModel.new data[:message]
    end
  end

  class ContentModel
    include ActiveModel::Model
    attr_accessor :type, :id, :text
  
    validates :id, presence: true
  
    def initialize(content)
      debug('aContentModel#initialize', "content=#{content.inspect}")
      @type = content[:type]
      @id = content[:id]
      @text = content[:text]
    end
  end

  class PushClient
    def initialize(endpoint, token)
      info('aPushClient#initialize', "endpoint=#{endpoint.inspect}, token=#{token.inspect}")
      @endpoint = endpoint
      @token = token
    end

    def post(to, text)
      info('aPushClient#post', "to=#{to.inspect}, text=#{text.inspect}")
    
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

      error('aPushClient#post', "response=#{response.inspect}") unless response.status == 200
      return response
    end
  end

end
