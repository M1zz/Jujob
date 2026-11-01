#!/usr/bin/env python3
"""App Store 그림 만들기: 언어별 마케팅 스크린샷 + 제품 페이지 헤더 · 검색 결과.

사용법
  python3 scripts/make_store_images.py [언어 ...]        (없으면 전부)

원본 캡처(시뮬레이터, 1320x2868)는 docs/screenshots/raw/<언어>/ 에 있어야 한다.
디버그 빌드를 실행 인자 `-JujobDemo main|mood|favorites|history|achievements` 로 띄우면
데모 데이터가 채워진 화면이 바로 열린다(MainContentView.applyScreenshotDemo).

결과
  docs/screenshots/marketing/<언어>/0N-….png   1242x2688 제출본
  docs/screenshots/creative/<언어>/header.png   3840x1646
  docs/screenshots/creative/<언어>/search.png   3840x2560

⚠️ 헤더 · 검색 결과의 글은 Apple 템플릿의 안전 영역 안에만 둔다(SPEC). 넘치면 그림을 만들지 않고 멈춘다.
⚠️ 문구는 언어마다 따로 썼다. 기계번역으로 채우지 않는다.
"""
import pathlib, subprocess, sys, tempfile, time

ROOT = pathlib.Path(__file__).resolve().parent.parent
RAW = ROOT / "docs" / "screenshots" / "raw"
MKT = ROOT / "docs" / "screenshots" / "marketing"
CRE = ROOT / "docs" / "screenshots" / "creative"
ICON = ROOT / "Jujob" / "Assets.xcassets" / "AppIcon.appiconset" / "1024.png"
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

SCREENS = ["01-main", "02-mood", "03-favorites", "04-history", "05-achievements"]
LAYOUTS = ["hero", "left", "bottom", "rotate", "dark"]

