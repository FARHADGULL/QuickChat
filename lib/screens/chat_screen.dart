import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(8),
          child: const Text('Chat message'),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
            .collection('chats/m54rKwIcSnzolITjPSHT/messages')
            .snapshots().listen((data) {
            data.docs.forEach((doc) {
              print(doc['text']);
            });
          });
        },
        child: const Icon(Icons.add),
      )
    );
  }
}