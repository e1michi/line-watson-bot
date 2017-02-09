class WatsonSolrClient
  include LabelLogger

  END_POINT = "https://gateway.watson-j.jp"
  SERVICE_NAME = "retrieve-and-rank"

  def get(text)
    info("text=#{text.inspect}")
    
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
    info("text=#{text.inspect}")
    
    req.url "/#{SERVICE_NAME}/api/v1/solr_clusters/#{WATSON_CLUSTER_ID}/solr/universe_collection/select"
    req.params[:q] = text
    req.params[:fl] = 'id,body'
    req.params[:rows] = 5
    req.params[:wt] = 'json'
    return req
  end
end