# 언어마다: 스크린샷 5장의 (헤드라인, 서브), 헤더 (눈썹글, 헤드라인), 검색 결과 (눈썹글, 헤드라인, 서브).
# 검색 결과는 스크린샷 1장과 같은 이야기다. 눈썹글은 그 나라 사람이 검색창에 칠 말.
COPY = {
    "ko": dict(
        shots=[("오늘도 과하게<br>칭찬받는 하루", "홈 화면 위젯이 하루 종일 주접을 떨어 줘요"),
               ("기분 따라<br>골라 받는 주접", "아침, 면접 전, 힘들 때까지 15가지 상황"),
               ("마음에 든 주접은<br>별 하나로", "즐겨찾기에 모아 두고 언제든 다시"),
               ("지나간 주접도<br>다시 보기", "본 주접은 히스토리에 저절로 남아요"),
               ("매일 오면<br>특별한 주접이", "7일, 30일, 100일 연속 기록과 업적")],
        header=("오늘의 주접", "칭찬은<br>과할수록 좋으니까"),
        search=("칭찬 위젯", "오늘도 과하게<br>칭찬받기", "홈 화면에서 하루 종일 응원해 줘요")),
    "en": dict(
        shots=[("Get hyped up<br>all day long", "A Home Screen widget that gushes over you"),
               ("Pick a mood,<br>get the right hype", "15 moments, from mornings to interviews"),
               ("Star the lines<br>you love", "Keep favorites close and reuse them anytime"),
               ("Never lose<br>a good one", "Every line you've seen is saved in History"),
               ("Show up daily,<br>unlock more", "7, 30 and 100-day streaks and achievements")],
        header=("Daily Hype", "You deserve<br>way too much praise"),
        search=("Compliment widget", "Get hyped up<br>all day long", "Over-the-top praise on your Home Screen")),
    "en-GB": dict(
        shots=[("Proper praise,<br>all day long", "A Home Screen widget that gushes over you"),
               ("Pick a mood,<br>get the right gush", "15 moments, from mornings to interviews"),
               ("Star the ones<br>you love", "Keep favourites close and use them again"),
               ("Never lose<br>a good one", "Every gush you've seen is kept in History"),
               ("Pop in daily,<br>unlock more", "7, 30 and 100-day streaks and achievements")],
        header=("Daily Gush", "You deserve<br>a bit too much praise"),
        search=("Compliment widget", "Proper praise,<br>all day long", "Over-the-top cheer on your Home Screen")),
    "zh-Hans": dict(
        shots=[("每天被夸<br>夸到飞起来", "主屏幕小组件，全天候彩虹屁"),
               ("看心情<br>挑一句彩虹屁", "早晨、面试前、难过时，15 种场景"),
               ("喜欢的句子<br>一键收藏", "存进收藏，随时再看"),
               ("看过的彩虹屁<br>都不会丢", "历史记录自动帮你保存"),
               ("天天打卡<br>解锁专属彩虹屁", "连续 7 天、30 天、100 天成就")],
        header=("今日彩虹屁", "你值得<br>被夸得再夸张一点"),
        search=("夸夸小组件", "每天被夸<br>夸到飞起来", "主屏幕上全天为你打气")),
    "zh-Hant": dict(
        shots=[("每天被誇<br>誇到飛上天", "主畫面小工具，整天幫你打氣"),
               ("看心情<br>挑一句彩虹屁", "早上、面試前、難過時，15 種情境"),
               ("喜歡的句子<br>一鍵收藏", "存進我的最愛，隨時再看"),
               ("看過的彩虹屁<br>都不會不見", "歷史紀錄自動幫你保存"),
               ("天天報到<br>解鎖專屬彩虹屁", "連續 7 天、30 天、100 天成就")],
        header=("今日彩虹屁", "你值得<br>被誇得更誇張一點"),
        search=("稱讚小工具", "每天被誇<br>誇到飛上天", "主畫面整天為你加油")),
    "ja": dict(
        shots=[("一日中<br>ほめちぎられる", "ホーム画面のウィジェットが全力で応援"),
               ("気分に合わせて<br>ほめ言葉を", "朝、面接前、つらい時まで15のシーン"),
               ("気に入った言葉は<br>星ひとつで保存", "お気に入りにためて、いつでも見返せる"),
               ("見た言葉も<br>あとから見返せる", "履歴に自動で残ります"),
               ("毎日開くと<br>特別なほめ言葉が", "7日・30日・100日の連続記録と実績")],
        header=("今日のほめちぎり", "ほめ言葉は<br>大げさなくらいがいい"),
        search=("ほめ言葉ウィジェット", "一日中<br>ほめちぎられる", "ホーム画面でいつでも応援")),
    "ru": dict(
        shots=[("Тебя хвалят<br>весь день", "Виджет на экране «Домой» не жалеет похвал"),
               ("Оды<br>под настроение", "15 ситуаций: утро, собеседование, грусть"),
               ("Любимые оды —<br>в одно касание", "Сохраняй в избранное и возвращайся"),
               ("Ни одна ода<br>не потеряется", "Всё прочитанное хранится в истории"),
               ("Заходи каждый день,<br>открывай новое", "Серии 7, 30 и 100 дней и достижения")],
        header=("Ода дня", "Хвалить —<br>так с размахом"),
        search=("Виджет комплиментов", "Тебя хвалят<br>весь день", "Поддержка прямо на экране «Домой»")),
    "es": dict(
        shots=[("Piropos para ti<br>todo el día", "Un widget en tu pantalla de inicio que te sube el ánimo"),
               ("Elige tu ánimo,<br>recibe tu piropo", "15 momentos: mañanas, entrevistas, días duros"),
               ("Guarda tus<br>favoritos", "Márcalos con una estrella y vuelve cuando quieras"),
               ("No pierdas<br>ni uno", "Todo lo que has visto queda en el historial"),
               ("Vuelve cada día<br>y desbloquea más", "Rachas de 7, 30 y 100 días y logros")],
        header=("Piropo del Día", "Mereces que te halaguen<br>a lo grande"),
        search=("Widget de piropos", "Piropos para ti<br>todo el día", "Ánimo exagerado en tu pantalla de inicio")),
    "de": dict(
        shots=[("Den ganzen Tag<br>gefeiert werden", "Ein Widget auf dem Home-Bildschirm, das dich anhimmelt"),
               ("Der Spruch<br>zur Stimmung", "15 Momente: morgens, vorm Bewerbungsgespräch, an miesen Tagen"),
               ("Lieblingssprüche<br>mit einem Stern", "In den Favoriten sammeln und jederzeit wieder nutzen"),
               ("Kein Spruch<br>geht verloren", "Alles, was du gesehen hast, steht im Verlauf"),
               ("Täglich dabei,<br>mehr freischalten", "Serien über 7, 30 und 100 Tage und Erfolge")],
        header=("Hype des Tages", "Lob darf ruhig<br>ein bisschen zu viel sein"),
        search=("Komplimente-Widget", "Den ganzen Tag<br>gefeiert werden", "Übertriebenes Lob auf deinem Home-Bildschirm")),
    "fr": dict(
        shots=[("Des compliments<br>toute la journée", "Un widget sur l'écran d'accueil qui t'encense"),
               ("Choisis ton humeur,<br>reçois ton compliment", "15 moments : matin, entretien, coup de mou"),
               ("Garde tes<br>préférés", "Une étoile et ils sont dans tes favoris"),
               ("Ne perds<br>aucune pépite", "Tout ce que tu as vu reste dans l'historique"),
               ("Reviens chaque jour,<br>débloque plus", "Séries de 7, 30 et 100 jours et succès")],
        header=("Trop Fan de Toi", "On n'est jamais<br>trop complimenté"),
        search=("Widget compliments", "Des compliments<br>toute la journée", "Des encouragements XXL sur ton écran d'accueil")),
    "it": dict(
        shots=[("Complimenti<br>tutto il giorno", "Un widget nella schermata Home che ti esalta"),
               ("Scegli l'umore,<br>arriva il complimento", "15 momenti: mattina, colloquio, giornate no"),
               ("Salva i tuoi<br>preferiti", "Una stella e li ritrovi quando vuoi"),
               ("Non perderne<br>neanche uno", "Tutto ciò che hai letto resta in cronologia"),
               ("Torna ogni giorno,<br>sblocca di più", "Serie di 7, 30 e 100 giorni e traguardi")],
        header=("Overdose di Complimenti", "Un complimento in più<br>non guasta mai"),
        search=("Widget complimenti", "Complimenti<br>tutto il giorno", "Incoraggiamento esagerato nella schermata Home")),
    "pt-BR": dict(
        shots=[("Elogios pra você<br>o dia todo", "Um widget na Tela de Início que baba por você"),
               ("Escolha o humor,<br>ganhe o elogio", "15 momentos: manhã, entrevista, dia difícil"),
               ("Salve seus<br>favoritos", "Uma estrela e é só voltar quando quiser"),
               ("Não perca<br>nenhum", "Tudo o que você viu fica no Histórico"),
               ("Volte todo dia<br>e desbloqueie mais", "Sequências de 7, 30 e 100 dias e conquistas")],
        header=("Elogio Exagerado", "Elogio bom<br>é elogio exagerado"),
        search=("Widget de elogios", "Elogios pra você<br>o dia todo", "Incentivo exagerado direto na Tela de Início")),
    "th": dict(
        shots=[("ได้รับคำชม<br>ทั้งวัน", "วิดเจ็ตบนหน้าจอโฮมที่ชมคุณแบบสุดๆ"),
               ("เลือกตามอารมณ์<br>รับคำชมที่ใช่", "15 สถานการณ์ ตั้งแต่ตอนเช้าถึงก่อนสัมภาษณ์"),
               ("คำชมที่ชอบ<br>กดดาวเก็บไว้", "เก็บไว้ในรายการโปรด ดูซ้ำได้ทุกเมื่อ"),
               ("คำชมที่เคยเห็น<br>ไม่หายไปไหน", "บันทึกไว้ในประวัติให้อัตโนมัติ"),
               ("เข้ามาทุกวัน<br>ปลดล็อกคำชมพิเศษ", "สถิติต่อเนื่อง 7, 30, 100 วัน และความสำเร็จ")],
        header=("ชมเว่อร์ทุกวัน", "คำชมน่ะ<br>ยิ่งเว่อร์ยิ่งดี"),
        search=("วิดเจ็ตคำชม", "ได้รับคำชม<br>ทั้งวัน", "กำลังใจเต็มที่บนหน้าจอโฮม")),
    "vi": dict(
        shots=[("Được khen lố<br>cả ngày", "Tiện ích trên Màn hình chính khen bạn hết cỡ"),
               ("Chọn tâm trạng,<br>nhận lời khen", "15 tình huống: buổi sáng, trước phỏng vấn, lúc buồn"),
               ("Câu nào thích<br>thì gắn sao", "Lưu vào Yêu thích, xem lại bất cứ lúc nào"),
               ("Không bỏ lỡ<br>câu nào", "Mọi câu đã xem đều lưu trong Lịch sử"),
               ("Ghé mỗi ngày,<br>mở khóa thêm", "Chuỗi 7, 30, 100 ngày và thành tích")],
        header=("Khen Lố Mỗi Ngày", "Bạn xứng đáng<br>được khen thật lố"),
        search=("Tiện ích lời khen", "Được khen lố<br>cả ngày", "Cổ vũ hết mình ngay trên Màn hình chính")),
    "cs": dict(
        shots=[("Pochvaly<br>celý den", "Widget na ploše, který tě nešetří chválou"),
               ("Vyber náladu,<br>dostaneš hlášku", "15 chvil: ráno, před pohovorem, v horších dnech"),
               ("Oblíbené hlášky<br>pod hvězdičkou", "Ulož si je do oblíbených a vracej se k nim"),
               ("Žádná hláška<br>se neztratí", "Vše přečtené najdeš v historii"),
               ("Choď každý den<br>a odemykej další", "Série 7, 30 a 100 dní a úspěchy")],
        header=("Pochvala dne", "Chvály<br>není nikdy dost"),
        search=("Widget s pochvalami", "Pochvaly<br>celý den", "Přehnaná podpora přímo na ploše")),
    "da": dict(
        shots=[("Roser til dig<br>hele dagen", "En widget på hjemmeskærmen, der hylder dig"),
               ("Vælg dit humør,<br>få din ros", "15 øjeblikke: morgen, jobsamtale, tunge dage"),
               ("Gem dine<br>favoritter", "Én stjerne, og du finder dem igen"),
               ("Gå ikke glip<br>af nogen", "Alt, du har set, gemmes i historikken"),
               ("Kig forbi hver dag<br>og lås op for mere", "Striber på 7, 30 og 100 dage og præstationer")],
        header=("Dagens Ros", "Man kan aldrig få<br>for mange roser"),
        search=("Kompliment-widget", "Roser til dig<br>hele dagen", "Overdreven opbakning på din hjemmeskærm")),
    "el": dict(
        shots=[("Παινέματα<br>όλη τη μέρα", "Ένα widget στην αρχική οθόνη που σε αποθεώνει"),
               ("Διάλεξε διάθεση,<br>πάρε παίνεμα", "15 στιγμές: πρωί, πριν από συνέντευξη, δύσκολες μέρες"),
               ("Κράτα τα<br>αγαπημένα σου", "Ένα αστεράκι και τα βρίσκεις όποτε θες"),
               ("Κανένα παίνεμα<br>δεν χάνεται", "Ό,τι έχεις δει μένει στο ιστορικό"),
               ("Έλα κάθε μέρα,<br>ξεκλείδωσε κι άλλα", "Σερί 7, 30 και 100 ημερών και επιτεύγματα")],
        header=("Το Παίνεμα της Ημέρας", "Τα καλά λόγια<br>ποτέ δεν φτάνουν"),
        search=("Widget με κομπλιμέντα", "Παινέματα<br>όλη τη μέρα", "Υπερβολική εμψύχωση στην αρχική οθόνη")),
    "fi": dict(
        shots=[("Kehuja<br>koko päivän", "Koti-valikon widget, joka hehkuttaa sinua"),
               ("Valitse fiilis,<br>saat kehun", "15 hetkeä: aamu, työhaastattelu, raskas päivä"),
               ("Tallenna<br>suosikit", "Tähti, ja kehu löytyy aina uudestaan"),
               ("Yksikään kehu<br>ei katoa", "Kaikki näkemäsi tallentuu historiaan"),
               ("Käy joka päivä,<br>avaa lisää", "7, 30 ja 100 päivän putket ja saavutukset")],
        header=("Päivän hehkutus", "Kehuja ei voi<br>saada liikaa"),
        search=("Kehuwidget", "Kehuja<br>koko päivän", "Överiä tsemppiä Koti-valikossa")),
    "id": dict(
        shots=[("Dipuji lebay<br>seharian", "Widget di Layar Utama yang memujimu habis-habisan"),
               ("Pilih mood,<br>dapat pujian", "15 momen: pagi, sebelum wawancara, saat sedih"),
               ("Simpan yang<br>kamu suka", "Tandai bintang, buka lagi kapan saja"),
               ("Tak ada pujian<br>yang hilang", "Semua yang sudah kamu lihat tersimpan di Riwayat"),
               ("Mampir tiap hari,<br>buka lebih banyak", "Rekor 7, 30, dan 100 hari beruntun serta pencapaian")],
        header=("Pujian Lebay Harian", "Kamu pantas dipuji<br>selebay mungkin"),
        search=("Widget pujian", "Dipuji lebay<br>seharian", "Semangat berlebihan langsung di Layar Utama")),
    "nb": dict(
        shots=[("Skryt<br>hele dagen", "En widget på Hjem-skjermen som hyller deg"),
               ("Velg humør,<br>få skryt", "15 øyeblikk: morgen, jobbintervju, tunge dager"),
               ("Ta vare på<br>favorittene", "Én stjerne, så finner du dem igjen"),
               ("Ikke gå glipp<br>av noe", "Alt du har sett, lagres i historikken"),
               ("Kom innom hver dag<br>og lås opp mer", "Dagsrekker på 7, 30 og 100 dager og prestasjoner")],
        header=("Dagens skryt", "Man kan aldri få<br>for mye skryt"),
        search=("Kompliment-widget", "Skryt<br>hele dagen", "Overdreven heiing på Hjem-skjermen")),
    "nl": dict(
        shots=[("De hele dag<br>complimenten", "Een widget op je beginscherm die je ophemelt"),
               ("Kies je stemming,<br>krijg je hype", "15 momenten: ochtend, sollicitatie, baaldag"),
               ("Bewaar je<br>favorieten", "Eén sterretje en je vindt ze altijd terug"),
               ("Mis er<br>geen één", "Alles wat je hebt gezien staat in je geschiedenis"),
               ("Kom elke dag terug,<br>ontgrendel meer", "Reeksen van 7, 30 en 100 dagen en prestaties")],
        header=("Dagelijkse Hypeman", "Complimenten mogen<br>best overdreven zijn"),
        search=("Complimenten-widget", "De hele dag<br>complimenten", "Overdreven aanmoediging op je beginscherm")),
    "pl": dict(
        shots=[("Peany na twoją cześć<br>przez cały dzień", "Widżet na ekranie początkowym, który cię wychwala"),
               ("Wybierz nastrój,<br>dostań pean", "15 chwil: poranek, rozmowa o pracę, gorszy dzień"),
               ("Zapisz<br>ulubione", "Jedna gwiazdka i zawsze do nich wrócisz"),
               ("Żaden pean<br>nie przepadnie", "Wszystko, co widzisz, trafia do historii"),
               ("Wpadaj codziennie,<br>odblokuj więcej", "Serie 7, 30 i 100 dni oraz osiągnięcia")],
        header=("Dzienna Dawka Peanów", "Komplementów<br>nigdy za wiele"),
        search=("Widżet z komplementami", "Peany na twoją cześć<br>przez cały dzień", "Przesadne wsparcie na ekranie początkowym")),
    "sv": dict(
        shots=[("Pepp<br>hela dagen", "En widget på hemskärmen som hyllar dig"),
               ("Välj humör,<br>få pepp", "15 lägen: morgon, jobbintervju, tunga dagar"),
               ("Spara dina<br>favoriter", "En stjärna så hittar du dem igen"),
               ("Missa inte<br>en enda", "Allt du har sett sparas i historiken"),
               ("Kika in varje dag<br>och lås upp mer", "Streaks på 7, 30 och 100 dagar och utmärkelser")],
        header=("Dagens Pepp", "Man kan aldrig få<br>för mycket beröm"),
        search=("Komplimang-widget", "Pepp<br>hela dagen", "Överdriven pepp på hemskärmen")),
    "tr": dict(
        shots=[("Gün boyu<br>pohpohlan", "Ana ekranında seni göklere çıkaran bir widget"),
               ("Ruh halini seç,<br>pohpohunu al", "15 an: sabah, mülakat öncesi, zor günler"),
               ("Sevdiklerini<br>kaydet", "Bir yıldız, istediğin zaman yeniden aç"),
               ("Hiçbir pohpoh<br>kaybolmaz", "Gördüğün her şey Geçmiş'te durur"),
               ("Her gün uğra,<br>daha fazlasını aç", "7, 30 ve 100 günlük seriler ve başarımlar")],
        header=("Günün Pohpohu", "Övgünün fazlası<br>zarar vermez"),
        search=("İltifat widget'ı", "Gün boyu<br>pohpohlan", "Ana ekranında abartılı moral")),
}

