import 'package:flutter/material.dart';
import 'package:vote_app/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/theme/app_theme.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<Map<String, dynamic>> surveys = [
    {
      'question': 'Aşağıdaki meyvelerden hangisini daha çok seversiniz?',
      'options': ['Elma', 'Muz', 'Çilek'],
      'votes': [0, 0, 0],
      'icon': Icons.food_bank,
      'color': Colors.green,
    },
    {
      'question': 'En sevdiğiniz mevsim hangisidir?',
      'options': ['İlkbahar', 'Yaz', 'Sonbahar', 'Kış'],
      'votes': [0, 0, 0, 0],
      'icon': Icons.wb_sunny,
      'color': Colors.orange,
    },
    {
      'question': 'Aşağıdaki sporlardan hangisini daha çok seversiniz?',
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
          print("Oy yüklerken hata: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İstatistikler'),
      ),
      drawer: CustomDrawer(),
      body: Container(
        decoration: AppTheme.gradientBackground(context),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: surveys.length,
          itemBuilder: (context, surveyIndex) {
            final survey = surveys[surveyIndex];
            final int totalVotes = survey['votes'].fold(0, (sum, vote) => sum + vote);
            
            return Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          survey['icon'],
                          color: survey['color'],
                          size: 32,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            survey['question'],
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    Text(
                      'Toplam: $totalVotes oy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    if (totalVotes == 0)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Henüz oy verilmemiş',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      ...List.generate(survey['options'].length, (optionIndex) {
                        final int voteCount = survey['votes'][optionIndex];
                        final double percentage = totalVotes > 0 
                          ? voteCount / totalVotes * 100 
                          : 0;
                        
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(survey['options'][optionIndex]),
                                  Text('$voteCount oy (${percentage.toStringAsFixed(1)}%)'),
                                ],
                              ),
                              
                              SizedBox(height: 4),
                              
                              Container(
                                height: 20,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: percentage / 100,
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _getColor(optionIndex),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Color _getColor(int index) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
    ];
    
    return colors[index % colors.length];
  }
}