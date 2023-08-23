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
    final fbm = FirebaseMessaging.instance
        .getInitialMessage(); //when app is in background and we open the app from the notification then this will be called

    print('My get initial message: ${fbm}');

    FirebaseMessaging.onMessage.listen((message) {
      print('My on Message (foreground): ${message}');
      return;
    }); //when app is in foreground and we receive a message then this will be called

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('My on Resume (background): ${message}');
      return;
    }); //when app is in background or terminated and we receive a message then this will be called

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Quick Chat',
          style: TextStyle(color: Colors.white),
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
