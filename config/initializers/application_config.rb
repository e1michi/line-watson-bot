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

#
# カテゴリーコード変換テーブル
#

GNAVI_CATEGORY_CODE = {
    'all' => '',
    'izakaya' => 'RSFST09000',
    'japanese' => 'RSFST01000',
    'sushi' => 'RSFST03000',
    'yakiniku' => 'RSFST05000',
    'okonomiyaki' => 'RSFST07000',
    'italian' => 'RSFST11000',
    'french' => 'RSFST11000',
    'buffet' => 'RSFST90000',
    'curry' => 'RSFST16000',
    'chinese' => 'RSFST14000',
    'western' => 'RSFST12000',
    'nabe' => 'RSFST04000',
    'asian' => 'RSFST15000',
    'ethnic' => 'RSFST15000',
    'ramen' => 'RSFST08000',
    'bar' => 'RSFST10000',
    'dining' => 'RSFST10000',
    'cafe' => 'RSFST18000',
    'sweets' => 'RSFST18000',
    'party' => 'RSFST19000',
    'karaoke' => 'RSFST19000',
    'entertainment' => 'RSFST19000',
    'family' => 'RSFST20000',
    'firstfood' => 'RSFST20000'
}

# "category_l":[
# {"category_l_code":"RSFST09000","category_l_name":"居酒屋"},
# {"category_l_code":"RSFST02000","category_l_name":"日本料理・郷土料理"},
# {"category_l_code":"RSFST03000","category_l_name":"すし・魚料理・シーフード"},
# {"category_l_code":"RSFST04000","category_l_name":"鍋"},
# {"category_l_code":"RSFST05000","category_l_name":"焼肉・ホルモン"},
# {"category_l_code":"RSFST06000","category_l_name":"焼き鳥・肉料理・串料理"},
# {"category_l_code":"RSFST01000","category_l_name":"和食"},
# {"category_l_code":"RSFST07000","category_l_name":"お好み焼き・粉物"},
# {"category_l_code":"RSFST08000","category_l_name":"ラーメン・麺料理"},
# {"category_l_code":"RSFST14000","category_l_name":"中華"},
# {"category_l_code":"RSFST11000","category_l_name":"イタリアン・フレンチ"},
# {"category_l_code":"RSFST13000","category_l_name":"洋食"},
# {"category_l_code":"RSFST12000","category_l_name":"欧米・各国料理"},
# {"category_l_code":"RSFST16000","category_l_name":"カレー"},
# {"category_l_code":"RSFST15000","category_l_name":"アジア・エスニック料理"},
# {"category_l_code":"RSFST17000","category_l_name":"オーガニック・創作料理"},
# {"category_l_code":"RSFST10000","category_l_name":"ダイニングバー・バー・ビアホール"},
# {"category_l_code":"RSFST21000","category_l_name":"お酒"},
# {"category_l_code":"RSFST18000","category_l_name":"カフェ・スイーツ"},
# {"category_l_code":"RSFST19000","category_l_name":"宴会・カラオケ・エンターテイメント"},
# {"category_l_code":"RSFST20000","category_l_name":"ファミレス・ファーストフード"},
# {"category_l_code":"RSFST90000","category_l_name":"その他の料理"}
# ]}

