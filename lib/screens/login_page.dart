import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/screens/survey_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final tcController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  
  final logoUrl = 'https://cdn-icons-png.flaticon.com/512/1902/1902201.png';

  bool _validateTC(String? tc) => tc != null && tc.length == 11 && tc[0] != '0';

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    await SharedPreferences.getInstance()
      .then((prefs) => prefs.setString('user_id', tcController.text));
    
    // Ayni zamanda anketleri sifirla
    SurveyPage.resetSurveys();
    
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(logoUrl, height: 70, width: 70),
              SizedBox(height: 16),
              
              Text(
                'Anket Uygulaması',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              
              TextFormField(
                controller: tcController,
                decoration: InputDecoration(
                  labelText: "TC Kimlik No",
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.number,
                maxLength: 11,
                validator: (value) => value == null || value.isEmpty
                  ? 'TC Kimlik gerekli'
                  : !_validateTC(value)
                    ? 'Geçerli bir TC Kimlik giriniz'
                    : null,
              ),
              SizedBox(height: 12),
              
              TextFormField(
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Şifre",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                  ? 'Şifre gerekli'
                  : value.length < 4
                    ? 'Şifre en az 4 karakter olmalı'
                    : null,
              ),
              SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: _isLoading
                    ? SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text('Giriş Yap', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
