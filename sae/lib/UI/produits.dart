import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sae/UI/ajout_produit.dart';
import 'package:sae/database/sqflite/database.dart';
import 'package:sae/database/sqflite/db_models/ProduitDB.dart';
import 'package:sae/models/produit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sae/UI/home.dart';

class WidgetProduits extends StatefulWidget {
  @override
  _WidgetProduitsState createState() => _WidgetProduitsState();
}

class _WidgetProduitsState extends State<WidgetProduits> {
  List<Produit>? _produits;

  Future<void> _chargerProduits() async {
    await ProduitDB.getProduits().then((value) =>
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

  void refresh() {
    setState(() {
      _chargerProduits();
    });
  }

  Future<void> _initialiser() async {
    await _chargerProduits();
    List<Produit> produits = await ProduitDB.getProduits();

    print("------------------ liste  de produits ------------------");
    for (Produit produit in produits) {
      print(produit);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_produits == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Liste des produits'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: _produits!.isEmpty
              ? const Center(
                  child: Text(
                      'Vous n\'avez actuellement pas d\'objets enregistrés'),
                )
              : ListView.builder(
                  itemCount: _produits!.length,
                  itemBuilder: (context, index) {
                    final produit = _produits![index];
                    Widget trailingWidget = produit.disponible == 1
                        ? const Text('Disponible',
                            style: TextStyle(color: Colors.green))
                        : const Text('Réservé',
                            style: TextStyle(color: Colors.red));

                    if (produit.lienImageProduit ==
                        'default_produit_image.png') {
                      AssetImage image = AssetImage(
                          'assets/product_img/default_produit_image.png');
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(
                            produit.label,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          subtitle: Text(
                            produit.condition,
                            style: TextStyle(fontSize: 14.0),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: image,
                            radius: 30,
                          ),
                          trailing: trailingWidget,
                          onTap: () {
                            // Ajoutez ici la logique pour gérer le tap sur un produit
                          },
                        ),
                      );
                    } else {
                      FileImage image = FileImage(File(
                          Home.lienDossierImagesLocal +
                              "/" +
                              produit.lienImageProduit));
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(
                            produit.label,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          subtitle: Text(
                            produit.condition,
                            style: TextStyle(fontSize: 14.0),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: image,
                            radius: 30,
                          ),
                          trailing: trailingWidget,
                          onTap: () {
                            // Ajoutez ici la logique pour gérer le tap sur un produit
                          },
                        ),
                      );
                    }
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageAjoutProduit(refresh: refresh)));
          },
          child: Icon(Icons.add),
        ),
      );
    }
  }
}
