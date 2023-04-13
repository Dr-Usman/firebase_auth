import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/firebase_helper.dart';
import '../helpers/my_validators.dart';
import '../widgets/custom_button.dart';
import 'profile_page.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Authentication'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              focusNode: _focusEmail,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _passwordController,
              focusNode: _focusPassword,
              obscureText: true,
              validator: Validators.validatePassword,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    title: 'Sign In',
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        User? user = await FirebaseHelper.instance
                            .signInUsingEmailPassword(
                          email: _emailController.text.toLowerCase().trim(),
                          password: _passwordController.text.trim(),
                        );
                        if (user != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(user: user),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    title: 'Register',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
