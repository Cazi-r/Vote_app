import 'package:flutter/material.dart';
import 'package:vote_app/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<Map<String, dynamic>> surveys = [
    {
      'question': 'Asagidaki meyvelerden hangisini daha cok seversiniz?',
      'options': ['Elma', 'Muz', 'Cilek'],
      'votes': [0, 0, 0],
      'icon': Icons.food_bank,
      'color': Colors.green,
    },
    {
      'question': 'En sevdiginiz mevsim hangisidir?',
      'options': ['Ilkbahar', 'Yaz', 'Sonbahar', 'Kis'],
      'votes': [0, 0, 0, 0],
      'icon': Icons.wb_sunny,
      'color': Colors.orange,
    },
    {
      'question': 'Asagidaki sporlardan hangisini daha cok seversiniz?',
      'options': ['Futbol', 'Basketbol'],
      'votes': [0, 0],
      'icon': Icons.sports_soccer,
      'color': Colors.blue,
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
      final votesStr = prefs.getStringList('votes_$i');
      
      if (votesStr != null && votesStr.isNotEmpty) {
        try {
          List<int> loadedVotes = votesStr.map((e) => int.parse(e)).toList();
          setState(() {
            surveys[i]['votes'] = loadedVotes;
          });
        } catch (e) {
          print("Oy yuklerken hata: $e");
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
        itemCount: surveys.length,
        itemBuilder: (context, index) => _buildStatisticsCard(index),
      ),
    );
  }

  Widget _buildStatisticsCard(int surveyIndex) {
    final survey = surveys[surveyIndex];
    final int totalVotes = survey['votes'].fold(0, (sum, vote) => sum + vote);
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Anket sorusu
            Row(
              children: [
                Icon(
                  survey['icon'],
                  size: 28,
                  color: survey['color']
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    survey['question'],
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Toplam oy
            Text(
              'Toplam: $totalVotes oy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Oy verilmemis durumu
            if (totalVotes == 0)
              Center(
                child: Text(
                  'Henuz oy verilmemis',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              )
            // Oy sonuclari
            else
              ...List.generate(survey['options'].length, (optionIndex) {
                final int voteCount = survey['votes'][optionIndex];
                final double percentage = totalVotes > 0 
                  ? voteCount / totalVotes * 100 
                  : 0;
                
                return Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Secenek ve oy sayisi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(survey['options'][optionIndex]),
                          Text('$voteCount (${percentage.toStringAsFixed(0)}%)'),
                        ],
                      ),
                      
                      SizedBox(height: 4),
                      
                      // Oy cubugu
                      LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(survey['color']),
                        minHeight: 10,
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}