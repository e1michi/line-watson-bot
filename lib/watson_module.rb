#
# IBM Watson APIに関するモジュール
#
module WatsonModule
  #
  # Apache Solrの実装クラス
  #
  class ApacheSolrClient
    include LabelLogger

    END_POINT = "https://gateway.watson-j.jp"
    SERVICE_NAME = "retrieve-and-rank"

    def get(text)
      debug("text=#{text.inspect}")
    
      connection = Faraday.new(:url => END_POINT) do | faraday |
        faraday.basic_auth WATSON_USERNAME, WATSON_PASSWORD
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
      req.url "/#{SERVICE_NAME}/api/v1/solr_clusters/#{WATSON_CLUSTER_ID}/solr/universe_collection/select"
      req.params[:q] = text
      req.params[:fl] = 'id,body'
      req.params[:rows] = 5
      req.params[:wt] = 'json'
      return req
    end
  end

  #
  # R&Rの実装クラス
  #
  class RetrieveAndRankClient < ApacheSolrClient
    private
    def init(req, text)
      req.url "/#{SERVICE_NAME}/api/v1/solr_clusters/#{WATSON_CLUSTER_ID}/solr/universe_collection/fcselect"
      req.params[:ranker_id] = WATSON_RANKER_ID
      req.params[:q] = text
      req.params[:fl] = 'id,body'
      req.params[:rows] = 5
      req.params[:wt] = 'json'
      return req
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
