import 'package:flutter/material.dart';
import 'package:sae/UI/ajout_produit.dart';
import 'package:sae/database/sqflite/database.dart';
import 'package:sae/models/produit.dart';
import 'package:sqflite/sqflite.dart';

class WidgetProduits extends StatefulWidget {

  @override
  _WidgetProduitsState createState() => _WidgetProduitsState();
}

class _WidgetProduitsState extends State<WidgetProduits> {
  List<Produit>? _produits;

  Future<void> _chargerProduits() async {
    final produits = await _getProduits();
    setState(() {
      _produits = produits;
    });
  }

  Future<List<Produit>> _getProduits() async {
    // Get a reference to the database.
    DatabaseHelper helper = DatabaseHelper();
    final Database db = await helper.database;

    // Query the table for all the products.
    final List<Map<String, dynamic>> maps = await db.query('produit');

    // Convert the List<Map<String, dynamic>> into a List<Produit>.
    return List.generate(maps.length, (i) {
      return Produit(
        id: maps[i]['idP'],
        label: maps[i]['labelP'],
        condition: maps[i]['conditionP'],
        disponible: maps[i]['disponible'],
        lienImageProduit: maps[i]['lienImageProduit'],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _chargerProduits();
  }

  @override
  Widget build(BuildContext context) {

    if (_produits == null) {
      return const Center(child: CircularProgressIndicator());
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Liste des produits'),
        ),
        body: _produits!.isEmpty
            ? const Center(
          child: Text('Vous n\'avez actuellement pas d\'objets enregistrés'),
        )
            : ListView.builder(
          itemCount: _produits!.length,
          itemBuilder: (context, index) {
            final produit = _produits![index];
            return ListTile(
              title: Text(produit.label),
              subtitle: Text(produit.condition),
              // Add more information to display if needed
              leading: CircleAvatar(
                backgroundImage:
                AssetImage(produit.lienImageProduit),
              ),
              // Handle tapping on product if needed
              onTap: () {
                // Add your logic to handle tapping on a product
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PageAjoutProduit()));
          },
          child: Icon(Icons.add),
        ),
      );
    }
  }
}
