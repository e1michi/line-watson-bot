#
# LINE Messaging APIに関するモジュール
#
module LineModule
  #
  # イベントモデル
  #
  class EventModel
    include LoggerModule
    include ActiveModel::Model
    attr_accessor :type, :replyToken, :userId, :message
  
    validates :userId, presence: true
  
    def initialize(event)
      @type = event[:type]
      @replyToken = event[:replyToken]
      @userId = event[:source][:userId]
      @message = MessageModel.new event[:message]
    end
  end

  #
  # メッセージモデル
  #
  class MessageModel
    include LoggerModule
    include ActiveModel::Model
    attr_accessor :type, :id, :text
  
    validates :id, presence: true
  
    def initialize(message)
      @type = message[:type]
      @id = message[:id]
      @text = message[:text]
    end
  end

  #
  # APIの実行結果格納クラス
  #
  class LineResult
    attr_accessor :status, :body
  end

  #
  # ReplyMessageの実装クラス
  #
  class ReplyClient
    include LoggerModule

    def initialize(endpoint, token)
      @endpoint = endpoint
      @token = token
    end

    def reply_text_message(to, text)
      debug("to=#{to.inspect}, text=#{text.inspect}")
    
      connection = Faraday.new(:url => @endpoint) do | builder |
        builder.request :json
        builder.response :json, :content_type => /\bjson$/
        builder.adapter Faraday.default_adapter
      end

      response = connection.post do | request |
        request.url '/v2/bot/message/reply'
        request.headers = {
          'Content-Type' => 'application/json; charset=UTF-8',
          'Authorization' => "Bearer #{@token}"
        }
        request.body = {
          replyToken: to,
          messages: [{
            type: 'text',
            text: text
          }]
        }
      end

      result = LineResult.new
      if response.status == 200
        debug("response=#{response.inspect}")
        result.status = 0
        result.body = response.body
      else
        error("response=#{response.inspect}")
        result.status = -1
      end
    
      return result
    end

    def reply_template_message(to, msg)
      debug("to=#{to.inspect}, msg=#{msg.inspect}")
    
      connection = Faraday.new(:url => @endpoint) do | builder |
        builder.request :json
        builder.response :json, :content_type => /\bjson$/
        builder.adapter Faraday.default_adapter
      end

      response = connection.post do | request |
        request.url '/v2/bot/message/reply'
        request.headers = {
          'Content-Type' => 'application/json; charset=UTF-8',
          'Authorization' => "Bearer #{@token}"
        }
        request.body = {
          replyToken: to,
          messages: msg
        }
      end

      result = LineResult.new
      if response.status == 200
        debug("response=#{response.inspect}")
        result.status = 0
        result.body = response.body
      else
        error("response=#{response.inspect}")
        result.status = -1
      end
    
      return result
    end
  end

  #
  # PushMessageの実装クラス
  #
  class PushClient
    include LoggerModule

    def initialize(endpoint, token)
      @endpoint = endpoint
      @token = token
    end

    def post(to, text)
      debug("to=#{to.inspect}, text=#{text.inspect}")
    
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

      result = LineResult.new
      if response.status == 200
        debug("response=#{response.inspect}")
        result.status = 0
        result.body = response.body
      else
        error("response=#{response.inspect}")
        result.status = -1
      end
    
      return result
    end
  end
end
