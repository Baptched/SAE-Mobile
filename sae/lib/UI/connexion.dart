import 'package:flutter/material.dart';
import 'package:sae/UI/inscription.dart';
import 'package:supabase/supabase.dart';
import 'home.dart';

class Connexion extends StatelessWidget {
  final SupabaseClient supabase;

  const Connexion({Key? key, required this.supabase}) : super(key: key);

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
                      final response = await supabase.from('utilisateur').select().eq('pseudo', nomUtilisateur).eq('motdepasse', motDePasse);
                      print(response);

                      // Vérifier la réponse
                      if (response.isEmpty) {
                        // Gérer les erreurs
                        final snackBar = SnackBar(
                          content: Text('Erreur lors de la connexion'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        // Vérifier si l'utilisateur a été trouvé
                        if ((response as List).isEmpty) {
                          // Utilisateur non trouvé
                          final snackBar = SnackBar(
                            content: Text('Nom d\'utilisateur ou mot de passe incorrect'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          // Utilisateur trouvé
                          final snackBar = SnackBar(
                            content: Text('Connexion réussie'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home(supabase: supabase)),
                          );
                        }
                      }
                    },
                    child: const Text('Connexion'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Inscription(supabase: supabase)),
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
