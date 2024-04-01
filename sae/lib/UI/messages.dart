import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sae/UI/detail_message.dart';

class MessagesPage extends StatelessWidget {
  final List<String> noms = [
    'Baptched',
    'Kyks',
    'Samuel',
    'Seb',
    'Gael',
    // Ajoutez d'autres noms si nécessaire
  ];

  final List<String> messages = [
    'j\'ai farmé 4000 trophées sur brawlstars en un weekend',
    '4e de promo et tjrs célibataire je comprends pas',
    'j\'ai pas de stage gros c la merde',
    'Kyyyyyyyyyyyyyyyyks',
    'Oui j\'ai mangé une morbiflette a 6 000 calories et alors ?',
    // Ajoutez d'autres messages si nécessaire
  ];

  final Random random = Random();

  String getRandomHour() {
    return '${random.nextInt(24).toString().padLeft(2, '0')}:${random.nextInt(60).toString().padLeft(2, '0')}';
  }

  int getRandomNumberOfAds() {
    return random.nextInt(5); // Génère un nombre aléatoire entre 0 et 4
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vos conversations'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Action de recherche
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Autres actions
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: noms.length,
        separatorBuilder: (context, index) => Divider(), // Ajoutez un séparateur entre chaque conversation
        itemBuilder: (context, index) {
          final nom = noms[index];
          final message = messages[index];
          final heure = getRandomHour();
          final nombreAnnonces = getRandomNumberOfAds();
          return GestureDetector(
            onTap: () {
              // Action à effectuer lors du tap sur la conversation
              Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationWidget()));
              // Vous pouvez naviguer vers une autre page ici
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/user_img/default_user_image.png'),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              nom,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8.0),
                            Text('$nombreAnnonces annonces'), // Nombre aléatoire d'annonces à côté du prénom
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Text(message),
                        SizedBox(height: 8.0),
                        Text(
                          heure, // Heure du message
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action pour composer un nouveau message
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
