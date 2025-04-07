import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'survey_page.dart';

/*
 * Giriş Sayfası Widget
 
 - Kullanıcıların uygulamaya giriş yapabilmesi için tasarlanmış sayfa.
 - StatefulWidget olarak oluşturulmuştur:
 - 1. Kullanıcı giriş bilgilerini takip etmesi gerekir.
 - 2. Giriş işlemi sırasında state değişiklikleri olur.
*/

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final tcController = TextEditingController(); // TC Kimlik No girişi bilgisini tutan controller.
  final sifreController = TextEditingController(); // Şifre girişi bilgisini tutan controller.
  final logoUrl = 'https://cdn-icons-png.flaticon.com/512/1902/1902201.png'; // Uygulama logosu için URL tanımı.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5181BE),
        title: Text("Giriş Sayfası"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                logoUrl,
                height: 140,
                width: 140,
              ),
              SizedBox(height: 16),
              Text(
                'Anket Uygulaması',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              TextField( // TC Kimlik No giriş alanı. Kullanıcı tanımlaması için TC kimlik numarası istenir.
                controller: tcController,
                decoration: InputDecoration(
                    labelText: "TC Kimlik No",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                ),
                keyboardType: TextInputType.number, // Sayısal klavye.
                maxLength: 11, // 11 karakter sınırlaması ve sadece sayı girişi sağlanır.
              ),
              SizedBox(height: 12),
              TextField( // Şifre giriş alanı. Kullanıcının şifresini gizli şekilde girmesini sağlar.
                controller: sifreController,
                obscureText: true, // Güvenlik için metin gizlenir.
                decoration: InputDecoration(
                  labelText: "Şifre",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton( // Giriş butonu. Kullanıcı bilgilerini kontrol eder ve giriş işlemini başlatır.
                onPressed: login,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5181BE),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    minimumSize: Size(double.infinity, 50)),
                child: Text('Giriş Yap', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isIdValid(String? tc) { // TC kimlik numarası geçerlilik kontrolünü yapar.
   
    if (tc == null || tc.isEmpty) return false; // Boş değer kontrolü
    if (tc.length != 11) return false; // 11 hane kontrolü
    if (tc[0] == '0') return false; // İlk rakam 0 olmamalı
    return true;
  }
  
  void login() async { // Kullanıcı giriş işlemini gerçekleştiren metot. TC kimlik ve şifre kontrolü yaparak giriş işlemini yönetir.
    
    if (!isIdValid(tcController.text)) { // TC kimlik numarası geçerlilik kontrolü.
      showMessage("Hata", "Geçerli bir TC kimlik numarası giriniz."); // Geçersiz ise hata mesajı gösterilir.
      return;
    }
    
    if (sifreController.text.isEmpty) { // Şifre boş olmamalı kontrolü.
      showMessage("Hata", "Şifre alanı boş bırakılamaz."); // Boş ise hata mesajı gösterilir.
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance(); // Kullanıcı TC'sini cihaz hafızasına kaydeder. SharedPreferences kullanarak oturum bilgisini saklar.
      prefs.setString('user_id', tcController.text);
      Navigator.pushReplacementNamed(context, '/home'); // Ana sayfaya yönlendir. Giriş başarılıdır.
    } catch (e) {
      showMessage("Hata", "Giriş sırasında bir hata oluştu: $e"); // Hata durumunda kullanıcıya bilgi verir.
    }
  }
  
  void showMessage(String title, String message) { // Hata ve bilgi mesajlarını gösteren yardımcı metot.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog( // AlertDialog kullanarak kullanıcıya bildirim gösterir.
          title: Text(title),
          content: Text(message),
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
