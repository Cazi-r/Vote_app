import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;

  @override
  void initState() {
    super.initState();
    kullaniciIdGetir();
  }

  void kullaniciIdGetir() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Ana Sayfa"),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kullanici kart bilgisi
            if (userId != null) kullaniciKartiOlustur(),
            
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),

            // Baslik bolumu
            baslikSatiri('Hizli Erisim', Icons.dashboard),
            
            // Anketlere git butonu
            menuButonu(
              ikon: Icons.poll,
              baslik: 'Anketler',
              aciklama: 'Anketlere eris ve oy kullan',
              tiklamaFonksiyonu: () {
                Navigator.pushNamed(context, '/survey');
              }
            ),
            
            SizedBox(height: 10),
            
            // Istatistiklere git butonu
            menuButonu(
              ikon: Icons.bar_chart,
              baslik: 'Istatistikler',
              aciklama: 'Anket sonuclarini incele',
              tiklamaFonksiyonu: () {
                Navigator.pushNamed(context, '/statistics');
              }
            ),
          ],
        ),
      ),
    );
  }

  // Kullanici karti
  Widget kullaniciKartiOlustur() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hosgeldiniz',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'TC: ${userId!.substring(0, 3)}*****${userId!.substring(8, 11)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Baslik satiri
  Widget baslikSatiri(String baslik, IconData ikon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(ikon, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            baslik,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Menu butonu
  Widget menuButonu({
    required IconData ikon,
    required String baslik,
    required String aciklama,
    required Function tiklamaFonksiyonu
  }) {
    return ElevatedButton(
      onPressed: () => tiklamaFonksiyonu(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Icon(ikon, color: Colors.blue, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  aciklama,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}