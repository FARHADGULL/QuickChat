import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/widgets/chat/messages.dart';
import 'package:quick_chat/widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    //FirebaseMessaging.instance.requestPermission(); //for iOS only

    FirebaseMessaging.onMessage.listen((message) {
      print('My on Message (foreground): $message');
      return;
    }); //when app is in foreground and we receive a message then this will be called

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('My on Resume (background): $message');
      return;
    }); //when app is in background or terminated and we receive a message then this will be called

    //token is used to send notification to a specific device
    FirebaseMessaging.instance.getToken().then((token) {
      print('My token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'token': token,
      });
    }); /*this will be called when app is opened for the first time and 
    then it will not be called again until the app is uninstalled and 
    installed again on the device or the token is changed by the firebase 
    messaging instance (which is very rare) or the token is deleted from the 
    firebase messaging instance (which is also very rare)*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Quick Chat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          DropdownButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            items: const [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Container(
        child: const Column(
          children: <Widget>[
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
