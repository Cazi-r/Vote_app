import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Giriş yapan kullanıcının ID bilgisi (TC kimlik numarası)
  // SharedPreferences'dan yüklenir ve kullanıcı bilgisi kartında kullanılır
  String? userId;

  @override
  void initState() {
    super.initState();
    kullaniciIdGetir();
  }

  // Kullanıcı kimlik bilgisini SharedPreferences'dan yükleyen metot
  // Giriş yapıldığında LoginPage tarafından kaydedilen 'user_id' değerini alır
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
      // Yan menü çekmecesi - uygulama içi navigasyonu sağlar
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kullanıcı bilgi kartı - sadece kullanıcı giriş yapmışsa gösterilir
            // TC kimlik numarasının bir kısmını gizleyerek güvenli şekilde gösterir
            if (userId != null) kullaniciKartiOlustur(),

            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),

            // Ana menü başlık bölümü - hızlı erişim seçeneklerini tanıtır
            baslikSatiri('Hızlı Erişim', Icons.dashboard),

            // Anket sayfasına giden navigasyon butonu
            // Kullanıcının mevcut anketlere erişmesini ve oy kullanmasını sağlar
            menuButonu(
                ikon: Icons.poll,
                baslik: 'Anketler',
                aciklama: 'Anketlere eriş ve oy kullan',
                tiklamaFonksiyonu: () {
                  Navigator.pushNamed(context, '/survey');
                }),

            SizedBox(height: 10),

            // İstatistik sayfasına giden navigasyon butonu
            // Kullanıcının anket sonuçlarını ve istatistikleri görüntülemesini sağlar
            menuButonu(
                ikon: Icons.bar_chart,
                baslik: 'İstatistikler',
                aciklama: 'Anket sonuçlarını incele',
                tiklamaFonksiyonu: () {
                  Navigator.pushNamed(context, '/statistics');
                }),
          ],
        ),
      ),
    );
  }

  // Kullanıcı bilgilerini gösteren kart widget'ı
  // Giriş yapan kullanıcının karşılama mesajı ve kısmi gizlenmiş TC kimlik numarasını içerir
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
          // Kullanıcı avatarı - ikon olarak gösterilir
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kullanıcı karşılama mesajı
              Text(
                'Hoşgeldiniz',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              // Kısmi gizlenmiş TC kimlik numarası 
              // Örnek: İlk 3 hane ve son 3 hane gösterilir, ortası yıldızlarla gizlenir
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

  // Başlık satırını oluşturan yardımcı metot
  // Bölüm başlıklarını ikon ile birlikte gösterir
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

  // Menü butonlarını oluşturan yardımcı metot
  // Farklı bölümlere giden butonlar için tutarlı bir görünüm ve davranış sağlar
  // Her buton bir ikon, başlık, açıklama içerir ve tıklandığında ilgili sayfaya yönlendirir
  Widget menuButonu(
      {required IconData ikon,
      required String baslik,
      required String aciklama,
      required Function tiklamaFonksiyonu}) {
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
          // Menü öğesi ikonu - her öğe için farklı ve anlamlı ikonlar kullanılır
          Icon(ikon, color: Colors.blue, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menü başlığı
                Text(
                  baslik,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Menü açıklaması - kullanıcıya öğenin amacını açıklar
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
          // İleri git ikonu - kullanıcıya butonun başka bir sayfaya yönlendireceğini gösterir
          Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
