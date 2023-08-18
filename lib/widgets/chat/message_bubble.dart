import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            width: 140,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
              ),
            )),
      ],
    );
  }
}
