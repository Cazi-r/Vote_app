import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'survey_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller'lar
  final tcController = TextEditingController();
  final sifreController = TextEditingController();
  // Durum degiskenleri
  bool yukleniyor = false;
  // Logo URL
  final logoUrl = 'https://cdn-icons-png.flaticon.com/512/1902/1902201.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Giris Sayfasi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.network(
                logoUrl,
                height: 70,
                width: 70,
              ),
              SizedBox(height: 16),
              // Baslik
              Text(
                'Anket Uygulamasi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              // TC Kimlik No alani
              TextField(
                controller: tcController,
                decoration: InputDecoration(
                    labelText: "TC Kimlik No",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                keyboardType: TextInputType.number,
                maxLength: 11,
              ),
              SizedBox(height: 12),
              // Sifre alani
              TextField(
                controller: sifreController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Sifre",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 24),
              // Giris butonu
              ElevatedButton(
                onPressed: yukleniyor ? null : girisYap,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    minimumSize: Size(double.infinity, 50)),
                child: Text('Giris Yap', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TC kimlik kontrolu
  bool tcKimlikGecerliMi(String? tc) {
    if (tc == null || tc.isEmpty) return false;
    if (tc.length != 11) return false;
    if (tc[0] == '0') return false;
    return true;
  }

  // Giris islemi
  void girisYap() async {
    // TC kimlik kontrolu
    if (!tcKimlikGecerliMi(tcController.text)) {
      mesajGoster("Hata", "Gecerli bir TC kimlik numarasi giriniz.");
      return;
    }
    // Sifre kontrolu
    if (sifreController.text.isEmpty) {
      mesajGoster("Hata", "Sifre alani bos birakilamaz.");
      return;
    }
    // Yukleniyor durumunu guncelle
    setState(() {
      yukleniyor = true;
    });

    try {
      // Kullanici ID'sini kaydet
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', tcController.text);

      // Anketleri sifirla
      await SurveyPage.resetSurveys();

      // Ana sayfaya git
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      mesajGoster("Hata", "Giris sirasinda bir hata olustu: $e");
    } finally {
      // Yukleniyor durumunu guncelle
      setState(() {
        yukleniyor = false;
      });
    }
  }

  // Hata mesaji goster
  void mesajGoster(String baslik, String mesaj) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(baslik),
          content: Text(mesaj),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Tamam"),
            ),
          ],
        );
      },
    );
  }
}
