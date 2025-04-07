import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 * İstatistikler Sayfası Widget
 
 - Kullanıcıların anket sonuçlarını görebileceği, grafiksel olarak sonuçların görselleştirildiği sayfayı oluşturur.
 - StatefulWidget olarak tasarlanmıştır çünkü anket verileri dinamik olarak yüklenir.
*/

class StatisticsPage extends StatefulWidget {
  @override
  State<StatisticsPage> createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  
  List<Map<String, dynamic>> surveys = [ // Anket verileri listesi. Survey sayfasındaki anketlerle 'oyVerildi' ve 'secilenSecenek' alanları hariç aynı format ve içeriğe sahip.
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
    loadData();
  }
  
  void loadData() async { // SharedPreferences'dan kaydedilmiş oy verilerini yükler. Sayfa açıldığında çağrılır ve anketlerin güncel oy durumlarını gösterir.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < surveys.length; i++) {
      List<String>? oyListesi = prefs.getStringList('votes_$i'); // Oy verilerini içeren string listesini yükler.
      
      if (oyListesi != null && oyListesi.isNotEmpty) { // Veri varsa ve boş değilse işleme devam et.
        try {
          List<int> oylar = []; // String listesini int listesine dönüştür. (SharedPreferences int listesi saklamadığı için)
          for (String oy in oyListesi) {
            oylar.add(int.parse(oy));
          }
          setState(() { // Anket verisini güncel oy sayılarıyla günceller.
            surveys[i]['oylar'] = oylar;
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
        backgroundColor: Color(0xFF5181BE),
        title: Text('İstatistikler'),
      ),
      drawer: CustomDrawer(),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: surveys.length,
        itemBuilder: (context, index) {
          return createStatisticsCard(index);
        },
      ),
    );
  }

  /*
   - İstatistik Kartı Oluşturucu: Her anket için soru, toplam oy sayısı ve seçeneklerin durumunu gösteren kart oluşturur.
   
   - surveyIndex Hangi anketin kartını oluşturacağımızı tutar.
   - return Anket istatistik kartı widget'ı tutar.
  */
  Widget createStatisticsCard(int surveyIndex) {
    Map<String, dynamic> survey = surveys[surveyIndex];

    int totalVotes = 0;
    List<int> votes = survey['oylar'];
    for (int vote in votes) {
      totalVotes += vote; // Tüm seçeneklerin aldığı toplam oy sayısını hesaplar. Bu değer hem gösterim için hem de yüzde hesaplarında kullanılır.
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(survey['ikon'], size: 28, color: survey['renk']),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    survey['soru'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text( // Ankete verilen toplam oy sayısı bilgisi. Hiç oy verilmediyse 0 gösterilir.
              'Toplam: $totalVotes oy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: createOptionResults(survey, totalVotes), // Seçeneklerin sonuçlarını içeren widget listesi.
            ),
          ],
        ),
      ),
    );
  }

  /*
   - Seçenek Sonuçlarını Oluşturucu: Seçenek adı, oy sayısı, yüzdesi ve grafiksel gösterimini içerir
   
   - survey Anket verisini tutar.
   - totalVotes Anketin toplam oy sayısını tutar.
   - return Seçenek sonuç widget'larının listesini tutar.
  */
  List<Widget> createOptionResults(
      Map<String, dynamic> survey, int totalVotes) {
    List<Widget> results = [];

    for (int i = 0; i < survey['secenekler'].length; i++) {
      String option = survey['secenekler'][i];
      int voteCount = survey['oylar'][i];
      double percentage = 0;
      
      if (totalVotes > 0) {
        percentage = (voteCount / totalVotes) * 100; // Seçeneğin aldığı oyun toplam oylara oranını yüzde olarak hesapla. Toplam oy yoksa yüzde sıfır olacaktır.
      }
      
      Widget resultWidget = Padding( // Her seçenek için oy bilgisi ve ilerleme çubuğu içeren widget.
        padding: EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(option),
                Text('$voteCount (${percentage.toStringAsFixed(0)}%)'),
              ],
            ),
            SizedBox(height: 4),
            LinearProgressIndicator( // Oyun yüzdesini görsel olarak temsil eden ilerleme çubuğu. Her seçenek için anketin renginde bir çubuk gösterilir.
              value: percentage / 100, // 0-1 arası değer.
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(survey['renk']), // Doluluk rengi.
              minHeight: 10, // Çubuk yüksekliği.
            ),
          ],
        ),
      );
      results.add(resultWidget);
    }
    return results;
  }
}
