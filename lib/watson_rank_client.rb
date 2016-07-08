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

    if text =~ /^@@/
      method = 'fcselect'
      text[0, 2] = ''
    else
      method = 'select'
    end
    debug('WatsonRankClient#get', "method=#{method}")
    
    response = connection.get do | request |
      request.url "/#{SERVICE_NAME}/api/v1/solr_clusters/#{CLUSTER_ID}/solr/example_collection/#{method}"
      request.params[:ranker_id] = RANKER_ID
      request.params[:q] = text
      request.params[:fl] = 'id,body'
      request.params[:rows] = 3
      request.params[:wt] = 'json'
    end

    if response.status == 200   
      info('WatsonRankClient#get', "numFound=#{response['body']['response']['numFound']}")
    else
      error('WatsonRankClient#get', "response=#{response.inspect}")
    end
    
    return response
  end
end
