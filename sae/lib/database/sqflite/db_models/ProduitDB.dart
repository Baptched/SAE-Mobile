import 'package:sae/database/sqflite/database.dart';
import 'package:sae/models/produit.dart';
import 'package:sqflite/sqflite.dart';

class ProduitDB {

  final DatabaseHelper databaseHelper = DatabaseHelper();

  static Future<Produit> getProduitById(int id) async {
    final Database db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('produit', where: 'idP = ?', whereArgs: [id]);
    return Produit(
      id: maps[0]['idP'],
      label: maps[0]['labelP'],
      condition: maps[0]['conditionP'],
      disponible: maps[0]['disponible'],
      lienImageProduit: maps[0]['lienImageProduit'],
    );
  }

  static Future<List<Produit>> getProduits() async {
    final Database db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('produit');
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

  static Future<Produit> insererProduit(Produit produit) async {
    final Database db = await DatabaseHelper().database;
    produit.id = await db.insert('produit', {
      'labelP': produit.label,
      'conditionP': produit.condition,
      'disponible': produit.disponible,
      'lienImageProduit': produit.lienImageProduit,
    });
    return produit;
  }

  static Future<Produit> updateProduit(Produit produit) async {
    final Database db = await DatabaseHelper().database;
    produit.id = await db.update('produit', {
      'labelP': produit.label,
      'conditionP': produit.condition,
      'disponible': produit.disponible,
      'lienImageProduit': produit.lienImageProduit,
    }, where: 'idP = ?', whereArgs: [produit.id]);
    return produit;
  }

  static Future<void> deleteProduitById(int id) async {
    final Database db = await DatabaseHelper().database;
    await db.delete('produit', where: 'idP = ?', whereArgs: [id]);
  }

  static Future<void> deleteAllProduits() async {
    final Database db = await DatabaseHelper().database;
    await db.delete('produit');
  }
}
