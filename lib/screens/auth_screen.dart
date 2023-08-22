import 'dart:io';

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
        print('Sign up successful');

        //first getting reference/pointer to firebase storage to store image
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${authResult.user!.uid} .jpg');

        //then uploading XFile image to firebase storage
        await ref.putFile(
          //converting XFile to File
          File(userImage.path),
        );

        //getting url of image stored in firebase storage
        final url = await ref.getDownloadURL();

        /*storing username, email, and image_url in firestore database by creating 
        a new collection named users and adding a document with id 
        as user id and storing username, email, image_url in it*/
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set(
          {
            'username': username,
            'email': useremail,
            'image_url': url,
          },
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
