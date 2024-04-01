import 'package:flutter/material.dart';

class ConversationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation avec Baptched'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.all(16.0),
              children: [
                // Messages dans la conversation
                MessageBubble(isSentByMe: false, message: 'Salut ! Comment ça va ?'),
                MessageBubble(isSentByMe: true, message: 'Salut ! Ça va bien, et toi ?'),
                MessageBubble(isSentByMe: false, message: 'Ça va super, merci !'),
                // Ajoutez d'autres messages ici
              ],
            ),
          ),
          // Zone de saisie pour écrire un nouveau message
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Écrire un message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                FloatingActionButton(
                  onPressed: () {
                    // Action pour envoyer le message
                  },
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isSentByMe;
  final String message;

  const MessageBubble({
    required this.isSentByMe,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSentByMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
