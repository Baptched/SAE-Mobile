import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sae/UI/connexion.dart';
import 'package:sae/database/supabase/utilisateurDB.dart';
import 'package:supabase/supabase.dart';

import '../models/utilisateur.dart';

class Inscription extends StatelessWidget {
  final SupabaseClient supabase;

  const Inscription({Key? key, required this.supabase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController prenomController = TextEditingController();
    TextEditingController nomController = TextEditingController();
    TextEditingController pseudoController = TextEditingController();
    TextEditingController motDePasseController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Inscription',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: pseudoController,
                decoration: InputDecoration(
                  labelText: 'Pseudo',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: motDePasseController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Fonction pour effectuer l'inscription
                  String prenom = prenomController.text;
                  String nom = nomController.text;
                  String pseudo = pseudoController.text;
                  String motDePasse = motDePasseController.text;

                  // Vérification des champs
                  if (prenom.isEmpty || nom.isEmpty || pseudo.isEmpty || motDePasse.isEmpty) {
                    final snackBar = SnackBar(
                      content: Text('Veuillez remplir tous les champs'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  // Vérification de l'unicité du pseudo
                  final Utilisateur? responsePseudo = await UtilisateurDB.getUtilisateurByPseudo(pseudo);

                  if (responsePseudo != null) {
                    final snackBar = SnackBar(
                      content: Text('Pseudo déjà utilisé'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  ByteData imageData = await rootBundle.load('assets/product_img/default_user_image.png');
                  Uint8List imageProfilBytesList = imageData.buffer.asUint8List();
                  print(imageProfilBytesList);


                  Utilisateur u = Utilisateur(
                    id: 0,
                    prenom: prenom,
                    nom: nom,
                    pseudo: pseudo,
                    motDePasse: motDePasse,
                    imageProfilBytes: imageProfilBytesList,
                  );

                  await UtilisateurDB.insererUtilisateur(u);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Connexion(supabase: supabase)),
                  );
                  // Affichage d'un message de succès
                  final snackBar = SnackBar(
                    content: Text('Inscription réussie'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Text('Inscription'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
