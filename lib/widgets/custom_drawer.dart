import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String logoUrl = 'https://cdn-icons-png.flaticon.com/512/1902/1902201.png'; // uygulama logosu için URL tanımı

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader( // drawer başlık bölümü
            decoration: BoxDecoration(
              color: Color(0xFF5181BE),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network( // uygulama logosu
                  logoUrl,
                  height: 70,
                  width: 70,
                ),
                SizedBox(height: 10),
                Text(
                  'Anket Uygulaması',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          ListTile( // ana sayfa menü öğesi: kullanıcıyı ana sayfaya yönlendirir
            leading: Icon(Icons.home, color: Color(0xFF5181BE)),
            title: Text('Ana Sayfa'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          
          ListTile( // anketler menü öğesi: kullanıcıyı anket sayfasına yönlendirir ve oy kullanmayı sağlar
            leading: Icon(Icons.poll, color: Color(0xFF5181BE)),
            title: Text('Anketler'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/survey');
            },
          ),
          
          ListTile( // istatistikler menü öğesi: kullanıcıyı anket sonuçları ve istatistikleri sayfasına yönlendirir
            leading: Icon(Icons.bar_chart, color: Color(0xFF5181BE)),
            title: Text('İstatistikler'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/statistics');
            },
          ),
          
          Divider(),  // ayırıcı çizgi - alt menü öğelerini ayırır
          
          ListTile( // çıkış menü öğesi: kullanıcıyı oturumdan çıkarır ve giriş sayfasına yönlendirir
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Çıkış'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
