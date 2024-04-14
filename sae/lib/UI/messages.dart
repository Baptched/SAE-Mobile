import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/supabase/messageDB.dart';
import '../database/supabase/utilisateurDB.dart';
import '../models/message.dart';
import '../models/utilisateur.dart';
import 'detail_message.dart';

class ConversationsPage extends StatefulWidget {
  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  late Future<List<Message>> _conversationsFuture;
  late Future<int?> _userIdFuture;

  @override
  void initState() {
    super.initState();
    _userIdFuture = _initialiser();
    _conversationsFuture = chargerConversations();
  }

  Future<int?> _initialiser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idUtilConnecte');
  }

  Future<List<Message>> chargerConversations() async {
    final userId = await _userIdFuture;
    if (userId != null) {
      return await MessageDB.getConversations(userId);
    } else {
      return []; // Retourne une liste vide en cas d'échec de récupération de l'ID utilisateur
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _userIdFuture = _initialiser(),
      builder: (context, userIdSnapshot) {
        if (userIdSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Conversations'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (userIdSnapshot.hasError || userIdSnapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Conversations'),
            ),
            body: Center(child: Text('Erreur lors de la récupération de l\'ID utilisateur.')),
          );
        } else {
          return _buildConversationsPage(userIdSnapshot.data!);
        }
      },
    );
  }

  Widget _buildConversationsPage(int userId) {
    if (_userIdFuture == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations'),
      ),
      body: FutureBuilder<List<Message>>(
        future: _conversationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Une erreur est survenue.'));
          } else {
            List<Message> conversations = snapshot.data!;
            if (conversations.isEmpty) {
              return Center(child: Text('Aucune conversation disponible.'));
            }
            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                Message message = conversations[index];
                return _buildConversationItem(userId, message);
              },
            );
          }
        },
      ),
    );
  }


  Widget _buildConversationItem(int userId, Message message) {
    return FutureBuilder<Utilisateur?>(
      future: UtilisateurDB.getUtilisateurById(
        message.idUtilisateurEnvoi == userId
            ? message.idUtilisateurRecoit
            : message.idUtilisateurEnvoi,
      ),
      builder: (context, utilisateurSnapshot) {
        if (utilisateurSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (utilisateurSnapshot.hasError) {
          return Center(child: Text('Une erreur est survenue.'));
        } else {
          Utilisateur? utilisateurAutre = utilisateurSnapshot.data;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversationWidget(
                    idUserConnected: userId,
                    idUserToChat: utilisateurAutre?.id ?? 0,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 3, // Définir l'élévation de la carte pour une apparence légèrement en relief
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: utilisateurAutre?.imageUint8List != null
                        ? Image.memory(
                      utilisateurAutre!.imageUint8List!,
                    ).image
                        : null,
                  ),
                  title: Text(
                    utilisateurAutre?.pseudo ?? ' ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.0),
                      Text(
                        message.contenu,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        message.dateEnvoi,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
