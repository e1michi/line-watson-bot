class WatsonRankClient < WatsonSolrClient

  RANKER_ID = ENV['WATSON_RANKER_ID']

  private
  def init(req, text)
    req.url "/#{SERVICE_NAME}/api/v1/solr_clusters/#{CLUSTER_ID}/solr/example_collection/fcselect"
    req.params[:ranker_id] = RANKER_ID
    req.params[:q] = text
    req.params[:fl] = 'id,body'
    req.params[:rows] = 5
    req.params[:wt] = 'json'
    return req
  end
end