#
# エリアコード変換テーブル
#
GNAVI_AREA_CODE = {
    'all' => '',
    'ginza' => 'AREAM2105',
    'yurakucho_hibiya' => 'AREAM2106',
    'tsukiji' => 'AREAM2109',
    'tsukishima' => 'AREAM2927',
    'shinbashi' => 'AREAM2107',
    'shinjuku' => 'AREAM2115',
    'okubo' => 'AREAM2122',
    'takadanobaba' => 'AREAM2123',
    'waseda' => 'AREAM2935',
    'shibuya' => 'AREAM2126',
    'harajuku' => 'AREAM2129',
    'omotesando_aoyama' => 'AREAM2130',
    'ikebukuro' => 'AREAM2157',
    'mejiro' => 'AREAM2159',
    'otsuka' => 'AREAM2160',
    'marunouchi' => 'AREAM2141',
    'otemachi' => 'AREAM2940',
    'nihonbashi' => 'AREAM2143',
    'kyobashi' => 'AREAM2942',
    'akasaka' => 'AREAM2133',
    'toranomon' => 'AREAM2136',
    'kamiyacho' => 'AREAM2945',
    'roppongi' => 'AREAM2132',
    'nishiazabu' => 'AREAM2946',
    'hiroo' => 'AREAM2138',
    'azabujuban' => 'AREAM2947',
    'shirokane' => 'AREAM2137',
    'ueno' => 'AREAM2198',
    'okachimachi' => 'AREAM2948',
    'yushima' => 'AREAM2949',
    'asakusa' => 'AREAM2205',
    'nezu' => 'AREAM2951',
    'sendagi' => 'AREAM2202',
    'kanda' => 'AREAM2142',
    'akihabara' => 'AREAM2200',
    'ochanomizu' => 'AREAM2184',
    'jinbocho' => 'AREAM2952',
    'suidobashi' => 'AREAM2953',
    'iidabashi' => 'AREAM2187',
    'kudanshita' => 'AREAM2956',
    'kagurazaka' => 'AREAM2192',
    'ichigaya' => 'AREAM2195',
    'yotsuya' => 'AREAM2957',
    'shinagawa' => 'AREAM2169',
    'gotanda' => 'AREAM2176',
    'osaki' => 'AREAM2960',
    'daiba' => 'AREAM2113',
    'toyosu' => 'AREAM2111',
    'ebisu' => 'AREAM2178',
    'daikanyama' => 'AREAM2964',
    'nakameguro' => 'AREAM2181',
    'meguro' => 'AREAM2180',
    'jiyugaoka' => 'AREAM2164',
    'denenchofu' => 'AREAM2967',
    'sangenjaya' => 'AREAM2166',
    'futagotamagawa' => 'AREAM2168',
    'shimokitazawa' => 'AREAM2207',
    'yoyogiuehara' => 'AREAM2971',
    'takaido' => 'AREAM2973',
    'nakano' => 'AREAM2217',
    'ogikubo' => 'AREAM2976',
    'koenji' => 'AREAM2977',
    'kichijoji' => 'AREAM2276',
    'mitaka' => 'AREAM2981',
    'kinshicho' => 'AREAM2228',
    'oshiage' => 'AREAM2990',
    'ryogoku' => 'AREAM2991',
    'kameido' => 'AREAM2992',
    'ningyocho' => 'AREAM2148',
    'hacchobori' => 'AREAM2996',
    'minamisenju' => 'AREAM3000',
    'machiya' => 'AREAM2241',
    'kitasenju' => 'AREAM2243',
    'ayase' => 'AREAM3001',
    'nishiarai' => 'AREAM3002',
    'itabashi' => 'AREAM2250',
    'akabane' => 'AREAM2248',
    'oji' => 'AREAM3007',
    'fuchu' => 'AREAM2273',
    'chofu' => 'AREAM3012',
    'machida' => 'AREAM2294',
    'tachikawa' => 'AREAM2286',
    'hachioji' => 'AREAM2288'
}

# locations_ja = "銀座 有楽町 日比谷 築地 月島 新橋 新宿 大久保 高田馬場 早稲田 渋谷 原宿 表参道 青山 池袋 目白 大塚 丸の内 大手町 日本橋 京橋 赤坂 虎ノ門 神谷町 六本木 西麻布 広尾 麻布十番 白金 上野 御徒町 湯島 浅草 根津 千駄木 神田 秋葉原 御茶ノ水 神保町 水道橋 飯田橋 九段下 神楽坂 市ヶ谷 四谷 品川 五反田 大崎 台場 豊洲 恵比寿 代官山 中目黒 目黒 自由が丘 田園調布 三軒茶屋 二子玉川 下北沢 代々木上原 高井戸 中野 荻窪 高円寺 吉祥寺 三鷹 錦糸町 押上 両国 亀戸 人形町 八丁堀 南千住 町屋 北千住 綾瀬 西新井 板橋 赤羽 王子 府中 調布 町田 立川 八王子";
# locations_en = "ginza yurakuchoz_hibiya yurakuchoz_hibiya tsukiji tsukishima shinbashi shinjuku okubo takadanobaba waseda shibuya harajuku omotesando_aoyama omotesando_aoyama ikebukuro mejiro otsuka marunouchi otemachi nihonbashi kyobashi akasaka toranomon kamiyacho roppongi nishiazabu hiroo azabujuban shirokane ueno okachimachi yushima asakusa nezu sendagi kanda akihabara ochanomizu jinbocho suidobashi iidabashi kudanshita kagurazaka ichigaya yotsuya shinagawa gotanda osaki daiba toyosu ebisu daikanyama nakameguro meguro jiyugaoka denenchofu sangenjaya futagotamagawa shimokitazawa yoyogiuehara takaido nakano ogikubo koenji kichijoji mitaka kinshicho oshiage ryogoku kameido ningyocho hacchobori minamisenju machiya kitasenju ayase nishiarai itabashi akabane oji fuchu chofu machida tachikawa hachioji";
# foods_ja = "居酒屋 和食 日本料理 寿司 すし 焼肉 ホルモン 鉄板焼き お好み焼き イタリアン イタリア料理 フレンチ フランス料理 バイキング ビュッフェ カレー 中華 中華料理 洋食 西洋料理 鍋 アジアン アジア料理 エスニック料理 ラーメン つけ麺 バー バル ダイニング カフェ スイーツ 宴会 歓迎会 送別会 忘年会 新年会 カラオケ エンターテイメント ファミレス ファーストフード";
# foods_en = "izakaya japanese japanese sushi sushi yakiniku yakiniku okonomiyaki okonomiyaki italian italian french french buffet buffet curry chinese chinese western western nabe asian asian ethnic ramen ramen bar bar dining cafe sweets party party party party party karaoke entertainment family firstfood";
