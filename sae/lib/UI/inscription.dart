import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

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
                  final responsePseudo = await supabase
                      .from('utilisateur')
                      .select()
                      .eq('pseudo', pseudo);

                  if (responsePseudo.isNotEmpty) {
                    final snackBar = SnackBar(
                      content: Text('Pseudo déjà utilisé'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  // Insérer l'utilisateur dans la base de données
                  final response = await supabase.from('utilisateur').insert({
                    'prenomu': prenom,
                    'nomu': nom,
                    'pseudo': pseudo,
                    'motdepasse': motDePasse,
                  });

                  // Retour à la page de connexion
                  Navigator.pop(context);

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
