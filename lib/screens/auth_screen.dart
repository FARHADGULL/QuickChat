import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
    String username,
    String userpassword,
    XFile userImage,
    bool isLogin,
  ) async {
    print('userrr Email: ${useremail}');
    print('Userrr Name: ${isLogin ? 'N/A' : username}');
    print('userrr Password: $userpassword');
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

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user!.uid + '.jpg');

        //upload XFile image to firebase storage

        await FirebaseFirestore.instance
            .collection('users')
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
