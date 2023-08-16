import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseFirestore.instance
            .collection('chats/8VMCrk3F4deQ6hfbv2E2/messages')
            .snapshots(), builder: (BuildContext, streamSnapshot){
              if (streamSnapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documents = streamSnapshot.data?.docs;
              return ListView.builder(
        itemCount: documents!.length,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(8),
          child: Text(documents[index]['text']),
        )
      );
            },),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: const Icon(Icons.add),
      )
    );
  }
}