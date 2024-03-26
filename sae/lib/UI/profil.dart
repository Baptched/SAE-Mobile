import 'package:flutter/material.dart';
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
        _lienImageProfil = utilisateur.imageProfil;
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations utilisateur: $e');
    }
  }



  late String _pseudo = '';
  late String _lienImageProfil = 'default_user_image.png';
  late Utilisateur _utilisateur = Utilisateur(
    id: 0,
    nom: '',
    prenom: '',
    pseudo: '',
    motDePasse: '',
    imageProfil: 'default_user_image.png',
  );

  ProfilPage() {
    _chargerInformationsUtilisateur();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey, // Couleur de fond par défaut
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/user_img/default_user_image.png'),
                      // Remplacez par le chemin de l'image de profil de l'utilisateur
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16), // Espacement entre l'image et le texte
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _utilisateur.pseudo, // Remplacez par le pseudo de l'utilisateur
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8), // Espacement entre le pseudo et le label
                    Text(
                      'Voir mon profil',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Espacement après le rectangle de profil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Mes objets',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Mes annonces',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Mes réservations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
