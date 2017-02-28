#
# LINE Bot Controller
#
class LineBotController < ApplicationController
  #
  # Webhook以外の処理を除外
  #
  protect_from_forgery :except => [:universe, :gnavi] # For CSRF

  #
  # Webhook処理(universe)
  #
  def universe
    # リクエスト元のチェック
    unless is_validated_request
      render json: [], status: 470
    end

    # リクエストデータ処理（複数）
    params[:events].each do | item |
      # イベントモデルの生成
      model = LineModule::EventModel.new item

      # テキストの抽出
      case model.message.type
      when 'text' then
        # テキストの場合はそのまま
        text = model.message.text;
      when 'audio' then
        # 音声データはWatson STT経由でテキストを抽出
        sttc = WatsonModule::SpeechToTextClient.new
        response = sttc.getText(model.message.id)
        next unless response.status == 200
        text = response.body
      else
        next
      end

      # Watson R&Rの呼び出し
      rarc = WatsonModule::RetrieveAndRankClient.new(
        WATSON_RAR_ENDPOINT, WATSON_RAR_USERNAME, WATSON_RAR_PASSWORD,
        WATSON_RAR_CLUSTER_ID, WATSON_RAR_RANKER_ID,
        WATSON_RAR_DATA_FIELDS, WATSON_RAR_DATA_ROWS)
      result = rarc.think(text)

      if result.status == 0
        body = result.body
        if body['response']['numFound'] > 0
          text = body['response']['docs'][0]['body'][0]
        else
          text = '答えが見つかりませんでした。'
        end
      else
        text = 'エラーが起きました。'
      end
      
      # LINEサービスへのテキスト送信
      rc = LineModule::ReplyClient.new(LINE_ENDPOINT, LINE_CHANNEL_ACCESS_TOKEN)
      rc.reply_message(model.replyToken, text)
    end

    # 常に正常ステータスを返す（仕様）
    render json: [], status: :ok
  end

  #
  # Webhook処理(gnavi)
  #
  def gnavi
    # リクエスト元のチェック
    unless is_validated_request
      render json: [], status: 470
    end

    # リクエストデータ処理（複数）
    params[:events].each do | item |
      # イベントモデルの生成
      model = LineModule::EventModel.new item

      # テキストの抽出
      case model.message.type
      when 'text' then
        # テキストの場合はそのまま
        text = model.message.text;
      else
        next
      end

      # Watson NLCの呼び出し
      nlcc = WatsonModule::NaturalLanguageClassifierClient.new(
        WATSON_NLC_ENDPOINT, WATSON_NLC_USERNAME, WATSON_NLC_PASSWORD,
        WATSON_NLC_CLASSIFIER_ID)
      result = nlcc.think(text)

      text = ""
      if result.status == 0
        if result.body['classes'][0]['confidence'] < 0.8
          text = '条件を変更してください。'
        end
      else
        text = 'エラーが起きました。'
      end

      if text != ""
        # LINEサービスへのテキスト送信
        rc = LineModule::ReplyClient.new(LINE_ENDPOINT, LINE_CHANNEL_ACCESS_TOKEN)
        rc.reply_text_message(model.replyToken, text)
        next
      end

      cond = result.body['classes'][0]['class_name'].split('@')
      rs = GnaviModule::RestaurantSearch.new(GNAVI_ENDPOINT, GNAVI_ACCESS_KEY)
      result = rs.search_with_pref(cond[0], 'PREF13')

      # LINEサービスへのテキスト送信
      rc = LineModule::ReplyClient.new(LINE_ENDPOINT, LINE_CHANNEL_ACCESS_TOKEN)
      rc.reply_text_message(model.replyToken, result)
    end

    # 常に正常ステータスを返す（仕様）
    render json: [], status: :ok
  end

  private
  def is_validated_request
    if Rails.env == 'production'
      # プロダクション環境時のみ
      unless is_validate_signature
        # 他サイトからのリクエストを除外
        return false
      end
    end
    
    return true
  end
end

