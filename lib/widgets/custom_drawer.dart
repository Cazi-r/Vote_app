import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  // Logo URL
  final String logoUrl = 'https://cdn-icons-png.flaticon.com/512/1902/1902201.png';
  
  // Renk paleti
  static const colors = {
    'primary': Color(0xFF4A6FE5),
    'accent': Color(0xFF8C61FF),
    'background': Color(0xFFF6F8FC),
    'cardBg': Color(0xFFEEF2FD),
    'textColor': Color(0xFF2E3A59),
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colors['background'],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Baslik alani
          Container(
            height: 160,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colors['primary'],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.network(
                  logoUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 8),
                // Baslik
                Text(
                  'Anket Uygulaması',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Ana sayfa
          ListTile(
            leading: Icon(Icons.home, color: colors['accent']),
            title: Text('Ana Sayfa', style: TextStyle(color: colors['textColor'])),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),

          // Anketler
          ListTile(
            leading: Icon(Icons.poll, color: colors['accent']),
            title: Text('Anketler', style: TextStyle(color: colors['textColor'])),
            onTap: () => Navigator.pushReplacementNamed(context, '/survey'),
          ),

          // Istatistikler
          ListTile(
            leading: Icon(Icons.bar_chart, color: colors['accent']),
            title: Text('İstatistikler', style: TextStyle(color: colors['textColor'])),
            onTap: () => Navigator.pushReplacementNamed(context, '/statistics'),
          ),
          
          Divider(color: colors['textColor']!.withOpacity(0.2)),
          
          // Cikis
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Çıkış', style: TextStyle(color: colors['textColor'])),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }
}
