import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatefulWidget {
  @override
  State<StatisticsPage> createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  // Anket verileri
  List<Map<String, dynamic>> anketler = [
    {
      'soru': 'Asagidaki meyvelerden hangisini daha cok seversiniz?',
      'secenekler': ['Elma', 'Muz', 'Cilek'],
      'oylar': [0, 0, 0],
      'ikon': Icons.food_bank,
      'renk': Colors.green,
    },
    {
      'soru': 'En sevdiginiz mevsim hangisidir?',
      'secenekler': ['Ilkbahar', 'Yaz', 'Sonbahar', 'Kis'],
      'oylar': [0, 0, 0, 0],
      'ikon': Icons.wb_sunny,
      'renk': Colors.orange,
    },
    {
      'soru': 'Asagidaki sporlardan hangisini daha cok seversiniz?',
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

  // Kayitli oy verilerini yukle
  void verileriYukle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < anketler.length; i++) {
      // Oy listesini cekelim
      List<String>? oyListesi = prefs.getStringList('votes_$i');

      // Eger veri varsa yukleme yapalim
      if (oyListesi != null && oyListesi.isNotEmpty) {
        try {
          // String'den int'e donusturme
          List<int> oylar = [];
          for (String oy in oyListesi) {
            oylar.add(int.parse(oy));
          }

          // State'i guncelleyelim
          setState(() {
            anketler[i]['oylar'] = oylar;
          });
        } catch (e) {
          print("Oy verilerini yuklerken hata: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Istatistikler'),
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

  // Istatistik karti olusturma
  Widget istatistikKartiOlustur(int anketIndex) {
    Map<String, dynamic> anket = anketler[anketIndex];

    // Toplam oy sayisini hesapla
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
            // Soru basligi
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

            // Toplam oy bilgisi
            Text(
              'Toplam: $toplamOy oy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            Column(
              children: secenek_sonuclarini_olustur(anket, toplamOy),
            ),
          ],
        ),
      ),
    );
  }

  // Secenek sonuclarini olusturma
  List<Widget> secenek_sonuclarini_olustur(
      Map<String, dynamic> anket, int toplamOy) {
    List<Widget> sonuclar = [];

    for (int i = 0; i < anket['secenekler'].length; i++) {
      String secenek = anket['secenekler'][i];
      int oySayisi = anket['oylar'][i];

      // Yuzdelik hesaplama
      double yuzde = 0;
      if (toplamOy > 0) {
        yuzde = (oySayisi / toplamOy) * 100;
      }

      // Secenek sonuc widgeti
      Widget sonucWidget = Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Secenek ve oy sayisi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(secenek),
                Text('$oySayisi (${yuzde.toStringAsFixed(0)}%)'),
              ],
            ),

            SizedBox(height: 4),

            // Oy cubugu
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
