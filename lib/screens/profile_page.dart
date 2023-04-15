import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/helpers/firebase_helper.dart';
import 'package:firebase_authentication/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final bool _isSendingVerification = false;
  final bool _isSigningOut = false;

  User? _currentUser = FirebaseHelper.instance.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: _currentUser == null
            ? const Text('No User Exist')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NAME: ${_currentUser?.displayName}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'EMAIL: ${_currentUser?.email}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16.0),
                  _currentUser?.emailVerified == true
                      ? Text(
                          'Email verified',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.green),
                        )
                      : Text(
                          'Email not verified',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.red),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        title: 'Verify email',
                        onTap: () async {
                          if (_currentUser != null) {
                            await _currentUser?.sendEmailVerification();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          User? user = await FirebaseHelper.instance
                              .refreshUser(_currentUser);
                          if (user != null) {
                            setState(() {
                              _currentUser = user;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  CustomButton(
                    title: 'Sign Out',
                    onTap: () {
                      FirebaseHelper.instance.logout();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
