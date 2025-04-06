# Anket Uygulaması (Vote App)

Bu proje, kullanıcıların TC kimlik numaralarıyla giriş yapıp çeşitli anketlere katılabilecekleri ve anket sonuçlarını görüntüleyebilecekleri bir mobil uygulamadır. Flutter ile geliştirilmiş, kullanıcı dostu arayüzü ile herkesin kolayca kullanabileceği bir yapıda tasarlanmıştır.

## Uygulama Özellikleri

- TC kimlik numarası doğrulama ile güvenli giriş
- Farklı kategorilerde anketler
- Her kullanıcının her ankete sadece bir kez oy verebilmesi
- Anket sonuçlarının gerçek zamanlı görüntülenmesi
- Kullanıcı oturum bilgilerinin güvenli şekilde saklanması

## Ekran Görüntüleri

### 1. Giriş Sayfası
![Giriş Sayfası](images/login.png)

**Giriş sayfasında kullanıcılar:**
- TC kimlik numarası giriş alanı
- Şifre giriş alanı
- Giriş yapma butonu
- Uygulama logosu

TC kimlik numarası 11 haneli olmalı ve ilk rakamı 0 olmamalıdır.

---

### 2. Ana Sayfa
![Ana Sayfa](images/home.png)

**Ana sayfada kullanıcılar:**
- Karşılama mesajı ve kısmi gizlenmiş TC numarası
- Anketler ve İstatistikler sayfalarına erişim butonları
- Sayfa üst kısmında menü erişimi

Hızlı erişim butonları ve kullanıcı bilgileri ile ana ekrandan kolay navigasyon.

---

### 3. Drawer Menü
![Drawer Menü](images/drawer.png)

**Drawer menüde:**
- Uygulama logosu ve ismi
- Ana Sayfa menü öğesi
- Anketler menü öğesi
- İstatistikler menü öğesi
- Çıkış butonuyla oturum kapatma

Yan menü sayesinde uygulama içinde kolay gezinme sağlanır.

---

### 4. Anketler Sayfası
![Anketler Sayfası](images/surveys.png)

**Anketler sayfasında:**
- Mevcut anketlerin liste halinde gösterimi
- Her anket için farklı seçenekler
- Kullanıcının daha önce oy verip vermediği bilgisi
- Oy verdikten sonra sonuçların görüntülenmesi

Kullanıcılar her ankete sadece bir kez oy verebilir ve sonuçları anında görebilir.

---

### 5. İstatistikler Sayfası
![İstatistikler Sayfası](images/statistics.png)

**İstatistikler sayfasında:**
- Anketlerin toplam oy sayıları
- Her seçeneğin aldığı oy ve yüzdesi
- Görsel ilerleme çubukları
- Renk kodlamasıyla anket kategorileri

İstatistik sayfası, oy dağılımını ve anketin popülaritesini görsel olarak sunar.

## Sayfaların Görevleri ve İçerikleri

### 1. Giriş Sayfası (Login Page)
- **Görev**: Kullanıcıların uygulamaya giriş yapmalarını sağlar
- **İçerik**:
  - TC kimlik numarası doğrulama (11 hane ve ilk rakam 0 olmamalı)
  - Şifre alanı (güvenlik için gizli metin)
  - Giriş yapma butonu
  - Uygulama logosu

### 2. Ana Sayfa (Home Page)
- **Görev**: Kullanıcıya temel navigasyon ve özet bilgi sağlar
- **İçerik**:
  - Kullanıcı bilgilerini gösteren kart (TC kimlik numarasının gizlenmiş hali)
  - Anketler ve İstatistikler sayfalarına hızlı erişim butonları
  - Kolay kullanım için açıklamalı menü öğeleri

### 3. Anketler Sayfası (Survey Page)
- **Görev**: Kullanıcıların anketlere katılmasını sağlar
- **İçerik**:
  - Mevcut anketlerin listesi (meyve tercihi, mevsim tercihi, spor tercihi gibi)
  - Her anket için seçenekler
  - Kullanıcının oy durumu (daha önce oy kullanmış mı)
  - Oy verildikten sonra sonuçların görüntülenmesi
  - Her kullanıcının her ankete sadece bir kez oy verebilmesi

