import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveyPage extends StatefulWidget {
  // Kullanıcı oturumları arasında anket verilerini sıfırlamak için kullanılan statik metot
  // SharedPreferences'dan tüm anket seçimlerini temizler
  static Future<void> resetSurveys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('selectedOption_0');
    prefs.remove('selectedOption_1');
    prefs.remove('selectedOption_2');
  }

  @override
  State<SurveyPage> createState() => SurveyPageState();
}

class SurveyPageState extends State<SurveyPage> {
  // Anket verileri listesi - Her anket bir Map olarak tanımlanmıştır
  // Her Map içerisinde soru metni, seçenekler, oy sayıları, kullanıcı tercihi, görsel öğeler bulunur
  List<Map<String, dynamic>> anketler = [
    {
      'soru': 'Aşağıdaki meyvelerden hangisini daha çok seversiniz?',
      'secenekler': ['Elma', 'Muz', 'Çilek'],
      'oylar': [0, 0, 0],
      'oyVerildi': false,
      'secilenSecenek': null,
      'ikon': Icons.food_bank,
      'renk': Colors.green,
    },
    {
      'soru': 'En sevdiğiniz mevsim hangisidir?',
      'secenekler': ['İlkbahar', 'Yaz', 'Sonbahar', 'Kış'],
      'oylar': [0, 0, 0, 0],
      'oyVerildi': false,
      'secilenSecenek': null,
      'ikon': Icons.wb_sunny,
      'renk': Colors.orange,
    },
    {
      'soru': 'Aşağıdaki sporlardan hangisini daha çok seversiniz?',
      'secenekler': ['Futbol', 'Basketbol'],
      'oylar': [0, 0],
      'oyVerildi': false,
      'secilenSecenek': null,
      'ikon': Icons.sports_soccer,
      'renk': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    verileriYukle();
  }

  // SharedPreferences'dan kayıtlı anket verilerini (oylar ve kullanıcı tercihleri) yükler
  // İlk çalıştırmada veya veri yoksa varsayılan değerler kullanılır
  void verileriYukle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      for (int i = 0; i < anketler.length; i++) {
        // Önceden kaydedilmiş oy sayılarını yükle
        // 'votes_0', 'votes_1', 'votes_2' şeklinde saklanan string listelerini alır
        final oyListesi = prefs.getStringList('votes_$i');
        if (oyListesi != null) {
          List<int> oylar = [];
          for (String oy in oyListesi) {
            oylar.add(int.parse(oy));
          }
          anketler[i]['oylar'] = oylar;
        }

        // Kullanıcının daha önce seçtiği seçeneği yükle
        // 'selectedOption_0', 'selectedOption_1', 'selectedOption_2' şeklinde saklanır
        final secilenIndex = prefs.getInt('selectedOption_$i');
        if (secilenIndex != null) {
          anketler[i]['secilenSecenek'] = secilenIndex;
          anketler[i]['oyVerildi'] = true;
        }
      }
    });
  }

  // Kullanıcı bir seçeneği seçtiğinde çağrılan metot
  // Seçilen seçeneğin oy sayısını artırır ve kullanıcı tercihini kaydeder
  void oyVer(int anketIndex, int secenekIndex) async {
    setState(() {
      // Seçilen seçeneğin oy sayısını bir artır
      anketler[anketIndex]['oylar'][secenekIndex]++;
      // Bu anket için kullanıcının oy verdiğini işaretle ve seçimini kaydet
      anketler[anketIndex]['oyVerildi'] = true;
      anketler[anketIndex]['secilenSecenek'] = secenekIndex;
    });

    // Yeni oy durumunu kalıcı olarak kaydet
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Güncellenmiş oy sayılarını SharedPreferences'a kaydet
    // Int listesi direkt kaydedilemediği için string listesine dönüştürülür
    List<String> oyListesi = [];
    for (int oy in anketler[anketIndex]['oylar']) {
      oyListesi.add(oy.toString());
    }
    prefs.setStringList('votes_$anketIndex', oyListesi);

    // Kullanıcının seçtiği seçeneği SharedPreferences'a kaydet
    prefs.setInt('selectedOption_$anketIndex', secenekIndex);
  }

  // Tüm anketleri sıfırlama işlemi - AppBar'daki refresh butonuna basıldığında çağrılır
  // Kullanıcının seçimlerini temizler, ancak toplam oy sayılarını korur
  void anketleriSifirla() async {
    setState(() {
      for (var anket in anketler) {
        anket['oyVerildi'] = false;
        anket['secilenSecenek'] = null;
      }
    });

    // Kayıtlı kullanıcı tercihlerini SharedPreferences'dan sil
    await SurveyPage.resetSurveys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Anketler'),
        actions: [
          // Anketleri sıfırlama butonu - kullanıcının seçimlerini temizler
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: anketleriSifirla,
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: anketler.length,
        itemBuilder: (context, index) {
          return anketKartiOlustur(index);
        },
      ),
    );
  }

  // Anket kartını oluşturan widget metodu
  // Her anket için başlık, simge ve seçenekleri içeren kart oluşturur
  Widget anketKartiOlustur(int anketIndex) {
    Map<String, dynamic> anket = anketler[anketIndex];
    bool oyVerildi = anket['oyVerildi'] == true;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Soru başlığı ve anket ikonu
          // Başlık üst kısmında anketin konusuyla ilgili bir ikon ve soru metni bulunur
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(anket['ikon'], size: 28, color: anket['renk']),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    anket['soru'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Anket seçenekleri listesi
          // Anketin tüm seçeneklerini ayrı satırlar halinde alt alta listeler
          Column(
            children: List.generate(
              anket['secenekler'].length,
              (secenekIndex) =>
                  secenekSatiriOlustur(anketIndex, secenekIndex, oyVerildi),
            ),
          ),

          SizedBox(height: 8),
        ],
      ),
    );
  }

  // Her seçenek için ayrı bir satır oluşturan widget metodu
  // Seçenek adını, seçim durumunu ve oy verilmiş ise oy sayısını gösterir
  Widget secenekSatiriOlustur(
      int anketIndex, int secenekIndex, bool oyVerildi) {
    Map<String, dynamic> anket = anketler[anketIndex];
    String secenek = anket['secenekler'][secenekIndex];
    bool secili = anket['secilenSecenek'] == secenekIndex;

    return InkWell(
      // Kullanıcı daha önce oy verdiyse tıklama devre dışı bırakılır
      onTap: oyVerildi
          ? null
          : () {
              oyVer(anketIndex, secenekIndex);
            },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            // Seçenek durumunu gösteren ikon
            // Oy verilmediyse: boş daire
            // Oy verildi ve bu seçenek seçildiyse: dolu onay ikonu
            // Oy verildi ama bu seçenek seçilmediyse: boş daire
            Icon(
              oyVerildi
                  ? (secili ? Icons.check_circle : Icons.circle_outlined)
                  : Icons.radio_button_unchecked,
              color: oyVerildi && secili ? anket['renk'] : Colors.grey,
            ),

            SizedBox(width: 16),

            // Seçenek adı/metni
            // Seçilmemiş seçenekler soluk gösterilir
            Text(
              secenek,
              style: TextStyle(
                color: oyVerildi && !secili ? Colors.grey : Colors.black,
              ),
            ),

            // Oy sayısı göstergesi - sadece oy verilmişse gösterilir
            // Kullanıcı oy verdikten sonra her seçeneğin toplam oy sayısı görünür olur
            if (oyVerildi) ...[
              Spacer(),
              Text('${anket['oylar'][secenekIndex]} oy'),
            ],
          ],
        ),
      ),
    );
  }
}
