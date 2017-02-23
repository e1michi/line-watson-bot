#
# IBM Watson APIに関するモジュール
#
module WatsonModule
  #
  # Watson関連のスーパークラス
  #
  class WatsonRoot
    include LoggerModule

    def initialize(endpoint, username, password)
      @endpoint = endpoint
      @username = username
      @password = password
    end
    
    def think(text)
      debug("text=#{text.inspect}")
    
      connection = Faraday.new(:url => @endpoint) do | faraday |
        faraday.basic_auth @username, @password
        faraday.request :url_encoded
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
      end

      response = send_request(connection, text)
      if response.status == 200   
        debug("response=#{response.inspect}")
      else
        error("response=#{response.inspect}")
      end

      result = WatsonResult.new
      if response.status == 200
        result.status = 0
        result.body = response.body
      end
    
      return result
    end
  end

  #
  # Watsonの処理結果格納クラス
  #
  class WatsonResult
    def initialize
      @status = -1
      @body = nil
    end
  end

  #
  # Apache Solrの実装クラス
  #
  class ApacheSolrClient < WatsonRoot
    def initialize(endpoint, username, password, clusterid, fields, rows)
      super(endpoint, username, password)
      @clusterid = clusterid
      @fields = fields
      @rows = rows
    end

    def send_request(connection, text)
      response = connection.get do | request |
        request.url "/retrieve-and-rank/api/v1/solr_clusters/#{@clusterid}/solr/universe_collection/select"
        request.params[:q] = text
        request.params[:fl] = @fields
        request.params[:rows] = @rows
        request.params[:wt] = 'json'
      end

      return response
    end
  end

  #
  # R&Rの実装クラス
  #
  class RetrieveAndRankClient < ApacheSolrClient
    def initialize(endpoint, username, password, clusterid, rankerid, fields, rows)
      super(endpoint, username, password, clusterid, fields, rows)
      @rankerid = rankerid
    end

    def send_request(connection, text)
      response = connection.get do | request |
        request.url "/retrieve-and-rank/api/v1/solr_clusters/#{@clusterid}/solr/universe_collection/fcselect"
        request.params[:ranker_id] = @rankerid
        request.params[:q] = text
        request.params[:fl] = @fields
        request.params[:rows] = @rows
        request.params[:wt] = 'json'
      end

      return response
    end
  end

  #
  # NLCの実装クラス
  #
  class NaturalLanguageClassifierClient < WatsonRoot
    def initialize(endpoint, username, password, classifier_id)
      super(endpoint, username, password)
      @classifier_id = classifier_id
    end

    def send_request(connection, text)
      response = connection.get do | request |
        request.url "/natural-language-classifier/api/v1/classifier/#{@classifier_id}/classify"
        request.params[:text] = text
      end

      return response
    end
  end
end
