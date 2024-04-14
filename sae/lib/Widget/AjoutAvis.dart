import 'package:flutter/material.dart';
import 'package:sae/models/avisUtilisateur.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/supabase/avisUtilisateurDB.dart';

class AjouterAvisWidget extends StatefulWidget {
  final String pseudoUtilisateur;
  final int idUtilisateur;

  const AjouterAvisWidget({Key? key, required this.pseudoUtilisateur, required this.idUtilisateur}) : super(key: key);

  @override
  _AjouterAvisWidgetState createState() => _AjouterAvisWidgetState();
}

class _AjouterAvisWidgetState extends State<AjouterAvisWidget> {
  final _formKey = GlobalKey<FormState>();
  late int _note = 0;
  late String _commentaire = '';

  Future<void> insererAvis(int note, String commentaire) async {
    try {
      final idUtilConnecte = await SharedPreferences.getInstance().then((prefs) => prefs.getInt('idUtilConnecte'));

      await AvisUtilisateurDB.addAvisUtilisateur(
        idUtilConnecte ?? 0,
        widget.idUtilisateur,
        note,
        commentaire,
      );

      // Afficher une boîte de dialogue de confirmation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Avis ajouté'),
            content: Text('Votre avis a été ajouté avec succès.'),
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
      print('Erreur lors de l\'insertion de l\'avis: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un avis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<int>(
                value: _note,
                onChanged: (value) {
                  setState(() {
                    _note = value!;
                  });
                },
                items: List.generate(6, (index) => index)
                    .map((value) => DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                ))
                    .toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Commentaire',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                maxLines: 5,
                onChanged: (value) {
                  setState(() {
                    _commentaire = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Ajoutez votre commentaire ici',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez saisir un commentaire';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    insererAvis(_note, _commentaire);
                  }
                },
                child: Text('Ajouter l\'avis'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
