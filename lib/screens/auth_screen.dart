import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_chat/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _submitAuthForm(
    String useremail,
    String userpassword,
    String username,
    bool isLogin,
  ) async {
    UserCredential authResult;
    try {
      if (isLogin) {
        authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: useremail, password: userpassword);
        print('Log in successful');
      } else {
        authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: useremail,
          password: userpassword,
        );
        print('Sgn up successful');
        await FirebaseFirestore.instance
            .collection('user')
            .doc(authResult.user!.uid)
            .set(
          {'username': username, 'email': useremail},
        );
      }
    } on PlatformException catch (err) {
      String msg = 'please enter right credentials!';
      if (err.message != null) {
        msg = err.message!;
      }
      SnackBar(content: Text(msg));
    } catch (err) {
      print('Erorrrr $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthForm(_submitAuthForm),
    );
  }
}
