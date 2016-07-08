module WatsonRankClient
  include LabelLogger
  
  END_POINT = "https://gateway.watsonplatform.net"
  USERNAME = "ee04259f-11ea-4cb5-8f17-0871f4b2d6b8"
  PASSWORD = "GcSg6QaIwEKt"
  SERVICE_NAME = "retrieve-and-rank"
  CLUSTER_ID = ENV['WATSON_CLUSTER_ID']
  RANKER_ID = ENV['WATSON_RANKER_ID']
  
  def get(text)
    debug('WatsonRankClient#get', "text=#{text.inspect}")
    
    connection = Faraday.new(:url => END_POINT) do | faraday |
      faraday.basic_auth USERNAME, PASSWORD
      faraday.request :url_encoded
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter Faraday.default_adapter
    end

    response = connection.get do | request |
      request.url "/#{SERVICE_NAME}/api/v1/solr_clusters/#{CLUSTER_ID}/solr/example_collection/select"
      #request.url "/#{SERVICE_NAME}/api/v1/solr_clusters/#{CLUSTER_ID}/solr/example_collection/fcselect"
      request.params[:ranker_id] = RANKER_ID
      request.params[:q] = text
      request.params[:fl] = 'id,body'
      request.params[:wt] = 'json'
    end
    
    error('WatsonRankClient#get', "response=#{response.inspect}") unless response.status == 200
    return response
  end
end
