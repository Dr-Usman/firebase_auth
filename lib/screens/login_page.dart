import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/firebase_helper.dart';
import '../helpers/my_validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'profile_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _focusEmail = FocusNode();

  final FocusNode _focusPassword = FocusNode();

  bool _isProcessing = false;

  void _updateProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomTextField(
                controller: _emailController,
                focusNode: _focusEmail,
                validator: Validators.validateEmail,
                keyboardType: TextInputType.emailAddress,
                hintText: "Email",
              ),
              const SizedBox(height: 8.0),
              CustomTextField(
                isPassword: true,
                controller: _passwordController,
                focusNode: _focusPassword,
                validator: Validators.validatePassword,
                keyboardType: TextInputType.visiblePassword,
                hintText: "Password",
              ),
              const SizedBox(height: 20),
              _isProcessing
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomButton(
                            title: 'Sign In',
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                _updateProcessing(true);

                                User? user = await FirebaseHelper.instance
                                    .signInUsingEmailPassword(
                                  email: _emailController.text
                                      .toLowerCase()
                                      .trim(),
                                  password: _passwordController.text.trim(),
                                );

                                _updateProcessing(false);

                                if (user != null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const ProfilePage(),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
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
              const SizedBox(height: 20),
              CustomButton(
                title: 'Sign In with Google',
                onTap: () async {
                  User? user = await FirebaseHelper.instance.signInWithGoogle();

                  if (user != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