# 앱 아이콘(빨강 · 노랑)과 앱 안의 어두운 판을 따른다. 헤더 · 검색 결과도 같은 색을 쓴다.
CREAM, INK, SUB, RED, DARK = "#FFF3D1", "#1d1d1f", "#8c7646", "#F2385A", "#232323"

BASE_CSS = """
* { margin:0; padding:0; box-sizing:border-box; }
html,body { width:%(W)dpx; height:%(H)dpx; overflow:hidden; }
body { background:%(bg)s; position:relative;
  font-family:-apple-system, "SF Pro Display", "Apple SD Gothic Neo", sans-serif; }
:lang(ja) body { font-family:-apple-system, "Hiragino Sans", sans-serif; }
:lang(zh-Hans) body { font-family:-apple-system, "PingFang SC", sans-serif; }
:lang(zh-Hant) body { font-family:-apple-system, "PingFang TC", sans-serif; }
:lang(th) body { font-family:-apple-system, "Thonburi", sans-serif; }
.blob { position:absolute; border-radius:50%%; filter:blur(140px); pointer-events:none; }
.text { position:absolute; display:flex; flex-direction:column; }
.eyebrow { font-weight:800; color:#F2385A; line-height:1.15; }
.headline { font-weight:800; color:%(ink)s; letter-spacing:-0.02em; line-height:1.15; text-wrap:balance; }
.sub { font-weight:500; color:%(sub)s; line-height:1.35; text-wrap:balance; }
:lang(th) .headline, :lang(ja) .headline, :lang(zh) .headline { letter-spacing:0; }
:lang(th) .headline { line-height:1.35; }
:lang(ko) .headline, :lang(ko) .sub, :lang(ko) .eyebrow { word-break:keep-all; }
.phone { position:absolute; background:#141416; border:3px solid #3a3a3e; border-radius:%(pr)dpx; padding:%(pp)dpx;
  box-shadow: 40px 70px 120px rgba(80,40,0,.28), 10px 20px 40px rgba(0,0,0,.18); }
.phone img { width:100%%; display:block; border-radius:%(ir)dpx; }
.icon { position:absolute; border-radius:50%%; }
"""

