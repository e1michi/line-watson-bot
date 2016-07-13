module WatsonSolrClient
  include LabelLogger
  
  END_POINT = "https://gateway.watsonplatform.net"
  USERNAME = "ee04259f-11ea-4cb5-8f17-0871f4b2d6b8"
  PASSWORD = "GcSg6QaIwEKt"
  SERVICE_NAME = "retrieve-and-rank"
  CLUSTER_ID = ENV['WATSON_CLUSTER_ID']
  
  def get(text)
    info('WatsonSolrClient#get', "text=#{text.inspect}")
    
    connection = Faraday.new(:url => END_POINT) do | faraday |
      faraday.basic_auth USERNAME, PASSWORD
      faraday.request :url_encoded
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter Faraday.default_adapter
    end

    response = connection.get do | request |
      request = init(request)
      request.params[:q] = text
      request.params[:fl] = 'id,body'
      request.params[:rows] = 3
      request.params[:wt] = 'json'
    end

    if response.status == 200   
      debug('WatsonSolrClient#get', "response=#{response.inspect}")
    else
      error('WatsonSolrClient#get', "response=#{response.inspect}")
    end
    
    return response
  end
  
  private
  def init(req)
    req.url "/#{SERVICE_NAME}/api/v1/solr_clusters/#{CLUSTER_ID}/solr/example_collection/select"
    return req
  end
end
