import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/survey_page.dart';
import 'screens/statistics_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anket Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/survey': (context) => SurveyPage(),
        '/statistics': (context) => StatisticsPage(),
      },
    );
  }
}

// oy verince tik gözükecek, yenile tuşuna basmadan tekrar oy verme işlemi yapılmayacak.