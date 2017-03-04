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

    def search_with_category_area(category, area)
      debug("category=#{category.inspect}, area=#{area.inspect}")
    
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
        request.params['hit_per_page'] = 5
        if category.length
          request.params['category_l'] = category
        end
        request.params['pref'] = 'PREF13'
        if area.length
          request.params['areacode_m'] = area
        end
      end

      error("response=#{response.inspect}") unless response.status == 200
      return response.body
    end
  end
end
