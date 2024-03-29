import 'package:flutter/material.dart';
import 'package:sae/database/sqflite/database.dart';
import 'annonce.dart';
import 'favorie.dart';
import 'ajout_annonce.dart';
import 'messages.dart';
import 'profil.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart'; // Importez le package path_provider pour utiliser getApplicationDocumentsDirectory()


class Home extends StatefulWidget {

  static late String lienDossierImagesLocal;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    AnnoncesPage(),
    FavorisPage(),
    WidgetAjoutAnnonce(),
    MessagesPage(),
    ProfilPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initialiser();
  }

  Future<void> _initialiser() async {
    Home.lienDossierImagesLocal = await obtenirLienDossierImagesLocal();
    print(Home.lienDossierImagesLocal);
    DatabaseHelper db = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', // Changement du label pour Annonces
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ajout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<String> obtenirLienDossierImagesLocal() async {
    final String directory = (await getApplicationDocumentsDirectory()).path;
    return p.join(directory, 'sae_mobile_product_img');
  }
}

