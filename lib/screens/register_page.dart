import 'package:firebase_authentication/helpers/firebase_helper.dart';
import 'package:firebase_authentication/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/my_validators.dart';
import '../widgets/custom_textfield.dart';
import 'profile_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

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
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _registerFormKey,
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      controller: _nameTextController,
                      focusNode: _focusName,
                      validator: Validators.validateName,
                      keyboardType: TextInputType.name,
                      hintText: "Name",
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextField(
                      controller: _emailTextController,
                      focusNode: _focusEmail,
                      validator: Validators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Email",
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextField(
                      isPassword: true,
                      controller: _passwordTextController,
                      focusNode: _focusPassword,
                      validator: Validators.validatePassword,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: "Password",
                    ),
                    const SizedBox(height: 32.0),
                    _isProcessing
                        ? const CircularProgressIndicator()
                        : Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  title: 'Sign up',
                                  onTap: () async {
                                    _updateProcessing(true);

                                    if (_registerFormKey.currentState!
                                        .validate()) {
                                      User? user = await FirebaseHelper.instance
                                          .registerUsingEmailPassword(
                                        name: _nameTextController.text.trim(),
                                        email: _emailTextController.text
                                            .toLowerCase()
                                            .trim(),
                                        password:
                                            _passwordTextController.text.trim(),
                                      );

                                      _updateProcessing(false);

                                      if (user != null) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage(user: user),
                                          ),
                                          (_) => false,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
