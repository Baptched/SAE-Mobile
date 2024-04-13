import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget/AnnonceWidget.dart';
import '../database/supabase/annonceDB.dart';
import '../models/annonce.dart';

class AnnoncesFavoritesPage extends StatefulWidget {
  @override
  _AnnoncesFavoritesPageState createState() => _AnnoncesFavoritesPageState();
}

class _AnnoncesFavoritesPageState extends State<AnnoncesFavoritesPage> {
  late Future<List<Annonce>> _annoncesFavoritesFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _loadAnnoncesFavorites();
  }

  Future<void> _loadAnnoncesFavorites() async {
    final pseudo = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('pseudoUtilConnecte');
    });
    setState(() {
      _annoncesFavoritesFuture = AnnonceDB.getAnnoncesFavorisByPseudoUtil(pseudo!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Annonces favorites'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Text(
                  'Annonces favorites',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Divider(thickness: 4),
                SizedBox(height: 35),
                Divider(thickness: 4),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Annonce>>(
              future: _annoncesFavoritesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Annonce annonce = snapshot.data![index];
                      return AnnonceWidget(annonce: annonce);
                    },
                  );
                } else {
                  return Center(
                    child: Text('Aucune annonce favorite trouvée.'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