# 헤드라인이 상자를 넘거나 적어 둔 줄(<br>)보다 더 쪼개지면 줄인다. 끝까지 안 맞으면 표시한다.
FIT_JS = """
<script>
function lines(el) {
  return Math.round(el.getBoundingClientRect().height / parseFloat(getComputedStyle(el).lineHeight));
}
function bad(box, el, want) {
  return box.scrollHeight > box.clientHeight + 1 || box.scrollWidth > box.clientWidth + 1 || lines(el) > want;
}
function fit(box, el) {
  const want = el.querySelectorAll('br').length + 1;
  let size = +el.dataset.max;
  el.style.fontSize = size + 'px';
  while (size > +el.dataset.min && bad(box, el, want)) { size -= 4; el.style.fontSize = size + 'px'; }
  if (bad(box, el, want)) document.body.dataset.overflow = '1';
  const sub = box.querySelector('.sub');
  if (sub) {  // 서브카피도 상자 안에 들어올 때까지
    let s = parseFloat(getComputedStyle(sub).fontSize);
    while (s > 30 && (box.scrollHeight > box.clientHeight + 1 || lines(sub) > 2)) { s -= 2; sub.style.fontSize = s + 'px'; }
    if (box.scrollHeight > box.clientHeight + 1 || lines(sub) > 2) document.body.dataset.overflow = '1';
  }
}
document.fonts.ready.then(() => {
  document.querySelectorAll('.text').forEach(box => fit(box, box.querySelector('.headline')));
  document.body.dataset.done = '1';
});
</script>
"""


