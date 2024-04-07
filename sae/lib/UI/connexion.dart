import 'package:flutter/material.dart';
import 'package:sae/UI/inscription.dart';
import 'package:sae/database/supabase/utilisateurDB.dart';
import 'package:sae/models/utilisateur.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class Connexion extends StatelessWidget {

  const Connexion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nomUtilisateurController = TextEditingController();
    TextEditingController motDePasseController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Connexion',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nomUtilisateurController,
                decoration: const InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: motDePasseController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Alignement des boutons
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Fonction pour effectuer la connexion
                      String nomUtilisateur = nomUtilisateurController.text;
                      String motDePasse = motDePasseController.text;

                      // Vérifier si les champs sont vides
                      if (nomUtilisateur.isEmpty || motDePasse.isEmpty) {
                        final snackBar = SnackBar(
                          content: Text('Veuillez remplir tous les champs'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      // Interrogation de la base de données pour vérifier l'utilisateur
                      Utilisateur? u = await UtilisateurDB
                          .getUtilisateurByPseudoAndMotDePasse(
                          nomUtilisateur, motDePasse);

                      if (u != null) {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('pseudoUtilConnecte', nomUtilisateur);
                        prefs.setInt('idUtilConnecte', u.id);
                        int idUser = u.id;

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home(indexInitial: 0),),
                        );
                      } else {
                        final snackBar = SnackBar(
                          content: Text(
                              'Nom d\'utilisateur ou mot de passe incorrect'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('Connexion'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Inscription()),
                      );
                    },
                    child: const Text('Inscription'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}