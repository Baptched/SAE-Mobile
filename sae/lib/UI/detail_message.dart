import 'package:flutter/material.dart';
import '../database/supabase/messageDB.dart';
import '../database/supabase/utilisateurDB.dart';
import '../models/message.dart';
import '../models/utilisateur.dart';

class ConversationWidget extends StatefulWidget {
  final int idUserConnected;
  final int idUserToChat;

  ConversationWidget({
    required this.idUserConnected,
    required this.idUserToChat,
  });

  @override
  _ConversationWidgetState createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  Utilisateur? _utilisateurConnected;
  Utilisateur? _utilisateurToChat;
  List<Message> messages = [];
  bool _dataLoaded = false;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chargerUsersAndMessages();
  }

  Future<void> chargerUsersAndMessages() async {
    if (!_dataLoaded) {
      _utilisateurConnected =
      await UtilisateurDB.getUtilisateurById(widget.idUserConnected);
      _utilisateurToChat =
      await UtilisateurDB.getUtilisateurById(widget.idUserToChat);
      messages = await MessageDB.getMessagesBetweenUsers(
          widget.idUserConnected, widget.idUserToChat);
      setState(() {
        _dataLoaded = true;
      });
    }
  }

  Future<void> envoyerMessage(String contenu) async {
    if (contenu.isNotEmpty) {
      Message message = Message(
        id: 0,
        idUtilisateurEnvoi: widget.idUserConnected,
        idUtilisateurRecoit: widget.idUserToChat,
        contenu: contenu,
        dateEnvoi: DateTime.now().toString()
      );
      MessageDB.ajouterMessage(message);
      setState(() {
        messages.insert(0, message);
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation avec ${_utilisateurToChat?.pseudo ?? 'Utilisateur'}'),
      ),
      body: _dataLoaded
          ? Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
              child: Text('Aucun message.'),
            )
                : ListView(
              reverse: true,
              padding: EdgeInsets.all(16.0),
              children: messages.map((message) {
                return MessageBubble(
                  isSentByMe: message.idUtilisateurEnvoi == widget.idUserConnected,
                  message: message.contenu,
                );
              }).toList(),
            ),
          ),
          // Zone de saisie pour écrire un nouveau message
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Écrire un message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                FloatingActionButton(
                  onPressed: () {
                    envoyerMessage(_messageController.text);
                  },
                  child: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