def phone(img, left, top, width, rotate=0, extra=""):
    return (f'<div class="phone" style="left:{left}px;top:{top}px;width:{width}px;'
            f'transform:{extra}rotate({rotate}deg)"><img src="{img}"></div>')


def text_box(left, top, width, height, headline, sub, hmax, hmin, subsize, align="center", eyebrow=None, esize=0):
    eb = f'<div class="eyebrow" style="font-size:{esize}px;margin-bottom:24px">{eyebrow}</div>' if eyebrow else ""
    sb = f'<div class="sub" style="font-size:{subsize}px;margin-top:40px">{sub}</div>' if sub else ""
    return (f'<div class="text" style="left:{left}px;top:{top}px;width:{width}px;height:{height}px;'
            f'text-align:{align};align-items:{"center" if align == "center" else "flex-start"};justify-content:center">'
            f'{eb}<div class="headline" data-max="{hmax}" data-min="{hmin}">{headline}</div>{sb}</div>')


def shot_body(lang, i):
    headline, sub = COPY[lang]["shots"][i]
    img = (RAW / lang / f"{SCREENS[i]}.png").as_uri()
    layout = LAYOUTS[i]
    blobs = ('<div class="blob" style="left:-300px;top:-200px;width:1100px;height:900px;background:rgba(255,200,40,.55)"></div>'
             '<div class="blob" style="left:700px;top:1700px;width:1000px;height:1000px;background:rgba(242,56,90,.22)"></div>')
    if layout == "hero":
        return blobs + text_box(70, 170, 1102, 640, headline, sub, 120, 64, 50) + phone(img, 161, 900, 920)
    if layout == "left":
        return (blobs + text_box(100, 170, 1040, 640, headline, sub, 116, 64, 48, align="left")
                + f'<div style="position:absolute;left:330px;top:900px;perspective:2600px">'
                + phone(img, 0, 0, 840, 0, "rotateY(-14deg) rotateX(2deg) ") + '</div>')
    if layout == "bottom":
        return (blobs + phone(img, 196, 110, 850, 0)
                + text_box(70, 2000, 1102, 620, headline, sub, 116, 64, 48))
    if layout == "rotate":
        return blobs + text_box(70, 170, 1102, 640, headline, sub, 116, 64, 48) + phone(img, 120, 960, 960, -6)
    # dark: 마지막 장
    return ('<div class="blob" style="left:200px;top:1100px;width:900px;height:900px;background:rgba(242,56,90,.30)"></div>'
            '<div class="blob" style="left:-200px;top:-200px;width:900px;height:700px;background:rgba(255,200,40,.18)"></div>'
            + text_box(70, 170, 1102, 640, headline, sub, 116, 64, 48) + phone(img, 186, 900, 870))


