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
    return tc != null && tc.length == 11 && tc[0] != '0';
  }

  Future<void> login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
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
      body: SafeArea(
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
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16),
                Text(
                  'Anket Uygulamasi',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'TC Kimlik gerekli';
                    }
                    if (!_validateTCKimlik(value)) {
                      return 'Gecerli bir TC Kimlik giriniz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Sifre",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
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
                      return 'Sifre gerekli';
                    }
                    if (value.length < 4) {
                      return 'Sifre en az 4 karakter olmali';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: _isLoading ? null : () => login(context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Giris Yap', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
