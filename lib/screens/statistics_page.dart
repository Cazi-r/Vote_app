import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatefulWidget {
  @override
  State<StatisticsPage> createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  // Anket verileri listesi - Survey sayfasındaki anketlerle aynı format ve içeriğe sahip
  // Ancak burada sadece gösterim amaçlı olduğu için 'oyVerildi' ve 'secilenSecenek' alanları yok
  List<Map<String, dynamic>> anketler = [
    {
      'soru': 'Aşağıdaki meyvelerden hangisini daha çok seversiniz?',
      'secenekler': ['Elma', 'Muz', 'Çilek'],
      'oylar': [0, 0, 0],
      'ikon': Icons.food_bank,
      'renk': Colors.green,
    },
    {
      'soru': 'En sevdiğiniz mevsim hangisidir?',
      'secenekler': ['İlkbahar', 'Yaz', 'Sonbahar', 'Kış'],
      'oylar': [0, 0, 0, 0],
      'ikon': Icons.wb_sunny,
      'renk': Colors.orange,
    },
    {
      'soru': 'Aşağıdaki sporlardan hangisini daha çok seversiniz?',
      'secenekler': ['Futbol', 'Basketbol'],
      'oylar': [0, 0],
      'ikon': Icons.sports_soccer,
      'renk': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    verileriYukle();
  }

  // SharedPreferences'dan kaydedilmiş oy verilerini yükler
  // Bu metot sayfa açıldığında çağrılır ve tüm anketlerin güncel oy durumlarını gösterir
  void verileriYukle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < anketler.length; i++) {
      // Oy verilerini içeren string listesini ('votes_0', 'votes_1', 'votes_2' anahtarlarıyla) yükle
      List<String>? oyListesi = prefs.getStringList('votes_$i');

      // Veri varsa ve boş değilse işleme devam et
      if (oyListesi != null && oyListesi.isNotEmpty) {
        try {
          // String listesini int listesine dönüştür (SharedPreferences int listesi saklamadığı için)
          List<int> oylar = [];
          for (String oy in oyListesi) {
            oylar.add(int.parse(oy));
          }

          // Anket verisini güncel oy sayılarıyla güncelle
          setState(() {
            anketler[i]['oylar'] = oylar;
          });
        } catch (e) {
          print("Oy verilerini yüklerken hata: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('İstatistikler'),
      ),
      drawer: CustomDrawer(),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: anketler.length,
        itemBuilder: (context, index) {
          return istatistikKartiOlustur(index);
        },
      ),
    );
  }

  // İstatistik kartını oluşturan widget metodu
  // Her anket için soru, toplam oy sayısı ve seçeneklerin durumunu gösteren kart oluşturur
  Widget istatistikKartiOlustur(int anketIndex) {
    Map<String, dynamic> anket = anketler[anketIndex];

    // Tüm seçeneklerin aldığı toplam oy sayısını hesapla
    // Bu değer hem gösterim için kullanılır hem de yüzde hesaplarında payda olarak kullanılır
    int toplamOy = 0;
    List<int> oylar = anket['oylar'];
    for (int oy in oylar) {
      toplamOy += oy;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Anket sorusu ve ikonu - kart başlığı
            // Anketin içeriğini temsil eden ikon ve soru metni
            Row(
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

            SizedBox(height: 12),

            // Ankete verilen toplam oy sayısı bilgisi
            // Hiç oy verilmediyse 0 gösterilir
            Text(
              'Toplam: $toplamOy oy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            // Tüm seçeneklerin sonuçlarını içeren widget listesi
            // Her seçenek için oy sayısı, yüzdesi ve ilerlemesi gösterilir
            Column(
              children: secenek_sonuclarini_olustur(anket, toplamOy),
            ),
          ],
        ),
      ),
    );
  }

  // Her seçenek için ayrı sonuç satırı widget'ları oluşturan metot
  // Seçenek adı, oy sayısı, yüzdesi ve grafiksel gösterimini içerir
  List<Widget> secenek_sonuclarini_olustur(
      Map<String, dynamic> anket, int toplamOy) {
    List<Widget> sonuclar = [];

    for (int i = 0; i < anket['secenekler'].length; i++) {
      String secenek = anket['secenekler'][i];
      int oySayisi = anket['oylar'][i];

      // Seçeneğin aldığı oyun toplam oylara oranını yüzde olarak hesapla
      // Toplam oy yoksa yüzde sıfır olacaktır
      double yuzde = 0;
      if (toplamOy > 0) {
        yuzde = (oySayisi / toplamOy) * 100;
      }

      // Her seçenek için oy bilgisi ve ilerleme çubuğu içeren widget
      Widget sonucWidget = Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seçenek adı, oy sayısı ve yüzde bilgisi
            // Örnek: "Elma: 5 (50%)"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(secenek),
                Text('$oySayisi (${yuzde.toStringAsFixed(0)}%)'),
              ],
            ),

            SizedBox(height: 4),

            // Oyun yüzdesini görsel olarak temsil eden ilerleme çubuğu
            // Her seçenek için anketin renginde bir çubuk gösterilir
            LinearProgressIndicator(
              value: yuzde / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(anket['renk']),
              minHeight: 10,
            ),
          ],
        ),
      );

      sonuclar.add(sonucWidget);
    }

    return sonuclar;
  }
}
