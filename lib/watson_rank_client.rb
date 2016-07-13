module WatsonRankClient
  extend WatsonSolrClient

  RANKER_ID = ENV['WATSON_RANKER_ID']

  private
  def init(req)
    req.url "/#{SERVICE_NAME}/api/v1/solr_clusters/#{CLUSTER_ID}/solr/example_collection/fcselect"
    req.params[:ranker_id] = RANKER_ID
    return req
  end
end
