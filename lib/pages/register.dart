import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_guardian/services/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  String _errorMessage = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final result = await authProvider.register(_username, _password);

      setState(() {
        _isLoading = false;
      });

      if (result.success) {
        // Navigiere zur Login-Seite
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        // Zeige einen Toast, dass die Registrierung erfolgreich war
        Fluttertoast.showToast(
          msg: "Registrierung erfolgreich. Jetzt anmelden!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        setState(() {
          _errorMessage = result.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gleicher Hintergrund wie beim Login-Screen
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/backgroundLoginRegister2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Registrierung',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Benutzername'),
                            onSaved: (value) => _username = value!.trim(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bitte gib deinen Benutzernamen ein';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Passwort'),
                            obscureText: true,
                            onSaved: (value) => _password = value!.trim(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bitte gib dein Passwort ein';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          if (_errorMessage.isNotEmpty)
                            Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          const SizedBox(height: 16),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                            onPressed: _submit,
                            child: const Text('Registrieren'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text('Account existiert bereits? Login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
