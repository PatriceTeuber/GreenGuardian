import 'package:flutter/material.dart';
import 'package:green_guardian/pages/register.dart';
import 'package:provider/provider.dart';
import 'package:green_guardian/services/auth_provider.dart';
import 'package:green_guardian/pages/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      final result = await authProvider.login(_username, _password);

      setState(() {
        _isLoading = false;
      });

      if (result.success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
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
      // Hintergrund mit sanftem Farbverlauf
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/login.jpg'),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Login', style: Theme.of(context).textTheme.headlineMedium),
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
                              child: const Text('Login'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                );
                              },
                              child: const Text('Noch keinen Account? Registrieren'),
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
