import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 * Anket Sayfası Widget

 - Kullanıcıların anketlere katılabileceği, sonuçları görebileceği sayfayı oluşturur.
 - StatefulWidget olarak tasarlanmıştır çünkü anket verileri ve kullanıcı tercihleri dinamiktir.
*/

class SurveyPage extends StatefulWidget {
  @override
  State<SurveyPage> createState() => SurveyPageState();
}

class SurveyPageState extends State<SurveyPage> {
  String? userId; // SharedPreferences'tan alınan ve anket oylarını kişiselleştirmek için kullanılan kişisel ID.
  
  List<Map<String, dynamic>> surveys = [ // Anket verileri listesi. Her bir anket: soru, seçenekler, oylar, kullanıcının seçimi, ikon ve renk içerir.
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
    _loadUserId().then((_) { // Uygulama başladığında kullanıcı ID'sini yükler.
      loadData(); // Ardından verileri getirir.
    });
  }

  /*
   - Kullanıcı ID'sini SharedPreferences'tan yükler.
   - Bu ID, kullanıcının hangi anketlere oy verdiğini takip etmek için kullanılır.
   - Async bir işlemdir çünkü SharedPreferences'tan veri okuma işlemi zaman alabilir.
  */
  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id');
    });
  }

  /*
   - SharedPreferences'tan tüm kullanıcıların oylarını (votes_X) ve mevcut kullanıcının seçimlerini (selectedOption_USERID_X) yükler.
   - Eğer veri yoksa varsayılan değerler kullanılır.
  */
  void loadData() async {
    if (userId == null) return; // Kullanıcı giriş yapmamışsa yükleme yapma.

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      for (int i = 0; i < surveys.length; i++) {
        final oyListesi = prefs.getStringList('votes_$i'); // Önceden kaydedilmiş oy sayılarını yükler.
        if (oyListesi != null) {
          List<int> oylar = [];
          for (String oy in oyListesi) {
            oylar.add(int.parse(oy));
          }
          surveys[i]['oylar'] = oylar;
        }

        final secilenIndex = prefs.getInt('selectedOption_${userId}_$i'); // Kullanıcının daha önce seçtiği seçeneği yükler.
        if (secilenIndex != null) {
          surveys[i]['secilenSecenek'] = secilenIndex;
          surveys[i]['oyVerildi'] = true;
        }
      }
    });
  }

  /*
   - Kullanıcının oy verme işlemini gerçekleştiren fonksiyon.
  
   - surveyIndex hangi anketin oylandığı tutar.
   - optionIndex hangi seçeneğin seçildiği tutar.
   
   - Kullanıcının daha önce oy verip vermediğini kontrol eder.
   - Seçilen seçeneğin oy sayısını artırır.
   - Kullanıcının seçimini kaydeder.
   - Tüm değişiklikleri SharedPreferences'a kaydeder.
  */
  void vote(int surveyIndex, int optionIndex) async {
    if (userId == null) return; // Kullanıcı giriş yapmamışsa işlem yapma.

    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    final mevcutSecim = prefs.getInt('selectedOption_${userId}_$surveyIndex'); // Kullanıcının daha önce bu ankete oy verip vermediğini kontrol et.
    
    if (mevcutSecim != null) { // Kullanıcı zaten oy vermiş, sessizce işlemi durdur.
      return;
    }

    setState(() {
      surveys[surveyIndex]['oylar'][optionIndex]++; // Seçilen seçeneğin oy sayısını bir artır.
      surveys[surveyIndex]['oyVerildi'] = true; // Bu anket için kullanıcının oy verdiğini işaretle.
      surveys[surveyIndex]['secilenSecenek'] = optionIndex; // Seçilen oyu sakla.
    });

    List<String> oyListesi = []; // Güncellenmiş oy sayılarını SharedPreferences'a kaydet. Int listesi direkt kaydedilemediği için string listesine dönüştürülür.
    for (int oy in surveys[surveyIndex]['oylar']) {
      oyListesi.add(oy.toString());
    }
    prefs.setStringList('votes_$surveyIndex', oyListesi);
    prefs.setInt('selectedOption_${userId}_$surveyIndex', optionIndex);  // Seçilen oyu kullanıcı ID'sine göre kaydet. Bu, her kullanıcının sadece bir kez oy vermesini sağlar.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5181BE),
        title: Text('Anketler'),
      ),
      drawer: CustomDrawer(),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: surveys.length,
        itemBuilder: (context, index) {
          return createSurveyCard(index);
        },
      ),
    );
  }
  
  /*
   - Anket Kartı Oluşturucu: Her anket için başlık, simge ve seçenekleri içeren card oluşturur ve döndürür.
   
   - surveyIndex hangi anketin kartını oluşturacağımızı tutar.
   - return anket kartı widget'ı tutar.
  */
  Widget createSurveyCard(int surveyIndex) {
    Map<String, dynamic> survey = surveys[surveyIndex];
    bool hasVoted = survey['oyVerildi'] == true;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(survey['ikon'], size: 28, color: survey['renk']), // Anketin konusuyla ilgili bir ikon ve soru metni bulunur.
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    survey['soru'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          Column(
            children: List.generate( // Anket seçenekleri listesi.
              survey['secenekler'].length,
              (optionIndex) => createOptionRow(surveyIndex, optionIndex, hasVoted),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  /*
   - Seçenek Satırı Oluşturucu: Seçenek adını, seçim durumunu ve oy verilmiş ise oy sayısını tutan bir list döndürür.
   
   - surveyIndex Hangi anketin seçeneği olduğunu tutar.
   - optionIndex Hangi seçenek olduğunu tutar.
   - hasVoted Kullanıcının oy verip vermediğini tutar.
   - return Seçenek satırı widget'ı tutar. 
  */
  Widget createOptionRow(
      int surveyIndex, int optionIndex, bool hasVoted) {
    Map<String, dynamic> survey = surveys[surveyIndex];
    String option = survey['secenekler'][optionIndex];
    bool isSelected = survey['secilenSecenek'] == optionIndex;

    return ListTile(
      onTap: hasVoted ? null : (){ // Kullanıcı daha önce oy verdiyse tıklama devre dışı bırakılır.
        vote(surveyIndex, optionIndex);
      },
      leading: Icon(
        hasVoted ? (isSelected ? Icons.check_circle : Icons.circle_outlined) : Icons.radio_button_unchecked,
        color: hasVoted && isSelected ? survey['renk'] : Colors.grey,
      ),
      title: Text(
        option,
        style: TextStyle(
          color: hasVoted && !isSelected ? Colors.grey : Colors.black,
        ),
      ),
      trailing: hasVoted ? Text('${survey['oylar'][optionIndex]} oy') : null,
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
