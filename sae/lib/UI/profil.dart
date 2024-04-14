import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sae/UI/edit_profil.dart';
import 'package:sae/UI/mes_annonces.dart';
import 'package:sae/UI/produits.dart';
import 'package:sae/models/utilisateur.dart';
import 'package:sae/database/supabase/utilisateurDB.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sae/UI/connexion.dart';
import 'package:sae/UI/mes_reservations.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late String _pseudo = '';
  late Utilisateur _utilisateur = Utilisateur(
    id: 0,
    nom: '',
    prenom: '',
    pseudo: '',
    motDePasse: '',
  );

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerInformationsUtilisateur();
  }

  Future<void> _chargerInformationsUtilisateur() async {
    // Récupérer le pseudo de l'utilisateur connecté
    final pseudo = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('pseudoUtilConnecte');
    });
    if (pseudo != null) {
      _pseudo = pseudo;
    }
    try {
      final utilisateur = await UtilisateurDB.getUtilisateurByPseudo(_pseudo);
      if (utilisateur != null) {
        setState(() {
          _utilisateur = utilisateur;
          _isLoading = false; // Marque le chargement comme terminé
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations utilisateur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding:  EdgeInsets.symmetric(vertical: 10.0),
            child:  Text(
              'Profil',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ModifierProfilPage()));
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _isLoading
                      ? CircularProgressIndicator() // Indicateur de chargement
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.memory(
                      _utilisateur.imageUint8List ?? Uint8List(0),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _utilisateur.pseudo,
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => WidgetProduits()));
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MesReservationsPage()));
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
      SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120.0),
            child: ElevatedButton(
              onPressed: () {
                // Action de déconnexion
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Connexion()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Couleur de fond
                padding: EdgeInsets.symmetric(vertical: 16.0), // Espacement interne
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), // Bordures arrondies
              ),
              child: Text(
                'Se déconnecter',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
