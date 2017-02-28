#
# ぐるなびAPIに関するモジュール
#
module GnaviModule
  #
  # レストラン検索APIの実装クラス
  #
  class RestaurantSearch
    include LoggerModule

    def initialize(endpoint, key)
      debug("endpoint=#{endpoint.inspect}, key=#{key.inspect}")
      
      @endpoint = endpoint
      @key = key
    end

    def search_with_pref(type, code)
      debug("type=#{type.inspect}, code=#{code.inspect}")
    
      connection = Faraday.new(:url => @endpoint) do | builder |
        builder.request :json
        builder.response :json
        builder.adapter Faraday.default_adapter
      end

      response = connection.get do | request |
        request.url '/RestSearchAPI/20150630'
        request.headers = {
          'Content-Type' => 'application/json; charset=UTF-8',
        }
        request.params['keyid'] = @key
        request.params['format'] = 'json'
        request.params['pref'] = code
        request.params['freeword'] = type
      end

      error("response=#{response.inspect}") unless response.status == 200
      return response.body
    end
  end
end