# (가로, 세로, 안전 영역 left, top, right, bottom) — Apple PSD 템플릿에서 잰 값. 바꾸지 않는다.
SPEC = {
    "header": (3840, 1646, (1097, 493, 2743, 1154)),
    "search": (3840, 2560, (836, 765, 3004, 1795)),
}


def header_body(lang):
    W, H, (l, t, r, b) = SPEC["header"]
    eyebrow, headline = COPY[lang]["header"]
    left_img = (RAW / lang / "02-mood.png").as_uri()
    right_img = (RAW / lang / "01-main.png").as_uri()
    icon = ICON.as_uri()
    return (f'<div class="blob" style="left:{l}px;top:{t - 300}px;width:{r - l}px;height:{b - t + 600}px;background:rgba(255,200,40,.45)"></div>'
            f'<img class="icon" src="{icon}" style="left:80px;top:1180px;width:260px;transform:rotate(-12deg)">'
            f'<img class="icon" src="{icon}" style="left:3520px;top:90px;width:240px;transform:rotate(14deg)">'
            + phone(left_img, 380, 300, 600, -8) + phone(right_img, 2860, 300, 600, 8)
            + text_box(l, t, r - l, b - t, headline, None, 190, 100, 0, eyebrow=eyebrow, esize=76))


def search_body(lang):
    W, H, (l, t, r, b) = SPEC["search"]
    eyebrow, headline, sub = COPY[lang]["search"]
    col = int((r - l) * 0.58)
    img = (RAW / lang / "01-main.png").as_uri()
    ph_left = l + col + 120
    return (f'<div class="blob" style="left:{ph_left - 300}px;top:400px;width:1600px;height:1600px;background:rgba(255,200,40,.5)"></div>'
            f'<div class="blob" style="left:{l - 600}px;top:{b - 200}px;width:1400px;height:900px;background:rgba(242,56,90,.18)"></div>'
            + phone(img, ph_left, t - 420, 1000, 0)
            + text_box(l, t, col, b - t, headline, sub, 240, 130, 80, align="left", eyebrow=eyebrow, esize=96))


