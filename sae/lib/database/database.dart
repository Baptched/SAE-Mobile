import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'produits.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE produit (
        idP INTEGER PRIMARY KEY AUTOINCREMENT,
        labelP TEXT,
        conditionP TEXT,
        disponible INTEGER,
        lienImageProduit TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categorie (
        idCat INTEGER PRIMARY KEY AUTOINCREMENT,
        nomCat TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE annonce (
        idA INTEGER PRIMARY KEY AUTOINCREMENT,
        titreA TEXT,
        dureeReservation INTEGER,
        etatA TEXT,
        enLigne INTEGER,
        idP INTEGER,
        FOREIGN KEY (idP) REFERENCES produit(idP)
      )
    ''');

    await db.execute('''
      CREATE TABLE appartenir_a (
        idA INTEGER,
        idCat INTEGER,
        FOREIGN KEY (idA) REFERENCES annonce(idA),
        FOREIGN KEY (idCat) REFERENCES categorie(idCat),
        PRIMARY KEY (idA, idCat)
      )
    ''');

    await db.execute('''
      CREATE TABLE etre (
        idP INTEGER,
        idCat INTEGER,
        FOREIGN KEY (idP) REFERENCES produit(idP),
        FOREIGN KEY (idCat) REFERENCES categorie(idCat),
        PRIMARY KEY (idP, idCat)
      )
    ''');
  }

  Future<int> insererProduit(String label, String condition, int disponible, String lienImageProduit) async {
    Database db = await database;
    return await db.insert('produit', {
      'labelP': label,
      'conditionP': condition,
      'disponible': disponible,
      'lienImageProduit': lienImageProduit,
    });
  }

  Future<List<Map<String, dynamic>>> getProduits() async {
    Database db = await database;
    return await db.query('produit');
  }

  Future<void> deleteAllProduits() async {
    Database db = await database;
    await db.delete('produit');
  }
}
