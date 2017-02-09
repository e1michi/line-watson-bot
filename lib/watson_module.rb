#
# IBM Watson APIに関するモジュール
#
module WatsonModule
  #
  # Apache Solrの実装クラス
  #
  class ApacheSolrClient
    include LabelLogger

    def initialize(endpoint, username, password, clusterid, rankerid)
      @endpoint = endpoint
      @username = username
      @password = password
      @clusterid = clusterid
      @rankerid = rankerid
    end
    
    def get(text)
      debug("text=#{text.inspect}")
    
      connection = Faraday.new(:url => @endpoint) do | faraday |
        faraday.basic_auth @username, @password
        faraday.request :url_encoded
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
      end

      response = send_request(connection)
      if response.status == 200   
        debug("response=#{response.inspect}")
      else
        error("response=#{response.inspect}")
      end
    
      return response
    end

    def send_request(connection, text)
      response = connection.get do | request |
        request.url "/retrieve-and-rank/api/v1/solr_clusters/#{@clusterid}/solr/universe_collection/select"
        request.params[:q] = text
        request.params[:fl] = 'id,body'
        request.params[:rows] = 5
        request.params[:wt] = 'json'
      end

      return response
    end
  end

  #
  # R&Rの実装クラス
  #
  class RetrieveAndRankClient < ApacheSolrClient
    # def initialize(endpoint, username, password, clusterid, rankerid)
    #   super
    # end

    def send_request(connection, text)
      response = connection.get do | request |
        request.url "/retrieve-and-rank/api/v1/solr_clusters/#{@clusterid}/solr/universe_collection/fcselect"
        request.params[:ranker_id] = @rankerid
        request.params[:q] = text
        request.params[:fl] = 'id,body'
        request.params[:rows] = 5
        request.params[:wt] = 'json'
      end

      return response
    end
  end

  #
  # STTの実装クラス
  #   注意：未完成につき動作しません
  #
  class SpeechToTextClient
    include LabelLogger
  
    END_POINT = "https://stream.watsonplatform.net"
    USERNAME = "c5f658b9-2a59-4ff1-9ba6-ef7cb8ce905a"
    PASSWORD = "pnabcpSMQvAP"
    SERVICE_NAME = "speech-to-text"
    CLUSTER_ID = ENV['WATSON_CLUSTER_ID']
    
    def getText(id)
      debug("id=#{id.inspect}")
      
      connection = Faraday.new(:url => END_POINT) do | faraday |
        faraday.basic_auth USERNAME, PASSWORD
        faraday.request :url_encoded
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
  
      response = connection.get do | request |
        request = init(request, text)
      end
  
      if response.status == 200   
        debug("response=#{response.inspect}")
      else
        error("response=#{response.inspect}")
      end
      
      return response
    end
    
    private
    def init(req, text)
      req.url "/#{SERVICE_NAME}/api/v1/solr_clusters/#{CLUSTER_ID}/solr/example_collection/select"
      req.params[:q] = text
      req.params[:fl] = 'id,body'
      req.params[:rows] = 5
      req.params[:wt] = 'json'
      return req
    end
  end
end