def render(page_body, W, H, out_png, label, dark=False, phone_scale=1.0):
    css = BASE_CSS % {"W": W, "H": H, "bg": DARK if dark else CREAM, "ink": "#f5f5f7" if dark else INK,
                      "sub": "#a1a1a6" if dark else SUB, "pr": int(112 * phone_scale), "pp": int(22 * phone_scale),
                      "ir": int(92 * phone_scale)}
    lang = label.split()[0]
    page = (f'<!doctype html><html lang="{lang}"><head><meta charset="utf-8"><style>{css}</style></head>'
            f'<body>{page_body}{FIT_JS}</body></html>')
    html_path = pathlib.Path(tempfile.gettempdir()) / f"jujob-{label.replace(' ', '-')}.html"
    html_path.write_text(page, encoding="utf-8")
    common = ["--headless=new", f"--window-size={W},{H}", "--force-device-scale-factor=1", "--hide-scrollbars",
              "--disable-gpu", "--virtual-time-budget=4000", "--allow-file-access-from-files"]
    dom = subprocess.run(["nice", "-n", "19", CHROME, "--dump-dom", *common, html_path.as_uri()],
                         capture_output=True, text=True, timeout=120).stdout
    if 'data-done="1"' not in dom:
        raise SystemExit(f"글 맞추기가 끝나지 않았다: {label}")
    if 'data-overflow="1"' in dom:
        raise SystemExit(f"글이 상자를 넘는다: {label} — 문구를 줄일 것")
    out_png.parent.mkdir(parents=True, exist_ok=True)
    for _ in range(3):  # Chrome 은 가끔 그리지 않고 끝난다
        try:
            r = subprocess.run(["nice", "-n", "19", CHROME, f"--screenshot={out_png}", *common, html_path.as_uri()],
                               capture_output=True, timeout=120)
            if r.returncode == 0 and out_png.exists():
                break
        except subprocess.TimeoutExpired:
            pass
    else:
        raise SystemExit(f"Chrome 이 그리지 못했다: {out_png}")
    time.sleep(2)  # 공용 Mac — 렌더 사이에 쉰다
    print("rendered", out_png.relative_to(ROOT))


def main(langs):
    for lang in langs:
        if lang not in COPY:
            raise SystemExit(f"모르는 언어: {lang}")
        for i, name in enumerate(SCREENS):
            render(shot_body(lang, i), 1242, 2688, MKT / lang / f"{name}.png", f"{lang} {name}",
                   dark=LAYOUTS[i] == "dark")
        W, H, _ = SPEC["header"]
        render(header_body(lang), W, H, CRE / lang / "header.png", f"{lang} header", phone_scale=0.75)
        W, H, _ = SPEC["search"]
        render(search_body(lang), W, H, CRE / lang / "search.png", f"{lang} search", phone_scale=1.2)


if __name__ == "__main__":
    main(sys.argv[1:] or list(COPY))
