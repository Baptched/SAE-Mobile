import 'package:flutter/material.dart';
import 'package:sae/database/sqflite/database.dart';
import 'package:sae/models/produit.dart';
import 'package:sqflite/sqflite.dart';

class PageAjoutProduit extends StatefulWidget {
  @override
  _PageAjoutProduitState createState() => _PageAjoutProduitState();
}

class _PageAjoutProduitState extends State<PageAjoutProduit> {
  late String _label;
  late String _condition = 'Neuf';
  late bool _disponible = true; // Par défaut, le produit est disponible
  late String _lienImageProduit;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Label'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un label';
                  }
                  return null;
                },
                onSaved: (value) {
                  _label = value!;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _condition,
                onChanged: (newValue) {
                  setState(() {
                    _condition = newValue!;
                  });
                },
                items: ['Neuf', 'Bon état', 'État moyen', 'Abîmé']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Condition',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez choisir une condition';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Lien de l\'image'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un lien d\'image';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lienImageProduit = value!;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Créer et sauvegarder le produit dans la base de données
                    _ajouterProduit();
                  }
                },
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _ajouterProduit() async {
    int dispo = _disponible ? 1 : 0;
    Produit produit = Produit(
      label: _label,
      condition: _condition,
      disponible: dispo,
      lienImageProduit: _lienImageProduit,
    );

    // Insérer le produit dans la base de données
    //TODO
    Navigator.pop(context); // Revenir à la page précédente après l'ajout du produit
  }
}
