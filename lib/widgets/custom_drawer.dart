import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomDrawer extends StatelessWidget {
  final String logoUrl = 'https://cdn-icons-png.flaticon.com/512/1902/1902201.png';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  logoUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 12),
                Text(
                  'Anket Uygulaması',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.home, color: AppTheme.primaryColor),
            title: Text('Ana Sayfa'),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),

          ListTile(
            leading: Icon(Icons.poll, color: AppTheme.primaryColor),
            title: Text('Anketler'),
            onTap: () => Navigator.pushReplacementNamed(context, '/survey'),
          ),

          ListTile(
            leading: Icon(Icons.bar_chart, color: AppTheme.primaryColor),
            title: Text('İstatistikler'),
            onTap: () => Navigator.pushReplacementNamed(context, '/statistics'),
          ),
          
          Divider(),
          
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Çıkış'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }
}
