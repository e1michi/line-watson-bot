module WatsonRankClient
  extend WatsonSolrClient
  extend self

  RANKER_ID = ENV['WATSON_RANKER_ID']

  def init(req)
    req.url "/#{SERVICE_NAME}/api/v1/solr_clusters/#{CLUSTER_ID}/solr/example_collection/fcselect"
    req.params[:ranker_id] = RANKER_ID
    return req
  end
end
