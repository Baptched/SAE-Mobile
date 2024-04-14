import 'dart:async';
import 'package:sae/main.dart';
import 'package:collection/collection.dart';
import 'package:sae/models/message.dart';

class MessageDB {
  static Future<List<Message>> getMessagesBetweenUsers(
      int idUserConnected, int idUserToChat) async {
    final data = await MyApp.client
        .from('Message')
        .select()
        .or('iduenvoi.eq.$idUserConnected,idurecoit.eq.$idUserConnected')
        .or('iduenvoi.eq.$idUserToChat,idurecoit.eq.$idUserToChat')
        .order('dateenvoi', ascending: false);

    List<Message> messages = [];
    for (var m in data) {
      messages.add(Message.fromJson(m));
    }
    return messages;
  }

  static void ajouterMessage(Message message) async {
    await MyApp.client.from('Message').insert({
      'contenu': message.contenu,
      'iduenvoi': message.idUtilisateurEnvoi,
      'idurecoit': message.idUtilisateurRecoit,
      'dateenvoi': message.dateEnvoi,
    });
  }

  static Future<List<Message>> getConversations(int idUserConnected) async {
    print('idUserConnected: $idUserConnected');
    final data = await MyApp.client
        .from('Message')
        .select()
        .or('iduenvoi.eq.$idUserConnected,idurecoit.eq.$idUserConnected');
    print('data: $data');
    List<Message> messages = [];
    for (var m in data) {
      messages.add(Message.fromJson(m));
    }

    // Group messages by conversation
    var groupedMessages = groupBy(messages,
        (Message m) => '${m.idUtilisateurEnvoi}-${m.idUtilisateurRecoit}');

    // Select the last message from each group
    List<Message> lastMessages = [];
    for (var group in groupedMessages.values) {
      lastMessages.add(group.last);
    }
    print('lastMessages: $lastMessages');
    return lastMessages;
  }
}
