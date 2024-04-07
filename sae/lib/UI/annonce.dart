import 'package:flutter/material.dart';
import 'package:sae/database/supabase/annonceDB.dart';
import 'package:sae/models/annonce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sae/Widget/AnnonceWidget.dart';

class AnnoncesPage extends StatefulWidget {
  @override
  _AnnoncesPageState createState() => _AnnoncesPageState();
}

class _AnnoncesPageState extends State<AnnoncesPage> {
  late Future<List<Annonce>> _annoncesFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _loadAnnonces();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAnnonces() ;
  }

  Future<void> _loadAnnonces() async {
    final pseudo = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('pseudoUtilConnecte');
    });
    setState(() {
      _annoncesFuture = AnnonceDB.getAllAnnoncesDifferentFromUser(pseudo);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_annoncesFuture == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Text(
                  'Annonces',
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
              future: _annoncesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreeeeur: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Annonce annonce = snapshot.data![index];
                      return AnnonceWidget(annonce: annonce);
                    },
                  );
                } else {
                  return Center(
                    child: Text('Aucune annonce trouvée.'),
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
