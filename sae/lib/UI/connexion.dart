import 'package:flutter/material.dart';
import 'package:sae/UI/inscription.dart';

class Connexion extends StatelessWidget {
  const Connexion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                decoration: const InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
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
                    onPressed: () {
                      // Fonction de connexion ici
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
