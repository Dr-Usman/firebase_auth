import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseHelper {
  FirebaseHelper._();

  static final FirebaseHelper instance = FirebaseHelper._();

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  Future<User?> registerUsingEmailPassword({
    String? name,
    String? email,
    String? password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email ?? '',
        password: password ?? '',
      );

      user = userCredential.user;
      if (user != null) {
        await user?.updateDisplayName(name);
        await user?.reload();
        user = auth.currentUser;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('The provided email address is invalid');
      }
    } catch (e) {
      print('create user error: $e');
    }

    print("User: ${user.toString()}");
    return user;
  }

  Future<User?> signInUsingEmailPassword({
    String? email,
    String? password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email ?? '',
        password: password ?? '',
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      } else if (e.code == 'invalid-email') {
        print('The provided email address is invalid');
      }
    }

    print("User: ${user.toString()}");
    return user;
  }

  Future<User?> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            print("User is already have account with different credential");
          } else if (e.code == 'invalid-credential') {
            print("Invalid credential");
          }
        } catch (e) {
          print("error: $e");
        }
      }
    }

    print("User: ${user.toString()}");
    return user;
  }

  Future<User?> refreshUser(User? user) async {
    User? refreshedUser;
    if (user != null) {
      await user.reload();
      refreshedUser = auth.currentUser;
    }
    return refreshedUser;
  }

  Future logout() => auth.signOut();
}