{
  "@attributes":{
    "api_version":"20150630"
    
  },
  "total_hit_count":"4688",
  "hit_per_page":"10",
  "page_offset":"1",
  "rest":[
    {
      "@attributes":{
        "order":"0"
        
      },
      "id":"p387901",
      "update_date":"2017-02-28 03:29:53",
      "name":"個室イタリアン 創作バル くらうど 新宿店",
      "name_kana":"コシツイタリアンソウサクバルクラウド シンジュクテン",
      "latitude":"35.682247",
      "longitude":"139.704403",
      "category":"TVメディア出演多数♪",
      "url":"https:\/\/r.gnavi.co.jp\/r91010wu0000\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D",
      "url_mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/p387901\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D",
      "coupon_url":{
        "pc":"https:\/\/r.gnavi.co.jp\/r91010wu0000\/coupon\/",
        "mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/p387901\/coupon"
        
      },
      "image_url":{
        "shop_image1":"https:\/\/uds.gnst.jp\/rest\/img\/r91010wu0000\/t_000c.jpg",
        "shop_image2":{},
        "qrcode":"https:\/\/c-r.gnst.jp\/tool\/qr\/?id=p387901&q=6"
        
      },
      "address":"〒151-0053 東京都渋谷区代々木1-60-11 東興本社ビル1F",
      "tel":"050-3476-7994",
      "tel_sub":"03-5333-5570","fax":{},"opentime":"水～金 11:30～23:00(L.O.22:00、ドリンクL.O.22:30)(17：00～17：30 一時クローズいたします。)<BR>土・日・祝日 11:30～23:00(L.O.22:00、ドリンクL.O.22:30)","holiday":"毎週月・火曜日<BR>※お盆・年末年始 不定休","access":{"line":"ＪＲ","station":"新宿駅","station_exit":"新南口","walk":"4","note":{}},"parking_lots":{},"pr":{"pr_short":"話題の創作イタリアン♪ 《テレビ出演多数♪》新宿駅・代々木駅すぐ！ 自慢のイタリアンコース2500円～◎個室完備♪ 新宿・代々木での飲み会や宴会、女子会や接待にも◎","pr_long":"“創作イタリアンを個室で楽しむ くらうど 新宿店”<BR>◆『王様のブランチ』『ひるおび！』『めざましテレビ』『ZIP!』などメディア掲載多数！<BR>…イタリアンをメインとした素材本来の旨味を最大限に引き出した自慢の逸品料理<BR>新宿や代々木の喧騒を忘れる、ほっと一息つくようなメニューをご堪能あれ♪<BR><BR>◆世界各国より厳選!!極上ワインを多数♪<BR>…シェフがこだわりを持って取り寄せたワインを全10種類以上！<BR>値段もリーズナブルにご提供！当店自慢の創作イタリアンとの相性も抜群♪<BR><BR>◆洗練された大人の為のプライベート個室<BR>…木の温もりと煌びやかな光が演出する優雅な個室！<BR>個室は2名様～団体様まで。合コンや女子会などの宴会に最適♪<BR><BR>◆休日限定！テレビに紹介されたビュッフェも必見♪<BR><BR>《新宿・代々木での宴会や接待、合コンや女子会などの宴会に◎》"},"code":{"areacode":"AREA110","areaname":"関東","prefcode":"PREF13","prefname":"東京都","areacode_s":"AREAS2118","areaname_s":"新宿南口・代々木","category_code_l":["RSFST11000",{"@attributes":{"order":"1"}}],"category_name_l":["イタリアン・フレンチ",{"@attributes":{"order":"1"}}],"category_code_s":["RSFST11002",{"@attributes":{"order":"1"}}],"category_name_s":["イタリアン(イタリア料理)",{"@attributes":{"order":"1"}}]},"budget":"3000","party":"4000","lunch":"1100","credit_card":{},"e_money":{},"flags":{"mobile_site":"1","mobile_coupon":"1","pc_coupon":"1"}},{"@attributes":{"order":"1"},"id":"ga57901","update_date":"2017-02-14 18:34:13","name":"個室イタリアン ATTIC 神楽坂","name_kana":"コシツイタリアンアティック カグラザカ","latitude":"35.699050","longitude":"139.743433","category":"隠れ家古民家イタリアン","url":"https:\/\/r.gnavi.co.jp\/g0zcumgr0000\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","url_mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/ga57901\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","coupon_url":{"pc":{},"mobile":{}},"image_url":{"shop_image1":"https:\/\/uds.gnst.jp\/rest\/img\/g0zcumgr0000\/t_000k.jpg","shop_image2":{},"qrcode":"https:\/\/c-r.gnst.jp\/tool\/qr\/?id=ga57901&q=6"},"address":"〒162-0825 東京都新宿区神楽坂4-5-4 2F","tel":"050-3462-2037","tel_sub":"03-6457-5975","fax":{},"opentime":" 18:00～翌4:00(L.O.3:30)","holiday":"毎週日曜日<BR>年末年始（2015年12月31日～2016年1月3日）<BR>※※（日）が祝前日の場合は、翌日休み  ※（日）貸切・パーティー事前予約はご相談","access":{"line":"ＪＲ総武線","station":"飯田橋駅","station_exit":"西口","walk":"6","note":{}},"parking_lots":{},"pr":{"pr_short":"神楽坂に隠れ家古民家イタリアン！ 産地直送の季節の野菜と、厳選ワインのお店！ ■コース\\5,000～（2h飲み放題付） ■個室8～18名様可能！少人数パーティーに最適♪","pr_long":"【神楽坂】隠れ家イタリアン☆<BR>古民家を改装したカジュアルスタイルイタリアン！！<BR>シェフが厳選した産地直送の季節野菜をふんだんに使用したヘルシーイタリアン！<BR>調理場の温度感が伝わるオープンキッチン☆<BR>■本格イタリアンをリーズナブルに■<BR>・イタリア産のチーズや国産の厳選野菜、鮮魚などこだわり食材を使用。<BR>■厳選ワイン■<BR>・シェフが飲み歩き厳選したワインが楽しめます。<BR>・稀少なイタリアンワインなどもラインナップ。<BR>■古民家貸切■<BR>・20～30名様の店内貸切が可能！<BR>・少人数での貸切パーティーにも最適！<BR>■個室■<BR>・ラウンジ風のゆったりソファー席♪<BR> ・8～18名様でのご利用が可能！<BR>■カウンター席■<BR>・実際の調理を見ながら、出来立てを召し上がれます！<BR>・カップルや会食などにもおすすめ。"},"code":{"areacode":"AREA110","areaname":"関東","prefcode":"PREF13","prefname":"東京都","areacode_s":"AREAS2192","areaname_s":"神楽坂","category_code_l":["RSFST11000","RSFST11000"],"category_name_l":["イタリアン・フレンチ","イタリアン・フレンチ"],"category_code_s":["RSFST11002","RSFST11005"],"category_name_s":["イタリアン(イタリア料理)","ビストロ"]},"budget":"5000","party":"5000","lunch":{},"credit_card":{},"e_money":{},"flags":{"mobile_site":"1","mobile_coupon":"0","pc_coupon":"0"}},{"@attributes":{"order":"2"},"id":"gf40102","update_date":"2017-02-20 03:28:21","name":"シーフードイタリアンEn シェアキッチン町田店","name_kana":"シーフードイタリアンエン シェアキッチンマチダテン","latitude":"35.541814","longitude":"139.449344","category":"シーフードイタリアン","url":"https:\/\/r.gnavi.co.jp\/patmthnd0000\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","url_mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/gf40102\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","coupon_url":{"pc":{},"mobile":{}},"image_url":{"shop_image1":"https:\/\/uds.gnst.jp\/rest\/img\/patmthnd0000\/t_0n5c.jpg","shop_image2":"https:\/\/uds.gnst.jp\/rest\/img\/patmthnd0000\/t_0n5d.jpg","qrcode":"https:\/\/c-r.gnst.jp\/tool\/qr\/?id=gf40102&q=6"},"address":"〒194-0013 東京都町田市原町田6-15-16 コヤマビル2F","tel":"042-785-4775","tel_sub":{},"fax":{},"opentime":"月～木・日・祝日 16:00～翌1:00(L.O.24:00、ドリンクL.O.24:30)<BR>金・土・祝前日 16:00～翌5:00","holiday":"無","access":{"line":"小田急小田原線","station":"町田駅","station_exit":"東口","walk":"1","note":{}},"parking_lots":{},"pr":{"pr_short":"◆【小田急小田原線 町田駅 東口 徒歩1分】 ◆新鮮なマグロやヤリイカを使用した、贅沢な海鮮イタリアン♪ ◆送別会・歓迎会等の宴会もOK!!2時間飲放題付 4,000円(税抜)","pr_long":"町田駅から徒歩1分にある、アクセス良好なお店「シーフードイタリアンEn」。<BR>新鮮なマグロや白子、ヤリイカを使用した贅沢な海鮮イタリアンを<BR>リーズナブルな価格にてご提供！<BR>高コスパな大満足なイタリアンをお出しいたします。<BR>◆宴会◆<BR>2時間飲放題付 4000円(税抜) 7品<BR>シーフード・イタリアンをお腹いっぱい堪能♪<BR><BR>◆料理◆<BR>・名物！漁師の海鮮地獄蒸し！ …880円（税抜）<BR>・名物！マグロレアカツ …580円（税抜）<BR>・フィッシュオイスター（生牡蠣） …300円（税抜）<BR>・はみだしカルパッチョ盛り！ …680円（税抜）<BR>◆ドリンク◆<BR>・プレミアムモルツ …490円（税抜）<BR>・角ハイボール  …420円（税抜）<BR>広々としたおしゃれな店内で、ごゆっくりお楽しみください！"},"code":{"areacode":"AREA110","areaname":"関東","prefcode":"PREF13","prefname":"東京都","areacode_s":"AREAS2929","areaname_s":"町田","category_code_l":["RSFST11000","RSFST03000"],"category_name_l":["イタリアン・フレンチ","すし・魚料理・シーフード"],"category_code_s":["RSFST11002","RSFST03003"],"category_name_s":["イタリアン(イタリア料理)","刺身・海鮮料理"]},"budget":"3000","party":"4000","lunch":{},"credit_card":{},"e_money":{},"flags":{"mobile_site":"1","mobile_coupon":"0","pc_coupon":"0"}},{"@attributes":{"order":"3"},"id":"getg102","update_date":"2017-02-22 00:43:44","name":"イタリアンバル×夜景個室 Carne Garden ‐カルネ‐ 渋谷店","name_kana":"イタリアンバルヤケイコシツカルネガーデン シブヤテン","latitude":"35.657028","longitude":"139.708731","category":"渋谷 夜景個室 肉バル","url":"https:\/\/r.gnavi.co.jp\/mt8wmkgc0000\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","url_mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/getg102\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","coupon_url":{"pc":"https:\/\/r.gnavi.co.jp\/mt8wmkgc0000\/coupon\/","mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/getg102\/coupon"},"image_url":{"shop_image1":"https:\/\/uds.gnst.jp\/rest\/img\/mt8wmkgc0000\/t_0n5c.jpg","shop_image2":{},"qrcode":"https:\/\/c-r.gnst.jp\/tool\/qr\/?id=getg102&q=6"},"address":"〒150-0002 東京都渋谷区渋谷1-8-5 小山ビル4F","tel":"050-3476-0680","tel_sub":"03-6635-6512","fax":{},"opentime":" ディナー：17:00～24:00、ランチ：11:30～15:00","holiday":"無<BR>※年中無休で営業しております！急なご予約、ご相談お気軽にお問い合わせ下さい！","access":{"line":"ＪＲ","station":"渋谷駅","station_exit":"ハチ公口","walk":"3","note":{}},"parking_lots":{},"pr":{"pr_short":"渋谷駅ハチ公口徒歩3分 夜景席 渋谷の夜景と共に本格イタリアンを楽しむ！ 週末も3時間飲み放題付きプラン！！2980円～ 本格イタリアンは500円～歓迎会,送別会に◎","pr_long":"渋谷の街の夜景を見渡せる開放的でカジュアルなイタリアン肉バル！<BR>本格的なイタリアンをリーズナブルな価格で提供します！<BR>渋谷の街を眺めながら素敵な時間をお過ごしください。<BR>≪渋谷の夜景と共に楽しめる定番アラカルト≫<BR>ブルスケッタやカプレーゼなどのタパスメニューを始め<BR>肉バルこだわりの肉メニューまでラインナップ豊富に用意しております♪<BR><BR>≪週末でも3時間飲み放題付パーティプラン≫<BR>・トマトチーズ鍋付全8品<BR>『Amelia-アメリア-コース』4500円⇒3500円<BR>・豆乳ごま鍋付全8品<BR>『Claire-クレア-コース』5000円⇒4000円<BR>≪食べ放題付パーティープラン≫<BR>『食べ飲み放題コース』3480円⇒2480円<BR>≪お得なクーポン≫<BR>・毎日使える会計20％オフ<BR>・幹事様必見！コースの予約で幹事様無料！<BR>女子会・パーティ・歓迎会,送別会に。貸切パーティのご予約も◎"},"code":{"areacode":"AREA110","areaname":"関東","prefcode":"PREF13","prefname":"東京都","areacode_s":"AREAS2127","areaname_s":"渋谷東口・宮益坂","category_code_l":["RSFST09000","RSFST11000"],"category_name_l":["居酒屋","イタリアン・フレンチ"],"category_code_s":["RSFST09004","RSFST11002"],"category_name_s":["居酒屋","イタリアン(イタリア料理)"]},"budget":"2000","party":"2480","lunch":"1000","credit_card":{},"e_money":{},"flags":{"mobile_site":"1","mobile_coupon":"1","pc_coupon":"1"}},{"@attributes":{"order":"4"},"id":"b274905","update_date":"2017-02-28 03:44:09","name":"イタリアン＆ワインバル ビアージョ WACCA池袋","name_kana":"イタリアンアンドワインバルビアージョ ワッカイケブクロ","latitude":"35.728283","longitude":"139.717717","category":"個室 貸切 イタリアン","url":"https:\/\/r.gnavi.co.jp\/rf996b980000\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","url_mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/b274905\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","coupon_url":{"pc":"https:\/\/r.gnavi.co.jp\/rf996b980000\/coupon\/","mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/b274905\/coupon"},"image_url":{"shop_image1":"https:\/\/uds.gnst.jp\/rest\/img\/rf996b980000\/t_001f.jpg","shop_image2":{},"qrcode":"https:\/\/c-r.gnst.jp\/tool\/qr\/?id=b274905&q=6"},"address":"〒170-0013 東京都豊島区東池袋1-8-1 WACCA5F","tel":"050-3490-1038","tel_sub":"03-5927-9449","fax":"03-5927-9449","opentime":" 11:00～15:00(L.O.14:30)(※お昼のパーティなど、営業時間外のパーティーもお気軽にご相談下さい。)、17:00～23:00(L.O.22:00、ドリンクL.O.22:30)","holiday":"年中無休<BR>※施設に準じます","access":{"line":"ＪＲ","station":"池袋駅","station_exit":"東口","walk":"3","note":{}},"parking_lots":{},"pr":{"pr_short":"池袋東口3分 お洒落で気軽なイタリアンバル♪ 【貸切可】 シェフ手仕込み本格イタリアンとソムリエ厳選ワイン100種 【2.5時間】飲放付2980円～!主役特典♪","pr_long":"◆レストラン級の料理を気軽なバルスタイルで<BR>仕込みから仕上げまで手間暇惜しまずシェフが手造りするイタリアン<BR>「豚肉の爆弾インボルティーニ」や「鶏もも肉のハーブロースト」といった肉料理は必食<BR>また、ワインと合わせたいタパスメニューも多彩<BR><BR>◆圧巻の品揃え!セラー管理の厳選ワイン<BR> ソムリエが各国から選りすぐった100種をご用意<BR><BR>◆コース料理<BR>《ご宴会》<BR>☆平日限定（月～木）【2.5時間飲み放題付】＜8品＞「お手軽カジュアルコース」3780⇒2980円<BR>《女子会》<BR>☆平日限定（月～木）【3時間飲み放題☆スパークリングワイン・サングリア付】<BR>「11品女子会コース」4320⇒3480円 《2名様～》<BR>⇒誕生日や記念日に♪メッセージデザートサービス 珍しいベジブーケのご用意もございます♪<BR><BR>◆店内<BR>《貸切》40～70名様<BR>《個室》 5～8名様"},"code":{"areacode":"AREA110","areaname":"関東","prefcode":"PREF13","prefname":"東京都","areacode_s":"AREAS2156","areaname_s":"池袋東口・東池袋","category_code_l":["RSFST11000","RSFST10000"],"category_name_l":["イタリアン・フレンチ","ダイニングバー・バー・ビアホール"],"category_code_s":["RSFST11002","RSFST10014"],"category_name_s":["イタリアン(イタリア料理)","スペインバル・イタリアンバール"]},"budget":"3500","party":"4000","lunch":"900","credit_card":"VISA,MasterCard,UC,ダイナースクラブ,アメリカン・エキスプレス,アプラス,セゾン,MUFG","e_money":{},"flags":{"mobile_site":"1","mobile_coupon":"1","pc_coupon":"1"}},{"@attributes":{"order":"5"},"id":"gef0100","update_date":"2017-02-25 00:35:12","name":"イタリアン鉄板焼 ベジたけ ","name_kana":"イタリアンテッパンヤキベジタケ","latitude":"35.691519","longitude":"139.705900","category":"鉄板焼き野菜イタリアン","url":"http:\/\/r.gnavi.co.jp\/9scjcfpe0000\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","url_mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/gef0100\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","coupon_url":{"pc":"http:\/\/r.gnavi.co.jp\/9scjcfpe0000\/coupon\/","mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/gef0100\/coupon"},"image_url":{"shop_image1":"https:\/\/uds.gnst.jp\/rest\/img\/9scjcfpe0000\/t_003h.jpg","shop_image2":"https:\/\/uds.gnst.jp\/rest\/img\/9scjcfpe0000\/t_000i.JPG","qrcode":"https:\/\/c-r.gnst.jp\/tool\/qr\/?id=gef0100&q=6"},"address":"〒160-0021 東京都新宿区歌舞伎町1-11-3 丸石新歌舞伎町ビル2F","tel":"050-5785-4765","tel_sub":"03-6205-9885","fax":{},"opentime":"月～土・祝前日・祝日 19:00～翌5:00","holiday":"毎週日曜日","access":{"line":"ＪＲ","station":"新宿駅","station_exit":{},"walk":"3","note":{}},"parking_lots":{},"pr":{"pr_short":"【新宿駅 徒歩3分】 鴨肉のローストが絶品のイタリアン鉄板焼２Ｈ飲放題付コース4320円 クーポン利用で「飲み放題１時間無料延長」 【少人数で貸切個室】１０～２０名","pr_long":"◆当店のコンセプト◆<BR>◎毎日市場から仕入れる旬の食材を使用<BR>◎ヘルシーな鉄板焼き野菜イタリアンが楽しめる<BR>◎ソファー席でのゆったり空間<BR>◎歌舞伎町の中でも隠れ家として人気<BR>◎ご宴会\/忘年会\/貸切\/記念日・誕生日\/デート\/女子会に最適<BR><BR>◆誕生日・記念日◆<BR>誕生日５大特典をご用意<BR><BR>◆貸切個室◆<BR>◎10～20名様で貸切個室として利用可能<BR>◎貸切10名様～最大20名様までOK♪<BR><BR>◆ご宴会コース◆<BR>◎ 【女性会】カラダにうれしいヘルシーイタリアン鉄板焼＆デザート食べ放題飲み放題付コース（全7品）3500円<BR>◎【飲み会 宴会】カラダにうれしいヘルシーイタリアン鉄板焼２Ｈ飲み放題付コース（全7品）3240円<BR>⇒クーポン利用で3時間飲み放題にも！<BR>◆ イタリアン鉄板焼ベジたけ 050-5785-4765"},"code":{"areacode":"AREA110","areaname":"関東","prefcode":"PREF13","prefname":"東京都","areacode_s":"AREAS2115","areaname_s":"新宿東口・歌舞伎町","category_code_l":["RSFST06000","RSFST09000"],"category_name_l":["焼き鳥・肉料理・串料理","居酒屋"],"category_code_s":["RSFST06006","RSFST09004"],"category_name_s":["鉄板焼き","居酒屋"]},"budget":"4000","party":"4000","lunch":{},"credit_card":{},"e_money":{},"flags":{"mobile_site":"1","mobile_coupon":"1","pc_coupon":"1"}},{"@attributes":{"order":"6"},"id":"ge60101","update_date":"2017-02-21 01:06:41","name":"和・イタリアン酒場 万屋 ","name_kana":"ワイタリアンサカバヨロズヤ","latitude":"35.688100","longitude":"139.770778","category":"和食 イタリアンバル","url":"http:\/\/r.gnavi.co.jp\/f7rzz1j60000\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","url_mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/ge60101\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","coupon_url":{"pc":{},"mobile":{}},"image_url":{"shop_image1":"https:\/\/uds.gnst.jp\/rest\/img\/f7rzz1j60000\/t_0n5w.jpg","shop_image2":"https:\/\/uds.gnst.jp\/rest\/img\/f7rzz1j60000\/t_0n63.jpg","qrcode":"https:\/\/c-r.gnst.jp\/tool\/qr\/?id=ge60101&q=6"},"address":"〒101-0047 東京都千代田区内神田2-12-5 翔和No8神田ビルB1","tel":"050-3476-5753","tel_sub":"03-6206-4363","fax":"03-6206-4363","opentime":"月～土 ランチ：11:40～14:00(L.O.13:30)<BR>月～土 ディナー：17:00～23:30(L.O.23:00)","holiday":"毎週日曜日","access":{"line":"ＪＲ","station":"神田駅","station_exit":"西口","walk":"5","note":{}},"parking_lots":{},"pr":{"pr_short":"神田駅徒歩3分 《和食×イタリアン酒場》 神田初!焼き鳥とワインを楽しめるお店OPEN！ 【最大16名様】和情緒溢れる半個室でゆったりとお食事を","pr_long":"和情緒溢れる店内で和食もイタリアンもお酒も贅沢にお楽しみください♪<BR><BR>◆全6種類のコース<BR>◎飲み放題メインのお客様にオススメ！<BR>【2時間飲み放題付】和・イタリアンコース〈全5品〉3,700円（税別）<BR>◎【＋1,500円】で飲み放題も！アラカルトの注文でも★<BR>焼き鳥イタリアンコース〈全6品〉2,800円（税別）<BR>焼き鳥和食コース  〈全7品〉3,200円（税別）<BR>お魚イタリアンコース 〈全7品〉3,400円（税別）<BR>高級アボカド豚コース 〈全8品〉3,400円（税別）<BR>牛肉尽くしコース  〈全8品〉4,500円（税別）<BR>◆【最大16名様】落ち着いた雰囲気の半個室<BR>デート・女子会・友人との少人数でのお食事、各種ご宴会にも◎<BR>人目を気にせず、ゆったりとお食事をお楽しみ頂けます♪<BR><BR>◆駅チカだから、幹事様も安心♪<BR>神田駅徒歩3分なので、集まりやすくご宴会に最適です！"},"code":{"areacode":"AREA110","areaname":"関東","prefcode":"PREF13","prefname":"東京都","areacode_s":"AREAS2142","areaname_s":"神田","category_code_l":["RSFST09000","RSFST11000"],"category_name_l":["居酒屋","イタリアン・フレンチ"],"category_code_s":["RSFST09004","RSFST11002"],"category_name_s":["居酒屋","イタリアン(イタリア料理)"]},"budget":"3000","party":"3000","lunch":"1000","credit_card":{},"e_money":{},"flags":{"mobile_site":"1","mobile_coupon":"0","pc_coupon":"0"}},{"@attributes":{"order":"7"},"id":"ge4e602","update_date":"2017-02-28 02:07:19","name":"Marinaio～マリナイオ～ 伊太利亜創作酒房 太郎 TARO","name_kana":"マリナイオ イタリアソウサクシュボウタロウ","latitude":"35.730022","longitude":"139.712961","category":"カジュアルイタリアン","url":"https:\/\/r.gnavi.co.jp\/7z427h2g0000\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","url_mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/ge4e602\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","coupon_url":{"pc":"https:\/\/r.gnavi.co.jp\/7z427h2g0000\/coupon\/","mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/ge4e602\/coupon"},"image_url":{"shop_image1":"https:\/\/uds.gnst.jp\/rest\/img\/7z427h2g0000\/t_0053.jpg","shop_image2":"https:\/\/uds.gnst.jp\/rest\/img\/7z427h2g0000\/t_004v.jpg","qrcode":"https:\/\/c-r.gnst.jp\/tool\/qr\/?id=ge4e602&q=6"},"address":"〒171-0014 東京都豊島区池袋2-41-2 葉山ビル1F","tel":"050-3462-6159","tel_sub":"03-6820-8821  (受付：9時～24時)","fax":"03-5928-0520","opentime":"月～日 ランチ：11:30～15:00<BR>月～日 ディナー：17:00～23:30(L.O.23:00)","holiday":"年中無休","access":{"line":"ＪＲ","station":"池袋駅","station_exit":"北口","walk":"3","note":{}},"parking_lots":"50","pr":{"pr_short":"【池袋西口駅すぐ！】話題の三ツ星級本格イタリアン♪ 2H飲み放題×本格イタリアンコース2980円～♪ 期間限定1980円コース！も必見 ⇒池袋での女子会や合コンに◎","pr_long":"《池袋駅すぐ！隠れ家イタリアン Marinaio ～マリナイオ～ 池袋店》<BR>◆本格イタリアンコースを2980円でご利用頂けます！女子会1980円6品飲み放題付きも<BR>誕生！ご予算に応じて様々なパーティーをお楽しみください。<BR>◆世界各国の美酒を厳選!!極上ワインをご提供<BR>…スペインやイタリア産などの極上ワインを多数！<BR>値段もリーズナブルにご提供！当店自慢のシーフードやイタリアン料理との相性も抜群♪<BR><BR>◆海を連想させるかのような落ち着いた雰囲気の店内♪<BR>…インテリアや照明などにもこだわった自慢の空間は大人の時間を堪能できる上質な雰囲気！<BR>60名様～店内完全貸切も致します♪<BR><BR>◆誕生日や記念日には特製メッセージプレートをご用意♪<BR>…他にもお得なクーポンも多数♪<BR><BR>《池袋での飲み会や女子会、合コンにオススメ◎》"},"code":{"areacode":"AREA110","areaname":"関東","prefcode":"PREF13","prefname":"東京都","areacode_s":"AREAS2157","areaname_s":"池袋西口","category_code_l":["RSFST11000",{"@attributes":{"order":"1"}}],"category_name_l":["イタリアン・フレンチ",{"@attributes":{"order":"1"}}],"category_code_s":["RSFST11002",{"@attributes":{"order":"1"}}],"category_name_s":["イタリアン(イタリア料理)",{"@attributes":{"order":"1"}}]},"budget":"3000","party":"3500","lunch":"900","credit_card":{},"e_money":{},"flags":{"mobile_site":"1","mobile_coupon":"1","pc_coupon":"1"}},{"@attributes":{"order":"8"},"id":"genp400","update_date":"2017-02-27 17:21:51","name":"大衆イタリアン ハトノーユ ","name_kana":"タイシュウイタリアンハトノーユ","latitude":"35.726186","longitude":"139.708414","category":"大衆イタリアン","url":"http:\/\/r.gnavi.co.jp\/r33egbd20000\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","url_mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/genp400\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","coupon_url":{"pc":{},"mobile":{}},"image_url":{"shop_image1":"https:\/\/uds.gnst.jp\/rest\/img\/r33egbd20000\/t_0000.png","shop_image2":{},"qrcode":"https:\/\/c-r.gnst.jp\/tool\/qr\/?id=genp400&q=6"},"address":"〒171-0021 東京都豊島区西池袋3-18-5","tel":"050-3462-3036","tel_sub":"03-6914-1947  （3／25～開通）","fax":{},"opentime":" ディナー：17:00～24:00(L.O.23:00)","holiday":"無","access":{"line":"地下鉄副都心線","station":"池袋駅","station_exit":"C3番出口","walk":"4","note":{}},"parking_lots":{},"pr":{"pr_short":"■池袋駅C3番出口徒歩4分 ■住宅街の裏路地に佇む大衆酒場・大衆イタリアン「ハトノーユ」 ■化学調味料は一切使わない本格イタリアン ■2h飲み放題付コース4000円～","pr_long":"リストランテでもなく、ビストロでもない。<BR>気の利いたイタリアンが食べられる日本式大衆酒場。<BR>□飲み放題付コース 4000円／2時間飲み放題<BR>・クレソンとルッコラのサラダ<BR>・前菜の盛り合わせ<BR>・牛モツ煮(バケット付)<BR>・ハムカツ<BR>・クミンとミモレットのフライドポテト<BR>・おまかせパスタ<BR>・今月のカレーライス<BR>＊季節により内容が一部変更する場合があります<BR>□貸切<BR>・【半個室】８名～最大１３名様までOK!!<BR>・【店貸切】２０名様～OK!!<BR>ご予算・人数などお気軽にご相談ください"},"code":{"areacode":"AREA110","areaname":"関東","prefcode":"PREF13","prefname":"東京都","areacode_s":"AREAS2157","areaname_s":"池袋西口","category_code_l":["RSFST11000",{"@attributes":{"order":"1"}}],"category_name_l":["イタリアン・フレンチ",{"@attributes":{"order":"1"}}],"category_code_s":["RSFST11002",{"@attributes":{"order":"1"}}],"category_name_s":["イタリアン(イタリア料理)",{"@attributes":{"order":"1"}}]},"budget":"3500","party":"3500","lunch":{},"credit_card":"VISA,MasterCard,UC,DC,UFJ,ダイナースクラブ,アメリカン・エキスプレス,JCB,NICOS,アプラス,セゾン,J-DEBIT,MUFG","e_money":{},"flags":{"mobile_site":"1","mobile_coupon":"0","pc_coupon":"0"}},{"@attributes":{"order":"9"},"id":"gec6000","update_date":"2016-11-07 17:40:18","name":"イタリアンバル レガーロ ","name_kana":"イタリアンバルレガーロ","latitude":"35.691317","longitude":"139.707064","category":"新宿 イタリアン","url":"http:\/\/r.gnavi.co.jp\/apny8zpc0000\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","url_mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/gec6000\/?ak=O7jxNuUzjxGrIl%2Bdlp1%2FkE0Uur1GnHcLke%2Bx2%2FLV8ms%3D","coupon_url":{"pc":"http:\/\/r.gnavi.co.jp\/apny8zpc0000\/coupon\/","mobile":"http:\/\/mobile.gnavi.co.jp\/shop\/gec6000\/coupon"},"image_url":{"shop_image1":"https:\/\/uds.gnst.jp\/rest\/img\/apny8zpc0000\/t_000r.jpg","shop_image2":"https:\/\/uds.gnst.jp\/rest\/img\/apny8zpc0000\/t_000p.jpg","qrcode":"https:\/\/c-r.gnst.jp\/tool\/qr\/?id=gec6000&q=6"},"address":"〒160-0021 東京都新宿区歌舞伎町1-3-15","tel":"050-5785-1214","tel_sub":"03-5273-0774","fax":"03-5273-0774","opentime":"月～土 17:30～翌4:00","holiday":"毎週日曜日","access":{"line":"ＪＲ","station":"新宿駅","station_exit":"東口","walk":"5","note":{}},"parking_lots":{},"pr":{"pr_short":"新宿駅徒歩5分！ 【イタリアンレストラン レガーロ】 宴会コース3,000円～ご用意！ 女子会や誕生日など様々なシーンでご利用下さい！","pr_long":"◆新宿で本格イタリアンをリーズナブルに！<BR>新宿駅東口から徒歩5分。区役所通りにある隠れ家イタリアン。<BR>豊富なアラカルトメニューとワインをご用意。<BR>シェフが振舞う絶品イタリアンをご賞味あれ！<BR>◆様々なシーンに♪当店宴会コース！<BR>・9品3000円(2時間）コース<BR>・11品4500円（2時間半）コース<BR>※飲み放題はプラス1500円で付けられます！<BR>⇒☆お得なクーポン☆<BR>4名様以上のコース＆飲み放題をご予約でスパークリングワインボトルプレゼント！"},"code":{"areacode":"AREA110","areaname":"関東","prefcode":"PREF13","prefname":"東京都","areacode_s":"AREAS2115","areaname_s":"新宿東口・歌舞伎町","category_code_l":["RSFST11000",{"@attributes":{"order":"1"}}],"category_name_l":["イタリアン・フレンチ",{"@attributes":{"order":"1"}}],"category_code_s":["RSFST11002",{"@attributes":{"order":"1"}}],"category_name_s":["イタリアン(イタリア料理)",{"@attributes":{"order":"1"}}]},"budget":"4000","party":"4000","lunch":{},"credit_card":"VISA,MasterCard,UC,ダイナースクラブ,アメリカン・エキスプレス,JCB,アプラス,セゾン,MUFG,銀聯","e_money":{},"flags":{"mobile_site":"1","mobile_coupon":"1","pc_coupon":"1"}}]}