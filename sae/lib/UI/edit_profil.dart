import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sae/database/supabase/utilisateurDB.dart';
import 'package:sae/models/utilisateur.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModifierProfilPage extends StatefulWidget {
  @override
  _ModifierProfilPageState createState() => _ModifierProfilPageState();
}

class _ModifierProfilPageState extends State<ModifierProfilPage> {
  late Utilisateur _utilisateur = Utilisateur(
  id: 0,
  nom: '',
  prenom: '',
  pseudo: '',
  motDePasse: '',
  );
  bool _isLoading = true;

  late TextEditingController _pseudoController;
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _nouveauMotDePasseController;

  @override
  void initState() {
    super.initState();
    _chargerInformationsUtilisateur();
    _pseudoController = TextEditingController();
    _nomController = TextEditingController();
    _prenomController = TextEditingController();
    _nouveauMotDePasseController = TextEditingController();
  }

  Future<void> _chargerInformationsUtilisateur() async {
    final pseudo = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('pseudoUtilConnecte');
    });
    try {
      final utilisateur = await UtilisateurDB.getUtilisateurByPseudo(pseudo!);
      if (utilisateur != null) {
        setState(() {
          _utilisateur = utilisateur;
          _isLoading = false; // Marque le chargement comme terminé

          _pseudoController.text = _utilisateur.pseudo;
          _nomController.text = _utilisateur.nom;
          _prenomController.text = _utilisateur.prenom;
          _nouveauMotDePasseController.text = _utilisateur.motDePasse;
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations utilisateur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_utilisateur == null) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Modifier le profil'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center( // Centrer l'image de profil
                child: _isLoading
                    ? const CircularProgressIndicator() // Indicateur de chargement
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.memory(
                    _utilisateur.imageUint8List ?? Uint8List(0),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Pseudo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _pseudoController,
              ),
              SizedBox(height: 16),
              Text(
                'Nom',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  hintText: 'Entrez votre nom',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Prénom',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(
                  hintText: 'Entrez votre prénom',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Nouveau mot de passe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nouveauMotDePasseController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Entrez votre nouveau mot de passe',
                ),
              ),
              SizedBox(height: 32),
              Center( // Centrer le bouton "Enregistrer les modifications"
                child: ElevatedButton(
                  onPressed: () {
                    _modifierProfil();
                  },
                  child: Text('Enregistrer les modifications'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }



  Future<void> _modifierProfil() async {
    if (_nomController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _nouveauMotDePasseController.text.isEmpty ||
        _pseudoController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Veuillez remplir tous les champs.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (await UtilisateurDB.getUtilisateurByPseudo(_pseudoController.text) !=
        null &&
        _pseudoController.text != _utilisateur.pseudo) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Le pseudo est déjà utilisé par un autre utilisateur.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final nouveauPseudo = _pseudoController.text;
    final nouveauNom = _nomController.text;
    final nouveauPrenom = _prenomController.text;
    final nouveauMotDePasse = _nouveauMotDePasseController.text;

    final utilisateurModifie = Utilisateur(
      id: _utilisateur.id,
      nom: nouveauNom,
      prenom: nouveauPrenom,
      pseudo: nouveauPseudo,
      motDePasse: nouveauMotDePasse,
    );

    try {
      await UtilisateurDB.updateUtilisateurWithoutImage(utilisateurModifie);

      await SharedPreferences.getInstance().then((prefs) {
        prefs.setString('pseudoUtilConnecte', nouveauPseudo);
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Succès'),
            content: Text('Profil mis à jour avec succès.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Erreur lors de la mise à jour du profil: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Une erreur s\'est produite lors de la mise à jour du profil. Veuillez réessayer.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _nouveauMotDePasseController.dispose();
    super.dispose();
  }
}
