import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sae/UI/annonce.dart';
import 'package:sae/database/sqflite/db_models/ProduitDB.dart';

import '../database/sqflite/db_models/AnnonceDB.dart';
import '../models/annonce.dart';
import '../models/produit.dart';
import 'home.dart';

class WidgetAjoutAnnonce extends StatefulWidget {

  @override
  _WidgetAjoutAnnonceState createState() => _WidgetAjoutAnnonceState();

}

class _WidgetAjoutAnnonceState extends State<WidgetAjoutAnnonce> {

  List<Produit>? _produits;
  Produit? _selectedProduit;

  TextEditingController _titreAnnonceController = TextEditingController();
  TextEditingController _descriptionAnnonceController = TextEditingController();
  TextEditingController _dureeReservationController = TextEditingController();

  Future<void> _chargerProduits() async {
    await ProduitDB.getProduitsNonAnnonces().then((value) =>
        setState(() {
          _produits = value;
        })
    );
  }

  @override
  void initState() {
    super.initState();
    _initialiser();
  }

  void _initialiser() async {
    await _chargerProduits();
  }

  Future<void> _ajouterAnnonce() async {
    if (_selectedProduit == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez sélectionner un produit.'),
      ));
      return;
    }
    if (_titreAnnonceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez saisir un titre pour l\'annonce.'),
      ));
      return;
    }
    if (_dureeReservationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez saisir une durée maximale de réservation.'),
      ));
      return;
    }
    if (_dureeReservationController.text == "0") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('La durée maximale de réservation doit être supérieure à 0.'),
      ));
      return;
    }

    Annonce annonce = Annonce(
      id : 0,
      titre : _titreAnnonceController.text,
      description : _descriptionAnnonceController.text,
      dureeReservationMax : int.parse(_dureeReservationController.text),
      etat: "Non réservée",
      enLigne: 0,
      idProduit : _selectedProduit!.id as int,
    );

    await AnnonceDB.insererAnnonce(annonce);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une annonce'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Produit>(
              value: _selectedProduit,
              items: _produits?.map((produit) {
                return DropdownMenuItem<Produit>(
                  value: produit,
                  child: Text(produit.label+ " - " + produit.condition),
                );
              }).toList(),
              hint: Text('Sélectionner un produit'),
              onChanged: (produit) {
                setState(() {
                  _selectedProduit = produit;
                });
              },
            ),
            SizedBox(height: 16.0),
            if (_selectedProduit != null)
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(Home.lienDossierImagesLocal + "/" + _selectedProduit!.lienImageProduit)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 32.0),
            TextFormField(
              controller: _titreAnnonceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Titre de l\'annonce',
              ),
            ),
            SizedBox(height: 32.0),
            TextFormField(
              controller: _descriptionAnnonceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description de l\'annonce',
              ),
            ),
            SizedBox(height: 32.0),
            TextFormField(
              controller: _dureeReservationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Durée maximale de réservation (en jours)',
              ),
            ),
            SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _ajouterAnnonce().then((value) =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home(indexInitial: 4)),
                      ),
                  );
                },
                child: Text('Ajouter l\'annonce'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}