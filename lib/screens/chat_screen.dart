import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_chat/widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/8VMCrk3F4deQ6hfbv2E2/messages')
              .add({'text': 'This was added by clicking the button!'});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
