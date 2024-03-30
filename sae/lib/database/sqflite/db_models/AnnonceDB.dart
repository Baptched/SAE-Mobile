import 'package:sae/database/sqflite/database.dart';
import 'package:sae/models/annonce.dart';
import 'package:sqflite/sqflite.dart';

class AnnonceDB {

  final DatabaseHelper databaseHelper = DatabaseHelper();

  static Future<Annonce> getAnnonceById (int idA) async {
    final Database db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('annonce', where: 'idA = ?', whereArgs: [idA]);
    return Annonce(
      id: maps[0]['idA'],
      titre: maps[0]['titreA'],
      description: maps[0]['descriptionA'],
      dureeReservationMax: maps[0]['dureeReservation'],
      etat: maps[0]['etatA'],
      enLigne: maps[0]['enLigne'],
      idProduit: maps[0]['idP'],
    );
  }

  static Future<List<Annonce>> getAnnonces() async {
    final Database db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('annonce');
    return List.generate(maps.length, (i) {
      return Annonce(
        id: maps[i]['idA'],
        titre: maps[i]['titreA'],
        description: maps[i]['descriptionA'],
        dureeReservationMax: maps[i]['dureeReservation'],
        etat: maps[i]['etatA'],
        enLigne: maps[i]['enLigne'],
        idProduit: maps[i]['idP'],
      );
    });
  }

  static Future<List<Annonce>> getAnnoncesEnLigne() async {
    final Database db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('annonce', where: 'enLigne = ?', whereArgs: [1]);
    return List.generate(maps.length, (i) {
      return Annonce(
        id: maps[i]['idA'],
        titre: maps[i]['titreA'],
        description: maps[i]['descriptionA'],
        dureeReservationMax: maps[i]['dureeReservation'],
        etat: maps[i]['etatA'],
        enLigne: maps[i]['enLigne'],
        idProduit: maps[i]['idP'],
      );
    });
  }

  static Future<Annonce> insererAnnonce(Annonce annonce) async {
    final Database db = await DatabaseHelper().database;
    annonce.id = await db.insert('annonce', {
      'titreA': annonce.titre,
      'descriptionA': annonce.description,
      'dureeReservation': annonce.dureeReservationMax,
      'etatA': annonce.etat,
      'enLigne': annonce.enLigne,
      'idP': annonce.idProduit,
    });
    return annonce;
  }

  static Future<Annonce> updateAnnonce(Annonce annonce) async {
    final Database db = await DatabaseHelper().database;
    annonce.id = await db.update('annonce', {
      'titreA': annonce.titre,
      'descriptionA': annonce.description,
      'dureeReservation': annonce.dureeReservationMax,
      'etatA': annonce.etat,
      'enLigne': annonce.enLigne,
      'idP': annonce.idProduit,
    }, where: 'idA = ?', whereArgs: [annonce.id]);
    return annonce;
  }

  static Future<void> deleteAnnonce(int idA) async {
    final Database db = await DatabaseHelper().database;
    await db.delete('annonce', where: 'idA = ?', whereArgs: [idA]);
  }

  static Future<void> deleteAllAnnonces() async {
    final Database db = await DatabaseHelper().database;
    await db.delete('annonce');
  }


}