import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Baslik alani
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: Colors.blue,
            alignment: Alignment.centerLeft,
            child: Text(
              'Anket Uygulamasi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Ana sayfa
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Ana Sayfa'),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),

          // Anketler
          ListTile(
            leading: Icon(Icons.poll),
            title: Text('Anketler'),
            onTap: () => Navigator.pushReplacementNamed(context, '/survey'),
          ),

          // Istatistikler
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Istatistikler'),
            onTap: () => Navigator.pushReplacementNamed(context, '/statistics'),
          ),
          
          Divider(),
          
          // Cikis
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Cikis'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }
}
