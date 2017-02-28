LINE_ENDPOINT = 'https://api.line.me'
LINE_CHANNEL_SECRET = ENV['LINE_CHANNEL_SECRET']
LINE_CHANNEL_ACCESS_TOKEN = ENV['LINE_CHANNEL_ACCESS_TOKEN']

WATSON_IBM_ENDPOINT = 'https://gateway.watsonplatform.net'
WATSON_SOFTBANK_ENDPOINT = 'https://gateway.watson-j.jp'
WATSON_ENDPOINT = WATSON_SOFTBANK_ENDPOINT

WATSON_RAR_ENDPOINT = WATSON_ENDPOINT
WATSON_RAR_USERNAME = ENV['WATSON_RAR_USERNAME']
WATSON_RAR_PASSWORD = ENV['WATSON_RAR_PASSWORD']
WATSON_RAR_CLUSTER_ID = ENV['WATSON_RAR_CLUSTER_ID']
WATSON_RAR_RANKER_ID = ENV['WATSON_RAR_RANKER_ID']
WATSON_RAR_DATA_FIELDS = 'id,body'
WATSON_RAR_DATA_ROWS = 5

WATSON_NLC_ENDPOINT = WATSON_ENDPOINT
WATSON_NLC_USERNAME = ENV['WATSON_NLC_USERNAME']
WATSON_NLC_PASSWORD = ENV['WATSON_NLC_PASSWORD']
WATSON_NLC_CLASSIFIER_ID = ENV['WATSON_NLC_CLASSIFIER_ID']

GNAVI_ENDPOINT = 'https://api.gnavi.co.jp'
GNAVI_ACCESS_KEY = ENV['GNAVI_ACCESS_KEY']

$gnavi_class_name = {
    'all' => 'レストラン',
    'italian' => 'イタリア料理レストラン',
    'french' => 'フランス料理レストラン',
    'izakaya' => '居酒屋',
    'bar' => 'バー'
}

$gnavi_area_code = {
    'all' => '',
    'ueno' => 'AREAL2198',
    'ginza' => 'AREAL2101',
    'aoyama' => 'AREAL2125',
    'shibuya' => 'AREAL2125',
    'shinjuku' => 'AREAL2115'
}
