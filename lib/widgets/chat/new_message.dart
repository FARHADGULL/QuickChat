import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = '';

  void _sendMessageToFirestore() async {
    //FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance
        .currentUser; //getting current user id from firebase auth instance
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get(); //getting username and image url from firestore database using user id from firebase auth instance
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    }); //adding message to firestore database in chat collection with fields text, createdAt, userId, username, userImage and their values as entered by user in the chat screen
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed:
                _enteredMessage.trim().isEmpty ? null : _sendMessageToFirestore,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
