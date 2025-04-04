import 'package:flutter/material.dart';
import 'package:vote_app/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/theme/app_theme.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<Map<String, dynamic>> surveys = [
    {
      'question': 'Aşağıdaki meyvelerden hangisini daha çok seversiniz?',
      'options': ['Elma', 'Muz', 'Çilek'],
      'votes': [0, 0, 0],
      'voted': false,
      'icon': Icons.food_bank,
      'color': Colors.green,
      'selectedOption': null,
    },
    {
      'question': 'En sevdiğiniz mevsim hangisidir?',
      'options': ['İlkbahar', 'Yaz', 'Sonbahar', 'Kış'],
      'votes': [0, 0, 0, 0],
      'voted': false,
      'icon': Icons.palette,
      'color': Colors.orange,
      'selectedOption': null,
    },
    {
      'question': 'Aşağıdaki sporlardan hangisini daha çok seversiniz?',
      'options': ['Futbol', 'Basketbol'],
      'votes': [0, 0],
      'voted': false,
      'icon': Icons.sports_soccer,
      'color': Colors.blue,
      'selectedOption': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSurveyData();
  }

  Future<void> _loadSurveyData() async {
    final prefs = await SharedPreferences.getInstance();
    
    for (int i = 0; i < surveys.length; i++) {
      final votesList = prefs.getStringList('votes_$i');
      final selectedOption = prefs.getInt('selectedOption_$i');
      
      if (votesList != null && votesList.isNotEmpty) {
        setState(() {
          surveys[i]['votes'] = votesList.map((e) => int.parse(e)).toList();
          if (selectedOption != null) {
            surveys[i]['selectedOption'] = selectedOption;
            surveys[i]['voted'] = true;
          }
        });
      }
    }
  }

  void vote(int surveyIndex, int optionIndex) async {
    setState(() {
      surveys[surveyIndex]['votes'][optionIndex]++;
      surveys[surveyIndex]['voted'] = true;
      surveys[surveyIndex]['selectedOption'] = optionIndex;
    });
    
    final prefs = await SharedPreferences.getInstance();
    List<String> votesList = surveys[surveyIndex]['votes'].map((e) => e.toString()).toList().cast<String>();
    await prefs.setStringList('votes_$surveyIndex', votesList);
    await prefs.setInt('selectedOption_$surveyIndex', optionIndex);
  }

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
        title: Text('Anketler'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshSurveys,
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
        decoration: AppTheme.gradientBackground(context),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: surveys.length,
          itemBuilder: (context, index) => _buildSurveyCard(index),
        ),
      ),
    );
  }
  
  Widget _buildSurveyCard(int surveyIndex) {
    final survey = surveys[surveyIndex];
    final hasVoted = survey['voted'] == true;
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          
          Container(
            height: 80,
            color: survey['color'].withOpacity(0.2),
            child: Center(
              child: Icon(survey['icon'], size: 50, color: survey['color']),
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              survey['question'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          
          ...List.generate(
            survey['options'].length,
            (optionIndex) => _buildOptionTile(surveyIndex, optionIndex, hasVoted),
          ),
          
          SizedBox(height: 8),
        ],
      ),
    );
  }
  
  Widget _buildOptionTile(int surveyIndex, int optionIndex, bool hasVoted) {
    final survey = surveys[surveyIndex];
    final option = survey['options'][optionIndex];
    final isSelected = survey['selectedOption'] == optionIndex;
    
    return ListTile(
      title: Text(
        option,
        style: TextStyle(
          color: hasVoted ? Colors.grey : Colors.black87,
        ),
      ),
      leading: hasVoted
          ? Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? survey['color'] : Colors.grey,
            )
          : null,
      trailing: hasVoted
          ? Text('${survey['votes'][optionIndex]} oy')
          : Icon(Icons.arrow_forward_ios, size: 14),
      onTap: hasVoted ? null : () => vote(surveyIndex, optionIndex),
    );
  }
}