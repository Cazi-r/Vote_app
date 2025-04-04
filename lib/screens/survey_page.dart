import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveyPage extends StatefulWidget {
  // Anketleri sifirlama metodu
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
  // Anket verileri
  List<Map<String, dynamic>> anketler = [
    {
      'soru': 'Asagidaki meyvelerden hangisini daha cok seversiniz?',
      'secenekler': ['Elma', 'Muz', 'Cilek'],
      'oylar': [0, 0, 0],
      'oyVerildi': false,
      'secilenSecenek': null,
      'ikon': Icons.food_bank,
      'renk': Colors.green,
    },
    {
      'soru': 'En sevdiginiz mevsim hangisidir?',
      'secenekler': ['Ilkbahar', 'Yaz', 'Sonbahar', 'Kis'],
      'oylar': [0, 0, 0, 0],
      'oyVerildi': false,
      'secilenSecenek': null,
      'ikon': Icons.wb_sunny,
      'renk': Colors.orange,
    },
    {
      'soru': 'Asagidaki sporlardan hangisini daha cok seversiniz?',
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

  // Kayitli verileri yukle
  void verileriYukle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      for (int i = 0; i < anketler.length; i++) {
        // Oy verilerini yukle
        final oyListesi = prefs.getStringList('votes_$i');
        if (oyListesi != null) {
          List<int> oylar = [];
          for (String oy in oyListesi) {
            oylar.add(int.parse(oy));
          }
          anketler[i]['oylar'] = oylar;
        }
        
        // Secili secenek bilgisini yukle
        final secilenIndex = prefs.getInt('selectedOption_$i');
        if (secilenIndex != null) {
          anketler[i]['secilenSecenek'] = secilenIndex;
          anketler[i]['oyVerildi'] = true;
        }
      }
    });
  }

  // Oy verme islemi
  void oyVer(int anketIndex, int secenekIndex) async {
    setState(() {
      // Oyu bir arttir
      anketler[anketIndex]['oylar'][secenekIndex]++;
      // Secildi olarak isaretle
      anketler[anketIndex]['oyVerildi'] = true;
      anketler[anketIndex]['secilenSecenek'] = secenekIndex;
    });
    
    // Veriyi kaydet
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Oy listesini kaydet
    List<String> oyListesi = [];
    for (int oy in anketler[anketIndex]['oylar']) {
      oyListesi.add(oy.toString());
    }
    prefs.setStringList('votes_$anketIndex', oyListesi);
    
    // Secilen secenegi kaydet
    prefs.setInt('selectedOption_$anketIndex', secenekIndex);
  }

  // Anketleri sifirla
  void anketleriSifirla() async {
    setState(() {
      for (var anket in anketler) {
        anket['oyVerildi'] = false;
        anket['secilenSecenek'] = null;
      }
    });
    
    // Veriyi temizle
    await SurveyPage.resetSurveys();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Anketler'),
        actions: [
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
  
  // Anket karti olusturma
  Widget anketKartiOlustur(int anketIndex) {
    Map<String, dynamic> anket = anketler[anketIndex];
    bool oyVerildi = anket['oyVerildi'] == true;
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Soru basligi
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(anket['ikon'], size: 28, color: anket['renk']),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    anket['soru'],
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Divider(height: 1),
          
          // Secenekler listesi
          Column(
            children: List.generate(
              anket['secenekler'].length,
              (secenekIndex) => secenekSatiriOlustur(anketIndex, secenekIndex, oyVerildi),
            ),
          ),
          
          SizedBox(height: 8),
        ],
      ),
    );
  }
  
  // Secenek satiri olusturma
  Widget secenekSatiriOlustur(int anketIndex, int secenekIndex, bool oyVerildi) {
    Map<String, dynamic> anket = anketler[anketIndex];
    String secenek = anket['secenekler'][secenekIndex];
    bool secili = anket['secilenSecenek'] == secenekIndex;
    
    return InkWell(
      onTap: oyVerildi ? null : () {
        oyVer(anketIndex, secenekIndex);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            // Secenek ikonu
            Icon(
              oyVerildi
                ? (secili ? Icons.check_circle : Icons.circle_outlined)
                : Icons.radio_button_unchecked,
              color: oyVerildi && secili ? anket['renk'] : Colors.grey,
            ),

            SizedBox(width: 16),

            // Secenek metni
            Text(
              secenek,
              style: TextStyle(
                color: oyVerildi && !secili ? Colors.grey : Colors.black,
              ),
            ),
            
            // Oy sayisi
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