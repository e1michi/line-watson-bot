#
# ぐるなびAPIに関するモジュール
#
module GnaviModule
  #
  # カテゴリーコード変換テーブル
  #
  GNAVI_CATEGORY_CODE = {
    'izakaya' => 'RSFST09004',
    'japanese' => 'RSFST01015',
    'sushi' => 'RSFST03001',
    'yakiniku' => 'RSFST05001',
    'okonomiyaki' => 'RSFST07001',
    'italian' => 'RSFST11002',
    'french' => 'RSFST11001',
    'buffet' => 'RSFST13001',
    'curry' => 'RSFST16007',
    'chinese' => 'RSFST14007',
    'western' => 'RSFST12012',
    'nabe' => 'RSFST04007',
    'asian' => 'RSFST15013',
    'ethnic' => 'RSFST15013',
    'ramen' => 'RSFST08008',
    'bar' => 'RSFST10005',
    'dining' => 'RSFST10001',
    'cafe' => 'RSFST18001',
    'sweets' => 'RSFST18005',
    'party' => 'RSFST19003',
    'karaoke' => 'RSFST19004',
    'entertainment' => 'RSFST19009',
    'family' => 'RSFST20001',
    'firstfood' => 'RSFST20003'
  }
  
  # {"category_s_code":"RSFST09004","category_s_name":"居酒屋","category_l_code":"RSFST09000"},
  # {"category_s_code":"RSFST02001","category_s_name":"懐石料理","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02002","category_s_name":"会席料理","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02003","category_s_name":"割烹","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02004","category_s_name":"小料理","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST06007","category_s_name":"すき焼き","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST06008","category_s_name":"しゃぶしゃぶ","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02005","category_s_name":"沖縄料理","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02006","category_s_name":"郷土料理","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02007","category_s_name":"ほうとう","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02008","category_s_name":"きりたんぽ鍋","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02009","category_s_name":"釜飯(釜めし)","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02010","category_s_name":"京料理","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02011","category_s_name":"おばんざい","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02012","category_s_name":"精進料理","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST02014","category_s_name":"料亭","category_l_code":"RSFST02000"},
  # {"category_s_code":"RSFST03001","category_s_name":"寿司","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03002","category_s_name":"回転寿司","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03014","category_s_name":"海鮮丼","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03003","category_s_name":"刺身・海鮮料理","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03004","category_s_name":"かに料理","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03005","category_s_name":"ふぐ料理・てっちり","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03006","category_s_name":"すっぽん料理","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03007","category_s_name":"うなぎ","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03008","category_s_name":"どじょう料理","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03009","category_s_name":"はも料理","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03010","category_s_name":"シーフード料理","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03015","category_s_name":"牡蠣料理（かき料理）","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03011","category_s_name":"オイスターバー","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03012","category_s_name":"鯨料理","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03016","category_s_name":"あなご料理","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST03013","category_s_name":"すし・魚料理 その他","category_l_code":"RSFST03000"},
  # {"category_s_code":"RSFST04001","category_s_name":"鍋料理","category_l_code":"RSFST04000"},
  # {"category_s_code":"RSFST04002","category_s_name":"ちゃんこ鍋","category_l_code":"RSFST04000"},
  # {"category_s_code":"RSFST04003","category_s_name":"水炊き","category_l_code":"RSFST04000"},
  # {"category_s_code":"RSFST04004","category_s_name":"もつ鍋","category_l_code":"RSFST04000"},
  # {"category_s_code":"RSFST04005","category_s_name":"火鍋","category_l_code":"RSFST04000"},
  # {"category_s_code":"RSFST04007","category_s_name":"鍋 その他","category_l_code":"RSFST04000"},
  # {"category_s_code":"RSFST05001","category_s_name":"焼肉","category_l_code":"RSFST05000"},
  # {"category_s_code":"RSFST05004","category_s_name":"サムギョプサル","category_l_code":"RSFST05000"},
  # {"category_s_code":"RSFST05002","category_s_name":"ホルモン","category_l_code":"RSFST05000"},
  # {"category_s_code":"RSFST05003","category_s_name":"ジンギスカン","category_l_code":"RSFST05000"},
  # {"category_s_code":"RSFST06001","category_s_name":"牛タン","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06002","category_s_name":"串揚げ","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06003","category_s_name":"焼き鳥","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06004","category_s_name":"鶏料理(鳥料理)","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06005","category_s_name":"炭火焼き・炉端焼き","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06006","category_s_name":"鉄板焼き","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06009","category_s_name":"ステーキ","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06010","category_s_name":"ハンバーグ","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06012","category_s_name":"串焼き","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06013","category_s_name":"豚肉料理","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06014","category_s_name":"馬肉料理","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06015","category_s_name":"串カツ ","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06017","category_s_name":"もつ焼き","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06018","category_s_name":"鴨料理","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST06016","category_s_name":"焼き鳥・肉料理・串料理 その他","category_l_code":"RSFST06000"},
  # {"category_s_code":"RSFST01001","category_s_name":"定食・食事処","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01002","category_s_name":"家庭料理","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01003","category_s_name":"おでん","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01004","category_s_name":"天ぷら","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01005","category_s_name":"とんかつ（トンカツ）","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01006","category_s_name":"丼物","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01007","category_s_name":"親子丼","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01008","category_s_name":"牛丼","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01009","category_s_name":"天丼","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01010","category_s_name":"カツ丼(かつ丼)","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01011","category_s_name":"豆腐料理","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01012","category_s_name":"湯豆腐","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST02013","category_s_name":"湯葉料理(ゆば)","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01013","category_s_name":"弁当屋","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST01015","category_s_name":"和食 その他","category_l_code":"RSFST01000"},
  # {"category_s_code":"RSFST07001","category_s_name":"お好み焼き","category_l_code":"RSFST07000"},
  # {"category_s_code":"RSFST07002","category_s_name":"広島風お好み焼き","category_l_code":"RSFST07000"},
  # {"category_s_code":"RSFST07003","category_s_name":"もんじゃ焼き","category_l_code":"RSFST07000"},
  # {"category_s_code":"RSFST07004","category_s_name":"たこ焼き","category_l_code":"RSFST07000"},
  # {"category_s_code":"RSFST07005","category_s_name":"明石焼き","category_l_code":"RSFST07000"},
  # {"category_s_code":"RSFST07006","category_s_name":"焼きそば","category_l_code":"RSFST07000"},
  # {"category_s_code":"RSFST07008","category_s_name":"お好み焼き・粉物 その他","category_l_code":"RSFST07000"},
  # {"category_s_code":"RSFST08001","category_s_name":"そば","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST08002","category_s_name":"うどん","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST08003","category_s_name":"讃岐うどん","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST08004","category_s_name":"カレーうどん","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST08005","category_s_name":"ちゃんぽん","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST08006","category_s_name":"沖縄そば","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST08007","category_s_name":"冷麺","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST08008","category_s_name":"ラーメン","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST08009","category_s_name":"つけ麺","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST08012","category_s_name":"担々麺","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST08013","category_s_name":"刀削麺","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST08011","category_s_name":"ラーメン・麺料理 その他","category_l_code":"RSFST08000"},
  # {"category_s_code":"RSFST14001","category_s_name":"広東料理","category_l_code":"RSFST14000"},
  # {"category_s_code":"RSFST14002","category_s_name":"北京料理","category_l_code":"RSFST14000"},
  # {"category_s_code":"RSFST14003","category_s_name":"四川料理","category_l_code":"RSFST14000"},
  # {"category_s_code":"RSFST14004","category_s_name":"上海料理","category_l_code":"RSFST14000"},
  # {"category_s_code":"RSFST14005","category_s_name":"台湾料理","category_l_code":"RSFST14000"},
  # {"category_s_code":"RSFST14006","category_s_name":"香港料理","category_l_code":"RSFST14000"},
  # {"category_s_code":"RSFST14007","category_s_name":"中華料理","category_l_code":"RSFST14000"},
  # {"category_s_code":"RSFST14008","category_s_name":"餃子","category_l_code":"RSFST14000"},
  # {"category_s_code":"RSFST14009","category_s_name":"飲茶・点心","category_l_code":"RSFST14000"},
  # {"category_s_code":"RSFST14010","category_s_name":"チャーハン","category_l_code":"RSFST14000"},
  # {"category_s_code":"RSFST14011","category_s_name":"中華 その他","category_l_code":"RSFST14000"},
  # {"category_s_code":"RSFST11001","category_s_name":"フレンチ(フランス料理)","category_l_code":"RSFST11000"},
  # {"category_s_code":"RSFST11002","category_s_name":"イタリアン(イタリア料理)","category_l_code":"RSFST11000"},
  # {"category_s_code":"RSFST11003","category_s_name":"パスタ","category_l_code":"RSFST11000"},
  # {"category_s_code":"RSFST11004","category_s_name":"ピザ","category_l_code":"RSFST11000"},
  # {"category_s_code":"RSFST11005","category_s_name":"ビストロ","category_l_code":"RSFST11000"},
  # {"category_s_code":"RSFST13001","category_s_name":"バイキング・ビュッフェ","category_l_code":"RSFST13000"},
  # {"category_s_code":"RSFST13003","category_s_name":"洋食屋","category_l_code":"RSFST13000"},
  # {"category_s_code":"RSFST13004","category_s_name":"オムレツ・オムライス","category_l_code":"RSFST13000"},
  # {"category_s_code":"RSFST13005","category_s_name":"スープ","category_l_code":"RSFST13000"},
  # {"category_s_code":"RSFST13006","category_s_name":"ハヤシライス","category_l_code":"RSFST13000"},
  # {"category_s_code":"RSFST13007","category_s_name":"シチュー","category_l_code":"RSFST13000"},
  # {"category_s_code":"RSFST13008","category_s_name":"チーズフォンデュ","category_l_code":"RSFST13000"},
  # {"category_s_code":"RSFST13010","category_s_name":"洋食 その他","category_l_code":"RSFST13000"},
  # {"category_s_code":"RSFST12001","category_s_name":"スペイン料理","category_l_code":"RSFST12000"},
  # {"category_s_code":"RSFST12002","category_s_name":"ドイツ料理","category_l_code":"RSFST12000"},
  # {"category_s_code":"RSFST12003","category_s_name":"ロシア料理","category_l_code":"RSFST12000"},
  # {"category_s_code":"RSFST12004","category_s_name":"地中海料理","category_l_code":"RSFST12000"},
  # {"category_s_code":"RSFST12005","category_s_name":"欧風料理","category_l_code":"RSFST12000"},
  # {"category_s_code":"RSFST12006","category_s_name":"カリフォルニア料理","category_l_code":"RSFST12000"},
  # {"category_s_code":"RSFST12007","category_s_name":"アメリカ料理","category_l_code":"RSFST12000"},
  # {"category_s_code":"RSFST12008","category_s_name":"ケイジャン料理","category_l_code":"RSFST12000"},
  # {"category_s_code":"RSFST12009","category_s_name":"パシフィックリム","category_l_code":"RSFST12000"},
  # {"category_s_code":"RSFST12010","category_s_name":"ハワイアン料理","category_l_code":"RSFST12000"},
  # {"category_s_code":"RSFST12012","category_s_name":"欧米・各国料理 その他","category_l_code":"RSFST12000"},
  # {"category_s_code":"RSFST16001","category_s_name":"インドカレー","category_l_code":"RSFST16000"},
  # {"category_s_code":"RSFST16002","category_s_name":"タイカレー","category_l_code":"RSFST16000"},
  # {"category_s_code":"RSFST16003","category_s_name":"スープカレー","category_l_code":"RSFST16000"},
  # {"category_s_code":"RSFST16005","category_s_name":"カレーライス","category_l_code":"RSFST16000"},
  # {"category_s_code":"RSFST16007","category_s_name":"カレー その他","category_l_code":"RSFST16000"},
  # {"category_s_code":"RSFST15001","category_s_name":"韓国料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15002","category_s_name":"タイ料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15003","category_s_name":"インドネシア料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15004","category_s_name":"ベトナム料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15005","category_s_name":"インド料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15006","category_s_name":"ネパール料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15007","category_s_name":"トルコ料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15008","category_s_name":"アフリカ料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15009","category_s_name":"メキシコ料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15010","category_s_name":"ブラジル料理・南米料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15011","category_s_name":"モンゴル料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15014","category_s_name":"中近東料理","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST15013","category_s_name":"アジア・エスニック料理 その他","category_l_code":"RSFST15000"},
  # {"category_s_code":"RSFST17001","category_s_name":"創作和食","category_l_code":"RSFST17000"},
  # {"category_s_code":"RSFST17002","category_s_name":"創作料理","category_l_code":"RSFST17000"},
  # {"category_s_code":"RSFST17003","category_s_name":"薬膳料理","category_l_code":"RSFST17000"},
  # {"category_s_code":"RSFST17004","category_s_name":"オーガニック料理","category_l_code":"RSFST17000"},
  # {"category_s_code":"RSFST17005","category_s_name":"無国籍料理","category_l_code":"RSFST17000"},
  # {"category_s_code":"RSFST17007","category_s_name":"野菜料理","category_l_code":"RSFST17000"},
  # {"category_s_code":"RSFST10001","category_s_name":"ダイニングバー","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10002","category_s_name":"レストランバー","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10003","category_s_name":"ビアレストラン","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10004","category_s_name":"ビアホール","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10005","category_s_name":"バー","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10006","category_s_name":"ショットバー","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10007","category_s_name":"アイリッシュパブ","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10008","category_s_name":"ワインバー","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10009","category_s_name":"焼酎バー","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10010","category_s_name":"立ち飲み","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10011","category_s_name":"ダーツバー・ゴルフバー","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10012","category_s_name":"パブ・スナック","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10013","category_s_name":"クラブ・ラウンジ","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST10014","category_s_name":"スペインバル・イタリアンバール","category_l_code":"RSFST10000"},
  # {"category_s_code":"RSFST21001","category_s_name":"日本酒","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST21002","category_s_name":"焼酎","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST21003","category_s_name":"泡盛","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST21004","category_s_name":"ビール","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST21005","category_s_name":"紹興酒・中国酒","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST21006","category_s_name":"マッコリ","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST21007","category_s_name":"ワイン","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST21008","category_s_name":"カクテル","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST21009","category_s_name":"ウイスキー","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST21010","category_s_name":"ブランデー","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST21011","category_s_name":"スピリッツ","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST21013","category_s_name":"お酒 その他","category_l_code":"RSFST21000"},
  # {"category_s_code":"RSFST18001","category_s_name":"カフェ","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18002","category_s_name":"喫茶店・軽食","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18015","category_s_name":"クレープ","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18016","category_s_name":"パフェ","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18003","category_s_name":"甘味処","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18004","category_s_name":"フルーツパーラー","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18005","category_s_name":"ケーキ屋・スイーツ","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18006","category_s_name":"アイスクリーム","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18007","category_s_name":"パン屋・サンドイッチ","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST06011","category_s_name":"ハンバーガー","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18008","category_s_name":"コーヒー","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18009","category_s_name":"紅茶","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18010","category_s_name":"日本茶","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18011","category_s_name":"中国茶","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18012","category_s_name":"ハーブティ","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18013","category_s_name":"ジュース","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST18014","category_s_name":"カフェ・スイーツ その他","category_l_code":"RSFST18000"},
  # {"category_s_code":"RSFST19001","category_s_name":"パーティールーム・スペース","category_l_code":"RSFST19000"},
  # {"category_s_code":"RSFST19002","category_s_name":"バンケットルーム","category_l_code":"RSFST19000"},
  # {"category_s_code":"RSFST19003","category_s_name":"宴会場","category_l_code":"RSFST19000"},
  # {"category_s_code":"RSFST19004","category_s_name":"カラオケボックス","category_l_code":"RSFST19000"},
  # {"category_s_code":"RSFST19005","category_s_name":"漫画喫茶","category_l_code":"RSFST19000"},
  # {"category_s_code":"RSFST19006","category_s_name":"インターネットカフェ","category_l_code":"RSFST19000"},
  # {"category_s_code":"RSFST19007","category_s_name":"テーマパークレストラン","category_l_code":"RSFST19000"},
  # {"category_s_code":"RSFST19008","category_s_name":"アミューズメント","category_l_code":"RSFST19000"},
  # {"category_s_code":"RSFST19009","category_s_name":"ライブハウス・クラブ(踊る)","category_l_code":"RSFST19000"},
  # {"category_s_code":"RSFST19010","category_s_name":"クルージング","category_l_code":"RSFST19000"},
  # {"category_s_code":"RSFST19011","category_s_name":"屋形船","category_l_code":"RSFST19000"},
  # {"category_s_code":"RSFST20001","category_s_name":"ファミリーレストラン","category_l_code":"RSFST20000"},
  # {"category_s_code":"RSFST20002","category_s_name":"ファーストカジュアル","category_l_code":"RSFST20000"},
  # {"category_s_code":"RSFST20003","category_s_name":"ファーストフード","category_l_code":"RSFST20000"},
  # {"category_s_code":"RSFST90001","category_s_name":"その他の料理","category_l_code":"RSFST90000"}

  #
  # エリアコード変換テーブル
  #
  GNAVI_AREA_CODE = {
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

  #
  # APIの実行結果格納クラス
  #
  class GnaviResult
    attr_accessor :status, :body
  end

  #
  # レストラン検索APIの実装クラス
  #
  class RestaurantSearch
    include LoggerModule

    def initialize(endpoint, key)
      @endpoint = endpoint
      @key = key
    end

    def search_with_category_area(category, area)
      debug("category=#{category.inspect}, area=#{area.inspect}")
    
      connection = Faraday.new(:url => @endpoint) do | builder |
        builder.request :json
        builder.response :json
        builder.adapter Faraday.default_adapter
      end

      category_code = get_category_code(category)
      area_code = get_area_code(area)
      
      response = connection.get do | request |
        request.url '/RestSearchAPI/20150630'
        request.headers = {
          'Content-Type' => 'application/json; charset=UTF-8',
        }
        request.params['keyid'] = @key
        request.params['format'] = 'json'
        request.params['hit_per_page'] = 5
        if category_code
          request.params['category_s'] = category_code
        end
        request.params['pref'] = 'PREF13'
        if area_code
          request.params['areacode_m'] = area_code
        end
      end

      result = GnaviResult.new
      if response.status == 200
        debug("response=#{response.inspect}")
        result.status = 0
        result.body = response.body
      else
        error("response=#{response.inspect}")
        result.status = -1
      end
    
      return result
    end
    
    private
    def get_category_code(category)
      return GNAVI_CATEGORY_CODE[category]
    end

    def get_area_code(area)
      return GNAVI_AREA_CODE[area]
    end
  end
end
