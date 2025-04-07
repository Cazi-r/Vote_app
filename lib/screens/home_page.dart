import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 * Ana Sayfa Widget
 
 - Uygulamanın merkezi sayfası olarak tasarlanmıştır.
 - Kullanıcıya: Kişisel karşılama mesajı ve kısmi TC bilgisi ile uygulamanın ana fonksiyonlarına hızlı erişim butonları sunar.
*/

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId; // Giriş yapan kullanıcının ID bilgisi. SharedPreferences'tan yüklenen ve LoginPage'de kaydedilen TC kimlik no.
  
  @override
  void initState() {
    super.initState();
    getUserId(); // Widget ilk oluşturulduğunda kullanıcı ID'sini yükler.
  }

  void getUserId() async { // Kullanıcı kimlik bilgisini SharedPreferences'dan yükleyen metot.
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id'); // Giriş yapıldığında LoginPage tarafından kaydedilen 'user_id' değerini alır.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5181BE),
        title: Text("Ana Sayfa"),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userId != null) createUserCard(),  // Kullanıcı bilgi kartı - sadece kullanıcı giriş yapmışsa gösterilir. TC kimlik numarasının bir kısmını gizleyerek gösterir.
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            createHeaderRow('Hızlı Erişim', Icons.dashboard),
            createMenuButton( // Anket sayfasına giden navigasyon butonu. Kullanıcının mevcut anketlere erişmesini ve oy kullanmasını sağlar.
                icon: Icons.poll,
                title: 'Anketler',
                description: 'Anketlere eriş ve oy kullan',
                onTapFunction: () {
                  Navigator.pushNamed(context, '/survey');
                }
            ),
            SizedBox(height: 10),
            createMenuButton( // İstatistik sayfasına giden navigasyon butonu. Kullanıcının anket sonuçlarını ve istatistikleri görüntülemesini sağlar.
                icon: Icons.bar_chart,
                title: 'İstatistikler',
                description: 'Anket sonuçlarını incele',
                onTapFunction: () {
                  Navigator.pushNamed(context, '/statistics');
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget createUserCard() {  // Kullanıcı bilgilerini gösteren kart widget. Giriş yapan kullanıcının karşılama mesajı ve kısmi gizlenmiş TC kimlik numarasını içerir.
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF5181BE).withOpacity(0.3),
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
            backgroundColor: Color(0xFF5181BE),
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hoşgeldiniz',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'TC: ${userId!.substring(0, 3)}*****${userId!.substring(8, 11)}', // Kısmi gizlenmiş TC kimlik numarası. İlk 3 hane ve son 3 hane gösterilir, ortası yıldızlarla gizlenir.
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

  Widget createHeaderRow(String title, IconData icon) { // Başlık satırını oluşturan yardımcı metot. Bölüm başlıklarını ikon ile birlikte gösterir.
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF5181BE)),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  /*
   - Menü Butonu Oluşturucu: Farklı bölümlere giden butonlar için tutarlı bir görünüm ve davranış sağlar.
   
   - icon: Butonda gösterilecek ikonu tutar.
   - title: Buton başlığını tutar.
   - description: Buton açıklamasını tutar.
   - onTapFunction: Butona tıklandığında çalışacak fonksiyonu tutar.
   - return Özelleştirilmiş ElevatedButton widget'ı tutar.
   
   - Tüm menü butonları tutarlı bir görünüm için bu metotla oluşturulur.
  */
  Widget createMenuButton(
      {required IconData icon,
      required String title,
      required String description,
      required Function onTapFunction}) {
    return ElevatedButton(
      onPressed: () => onTapFunction(),
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
          Icon(icon, color: Color(0xFF5181BE), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward, color: Colors.grey, size: 16), // İleri git ikonu. Kullanıcıya butonun başka bir sayfaya yönlendireceğini gösterir.
        ],
      ),
    );
  }
}
