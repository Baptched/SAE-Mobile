import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sae/database/sqflite/db_models/ProduitDB.dart';

import '../models/produit.dart';
import 'home.dart';

class WidgetAjoutAnnonce extends StatefulWidget {

  @override
  _WidgetAjoutAnnonceState createState() => _WidgetAjoutAnnonceState();

}

class _WidgetAjoutAnnonceState extends State<WidgetAjoutAnnonce> {

  List<Produit>? _produits;
  Produit? _selectedProduit;

  Future<void> _chargerProduits() async {
    await ProduitDB.getProduitsDisponibles().then((value) =>
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
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Titre de l\'annonce',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description de l\'annonce',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Durée maximale de réservation (en jours)',
              ),
            ),
            SizedBox(height: 90.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                // rien pour l'instant
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