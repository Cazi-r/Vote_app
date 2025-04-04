import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  // Logo URL
  final String logoUrl = 'https://cdn-icons-png.flaticon.com/512/1902/1902201.png';
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  logoUrl,
                  height: 70,
                  width: 70,
                ),
                SizedBox(height: 10),
                Text(
                  'Anket Uygulamasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.home, color: Colors.blue),
            title: Text('Ana Sayfa'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),

          ListTile(
            leading: Icon(Icons.poll, color: Colors.blue),
            title: Text('Anketler'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/survey');
            },
          ),

          ListTile(
            leading: Icon(Icons.bar_chart, color: Colors.blue),
            title: Text('Istatistikler'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/statistics');
            },
          ),
          
          Divider(),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Cikis'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}