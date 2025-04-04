import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  static const colors = {
    'primary': Color(0xFF4A6FE5),
    'accent': Color(0xFF8C61FF),
    'background': Color(0xFFF6F8FC),
    'cardBg': Color(0xFFEEF2FD),
    'textColor': Color(0xFF2E3A59),
  };

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      .then((prefs) => setState(() => userId = prefs.getString('user_id')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(backgroundColor: colors['primary'], title: Text("Ana Sayfa")),
    drawer: CustomDrawer(),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (userId != null) _buildUserCard(),
          SizedBox(height: 24),
          _buildSectionTitle('Hızlı Erişim', Icons.dashboard),
          _buildNavButton(Icons.poll, 'Anketler', 'Anketlere eris ve oy kullan',
            () => Navigator.pushNamed(context, '/survey')),
          SizedBox(height: 12),
          _buildNavButton(Icons.bar_chart, 'İstatistikler', 'Anket sonuclarini incele',
            () => Navigator.pushNamed(context, '/statistics')),
        ],
      ),
    ),
  );

  Widget _buildUserCard() => Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: colors['cardBg'],
      borderRadius: BorderRadius.circular(8),
      boxShadow: [BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
        offset: Offset(0, 2),
      )],
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: colors['primary'],
          child: Icon(Icons.person, color: Colors.white),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hoşgeldiniz', 
              style: TextStyle(fontWeight: FontWeight.bold, color: colors['textColor'])),
            SizedBox(height: 4),
            Text('TC: ${userId!.substring(0, 3)}*****${userId!.substring(8, 11)}',
              style: TextStyle(color: colors['textColor']!.withOpacity(0.7))),
          ],
        ),
      ],
    ),
  );

  Widget _buildSectionTitle(String title, IconData icon) => Padding(
    padding: EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Icon(icon, color: colors['accent']),
        SizedBox(width: 8),
        Text(title, style: TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold,
          color: colors['textColor'],
        )),
      ],
    ),
  );

  Widget _buildNavButton(IconData icon, String title, String description, VoidCallback onTap) => ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(16),
      backgroundColor: Colors.white,
      foregroundColor: colors['textColor'],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Row(
      children: [
        Icon(icon, color: colors['accent'], size: 30),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(description, style: TextStyle(fontSize: 12, color: colors['textColor']!.withOpacity(0.6))),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 16, color: colors['primary']!.withOpacity(0.5)),
      ],
    ),
  );
}
