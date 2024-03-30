import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sae/UI/mes_annonces.dart';
import 'package:sae/UI/produits.dart';
import 'package:sae/models/utilisateur.dart';
import 'package:sae/database/supabase/utilisateurDB.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatelessWidget {
  Future<void> _chargerInformationsUtilisateur() async {
    final pseudo = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('pseudoUtilConnecte');
    });
    if (pseudo != null) {
      _pseudo = pseudo;
    }
    // Récupérer les informations de l'utilisateur depuis la base de données
    try {
      final utilisateur = await UtilisateurDB.getUtilisateurByPseudo(_pseudo);
      if (utilisateur != null) {
        _utilisateur = utilisateur;
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations utilisateur: $e');
    }
  }

  late String _pseudo = '';
  late Utilisateur _utilisateur = Utilisateur(
    id: 0,
    nom: '',
    prenom: '',
    pseudo: '',
    motDePasse: '',
  );

  ProfilPage() {
    _chargerInformationsUtilisateur();
  }

  @override
  Widget build(BuildContext context) {
    print(_utilisateur.imageProfilBytes);
    // print the type of imageProfilbytes
    print(_utilisateur.imageProfilBytes.runtimeType);

    print(_utilisateur.imageProfilBytes?.lengthInBytes);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Profil',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              // Ajoutez votre action ici
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey, // Default background color
                      image: _utilisateur.imageProfilBytes != null
                      // If there’s a profile image, use it
                          ? DecorationImage(
                        image: MemoryImage(_utilisateur.imageProfilBytes!),
                        fit: BoxFit.cover,
                      )
                      // Else, use a default image from assets
                          : DecorationImage(
                        image: AssetImage('assets/user_img/default_user_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _utilisateur.pseudo, // Remplacez par le pseudo de l'utilisateur
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Voir mon profil',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: Colors.grey,
            height: 10,
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WidgetProduits()));
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.inventory),
                  SizedBox(width: 16),
                  Text(
                    'Mes objets',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WidgetAnnonces()));
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.campaign),
                  SizedBox(width: 16),
                  Text(
                    'Mes annonces',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              // Ajoutez votre action ici
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.handshake),
                  SizedBox(width: 16),
                  Text(
                    'Mes réservations',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
