import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tcController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  
  final String logoUrl = 'https://cdn-icons-png.flaticon.com/512/1902/1902201.png';

  bool _validateTCKimlik(String? tc) {
    if (tc == null || tc.isEmpty) return false;
    if (tc.length != 11) return false;
    if (tc[0] == '0') return false;
    
    for (int i = 0; i < tc.length; i++) {
      if (int.tryParse(tc[i]) == null) return false;
    }
    
    return true;
  }

  Future<void> login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(Duration(seconds: 1));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', tcController.text);

    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(179, 237, 237, 237),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                  logoUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Anket Uygulaması',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  
                  TextFormField(
                    controller: tcController,
                    decoration: InputDecoration(
                      labelText: "TC Kimlik Numaranız",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'TC Kimlik Numarası Gerekli';
                      }
                      if (!_validateTCKimlik(value)) {
                        return 'Geçerli bir TC Kimlik Numarası Giriniz';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Şifreniz",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şifre Gerekli';
                      }
                      if (value.length < 4) {
                        return 'Şifreniz en az 4 karakter olmalıdır';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 25),
                  
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => login(context),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Giriş Yap'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
