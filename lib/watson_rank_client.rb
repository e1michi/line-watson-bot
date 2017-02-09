class WatsonRankClient < WatsonSolrClient
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
