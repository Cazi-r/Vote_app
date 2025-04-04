import 'package:flutter/material.dart';
import 'package:vote_app/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveyPage extends StatefulWidget {
  // Basit statik metod - anketleri sifirlama
  static Future<void> resetSurveys() async {
    final prefs = await SharedPreferences.getInstance();
    // Anket secimlerini temizle
    for (int i = 0; i < 3; i++) {
      prefs.remove('selectedOption_$i');
    }
  }

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  // Sabit anket verileri
  List<Map<String, dynamic>> surveys = [
    {
      'question': 'Asagidaki meyvelerden hangisini daha cok seversiniz?',
      'options': ['Elma', 'Muz', 'Cilek'],
      'votes': [0, 0, 0],
      'voted': false,
      'selectedOption': null,
      'icon': Icons.food_bank,
      'color': Colors.green,
    },
    {
      'question': 'En sevdiginiz mevsim hangisidir?',
      'options': ['Ilkbahar', 'Yaz', 'Sonbahar', 'Kis'],
      'votes': [0, 0, 0, 0],
      'voted': false,
      'selectedOption': null,
      'icon': Icons.wb_sunny,
      'color': Colors.orange,
    },
    {
      'question': 'Asagidaki sporlardan hangisini daha cok seversiniz?',
      'options': ['Futbol', 'Basketbol'],
      'votes': [0, 0],
      'voted': false,
      'selectedOption': null,
      'icon': Icons.sports_soccer,
      'color': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSurveyData();
  }

  // Anket verilerini yukle
  Future<void> _loadSurveyData() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      for (int i = 0; i < surveys.length; i++) {
        final votesList = prefs.getStringList('votes_$i');
        final selectedOption = prefs.getInt('selectedOption_$i');
        
        if (votesList != null && votesList.isNotEmpty) {
          surveys[i]['votes'] = votesList.map((e) => int.parse(e)).toList();
        }
        
        if (selectedOption != null) {
          surveys[i]['selectedOption'] = selectedOption;
          surveys[i]['voted'] = true;
        }
      }
    });
  }

  // Oy verme fonksiyonu
  void vote(int surveyIndex, int optionIndex) async {
    setState(() {
      surveys[surveyIndex]['votes'][optionIndex]++;
      surveys[surveyIndex]['voted'] = true;
      surveys[surveyIndex]['selectedOption'] = optionIndex;
    });
    
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'votes_$surveyIndex', 
      surveys[surveyIndex]['votes'].map<String>((e) => e.toString()).toList()
    );
    prefs.setInt('selectedOption_$surveyIndex', optionIndex);
  }

  // Anketleri sifirla
  void refreshSurveys() {
    setState(() {
      for (var survey in surveys) {
        survey['voted'] = false;
        survey['selectedOption'] = null;
      }
    });
    
    SharedPreferences.getInstance().then((prefs) {
      for (int i = 0; i < surveys.length; i++) {
        prefs.remove('selectedOption_$i');
      }
    });
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
            onPressed: refreshSurveys,
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: surveys.length,
        itemBuilder: (context, index) => _buildSurveyCard(index),
      ),
    );
  }
  
  // Anket karti olustur
  Widget _buildSurveyCard(int surveyIndex) {
    final survey = surveys[surveyIndex];
    final hasVoted = survey['voted'] == true;
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Anket sorusu ve ikon
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(survey['icon'], size: 28, color: survey['color']),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    survey['question'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          Divider(height: 1),
          
          // Secenekler listesi
          ...List.generate(
            survey['options'].length,
            (optionIndex) => _buildOptionItem(surveyIndex, optionIndex, hasVoted),
          ),
          
          SizedBox(height: 8),
        ],
      ),
    );
  }
  
  // Secenek ogesi olustur
  Widget _buildOptionItem(int surveyIndex, int optionIndex, bool hasVoted) {
    final survey = surveys[surveyIndex];
    final option = survey['options'][optionIndex];
    final isSelected = survey['selectedOption'] == optionIndex;
    
    return InkWell(
      onTap: hasVoted ? null : () => vote(surveyIndex, optionIndex),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            // Secim ikonu
            Icon(
              hasVoted
                ? (isSelected ? Icons.check_circle : Icons.circle_outlined)
                : Icons.radio_button_unchecked,
              color: hasVoted && isSelected ? survey['color'] : Colors.grey,
            ),

            SizedBox(width: 16),

            // Secenek metni
            Text(
              option,
              style: TextStyle(
                color: hasVoted && !isSelected ? Colors.grey : Colors.black,
              ),
            ),
            
            // Oy sayisi
            if (hasVoted) ...[
              Spacer(),
              Text('${survey['votes'][optionIndex]} oy'),
            ],
          ],
        ),
      ),
    );
  }
}