### 4. İstatistikler Sayfası (Statistics Page)
- **Görev**: Anket sonuçlarını görselleştirir
- **İçerik**:
  - Her anketin toplam oy sayısı
  - Her seçeneğin aldığı oy sayısı ve yüzdesi
  - Görsel ilerleme çubukları
  - Seçeneklerin popülerliğini gösteren grafiksel gösterimler

## Drawer Menü ve Logo API Bilgileri

Uygulamanın yan menüsünde (Drawer) kullanılan logo, Flaticon API'sinden alınmıştır:
- **Logo URL**: https://cdn-icons-png.flaticon.com/512/1902/1902201.png
- **Kaynak**: Flaticon ücretsiz ikonlar
- **Kullanım**: Drawer başlığında ve giriş sayfasında uygulamanın markalaşması için kullanılmıştır

## Login Bilgilerinin Saklanması

Kullanıcı giriş bilgileri şu şekilde saklanır ve yönetilir:

1. **SharedPreferences Kullanımı**:
   - TC kimlik numarası, uygulamanın yerel depolama alanında `'user_id'` anahtarı ile saklanır
   - Şifre güvenlik nedeniyle saklanmaz, sadece giriş sırasında doğrulanır
   - Kod örneği:
   ```dart
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString('user_id', tcController.text);
   ```

2. **Oturum Yönetimi**:
   - Kullanıcı giriş yaptığında, TC kimlik numarası cihazda saklanır
   - Uygulama içinde diğer sayfalara geçişlerde bu bilgi kullanılır
   - Kullanıcı çıkış yaptığında bu bilgi temizlenir

3. **Oy Verme Kayıtları**:
   - Her kullanıcının her ankette kullandığı oylar, `'selectedOption_${userId}_$surveyIndex'` formatında benzersiz anahtarlarla yerel olarak saklanır
   - Bu sayede bir kullanıcının aynı ankete birden fazla oy vermesi engellenir

## Veri Yapısı

Anket verileri aşağıdaki yapıda saklanır:

```dart
List<Map<String, dynamic>> surveys = [
  {
    'soru': 'Aşağıdaki meyvelerden hangisini daha çok seversiniz?',
    'secenekler': ['Elma', 'Muz', 'Çilek'],
    'oylar': [0, 0, 0],
    'ikon': Icons.food_bank,
    'renk': Colors.green,
  },
  // Diğer anketler...
];
```

## Grup Üyelerinin Projeye Katkısı

| Üye Adı | Katkı |
|---------|-------|
| Üye 1   | Araştırma, tasarım ve giriş sayfası kodlaması |
| Üye 2   | Anket sayfası ve veri yönetimi |
| Üye 3   | İstatistik sayfası ve görsel bileşenler |
| Üye 4   | Drawer menü ve navigasyon yapısı |

## Teknik Detaylar ve Diğer Özellikler

### Kullanılan Teknolojiler
- **Flutter**: Çapraz platform uygulama geliştirme
- **Dart**: Programlama dili
- **SharedPreferences**: Yerel veri depolama
- **Material Design**: Kullanıcı arayüzü tasarımı

### Kod Organizasyonu
- **lib/screens/**: Uygulama sayfaları (login_page.dart, home_page.dart, survey_page.dart, statistics_page.dart)
- **lib/widgets/**: Tekrar kullanılabilir widget'lar (custom_drawer.dart)
- **lib/main.dart**: Uygulama başlangıç noktası ve rota tanımları

### Gelecek Gelişmeler
- Bulut tabanlı veri depolama entegrasyonu
- Kullanıcılara özel anket oluşturma özelliği
- Daha gelişmiş istatistik görselleştirmeleri
- Çoklu dil desteği

---

*Bu proje, Flutter öğrenim sürecinin bir parçası olarak geliştirilmiştir. Tüm geri bildirimler için teşekkür ederiz.*
