import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sae/UI/home.dart';
import 'package:sae/database/sqflite/db_models/AnnonceDB.dart' as sqflite;
import 'package:sae/database/sqflite/db_models/ProduitDB.dart' as sqflite;

import 'package:sae/database/supabase/annonceDB.dart' as supabase;
import 'package:sae/database/supabase/produitDB.dart' as supabase;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/annonce.dart';
import '../models/produit.dart';

class WidgetAnnonces extends StatefulWidget {
  @override
  _WidgetAnnoncesState createState() => _WidgetAnnoncesState();
}

class _WidgetAnnoncesState extends State<WidgetAnnonces> {
  List<Annonce>? _annonces;
  List<Produit>? _produits;

  Future<void> _chargerAnnonces() async {
    await sqflite.AnnonceDB.getAnnonces().then((value) => setState(() {
      _annonces = value;
    }));
  }

  Future<void> _chargerProduits() async {
    await sqflite.ProduitDB.getProduits().then((value) => setState(() {
      _produits = value;
    }));
  }

  void _confirmerSuppressionAnnonce(Annonce annonce) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer cette annonce ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () {
                Navigator.of(context).pop();
                _supprimerAnnonce(annonce);
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _afficherConfirmationPublication(Annonce annonce) async {
    final String action = annonce.enLigne == 1 ? 'Enlever la publication en ligne' : 'Publier l\'annonce en ligne';
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Voulez-vous $action ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(action),
              onPressed: () {
                Navigator.of(context).pop();
                _publierAnnonce(annonce, annonce.enLigne != 1); // Si en ligne, retire la publication ; sinon, publie l'annonce
              },
            ),
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _publierAnnonce(Annonce annonce, bool publier) async {
    if (publier){
      Produit p = _produits!.firstWhere((element) => element.id == annonce.idProduit);
      p.idUtilisateur = await SharedPreferences.getInstance()
          .then((value) => value.getInt('idUtilConnecte'));

      print("_produits" + p.toString());


      supabase.ProduitDB.insererProduit(p).then((value) => supabase.AnnonceDB.insererAnnonce(annonce, value));
      annonce.enLigne = 1;
      await sqflite.AnnonceDB.updateAnnonce(annonce);

    }
    else{
      //TODO: supprimer ses réservations avant
      Annonce? annonceEnLigne = await supabase.AnnonceDB.getAnnonceByAttributs(annonce);

      supabase.ProduitDB.deleteProduitById(annonceEnLigne!.idProduit);
      supabase.AnnonceDB.deleteAnnonceById(annonceEnLigne.id as int);
    }
    setState(() {
      annonce.enLigne = publier ? 1 : 0;
    });
    await sqflite.AnnonceDB.updateAnnonce(annonce);
  }

  Future<void> _supprimerAnnonce(Annonce annonce) async {
    if (annonce.enLigne == 1){

      Annonce? a = await supabase.AnnonceDB.getAnnonceByAttributs(annonce);
      await supabase.AnnonceDB.deleteAnnonceByAttributs(annonce);
      await supabase.ProduitDB.deleteProduitById(a!.idProduit);
      await sqflite.AnnonceDB.deleteAnnonce(annonce.id as int);
    }
    else {
      await sqflite.AnnonceDB.deleteAnnonce(annonce.id as int);
    }
    setState(() {
      _annonces!.remove(annonce);
    });
  }

  @override
  void initState() {
    super.initState();
      _initialiser();
  }

  @override
  void didUpdateWidget(covariant WidgetAnnonces oldWidget) {
    super.didUpdateWidget(oldWidget);
    _chargerAnnonces();
    _chargerProduits();
  }

  void _initialiser() async {
    await _chargerAnnonces();
    await _chargerProduits();
  }

  @override
  Widget build(BuildContext context) {

    late int longueur;
    if (_annonces == null || _produits == null) {
      return const Center(child: CircularProgressIndicator());
    }
    else {
      longueur = (_annonces as List<Annonce>).length;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de vos annonces'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_annonces == null)
              Center(child: CircularProgressIndicator())
            else if (_annonces!.isEmpty)
              Center(
                child: Text('Vous n\'avez aucune annonce enregistrée.'),
              )
            else
              SizedBox(height: 8.0),
            Center(
              // text en italique
              child: Text(
                  'Cliquez sur une annonce pour la publier en ligne ou supprimer sa publication',
                  style: TextStyle(
                    fontStyle: FontStyle.italic, fontSize: 8,
                  )),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: longueur,
              itemBuilder: (context, index) {
                final annonce = _annonces![index];
                final Produit? produit = _produits?.firstWhere((element) => element.id == annonce.idProduit);

                late ImageProvider image;
                try {
                  image = FileImage(File(Home.lienDossierImagesLocal+"/"+produit!.lienImageProduit));
                } catch (e) {
                  image = AssetImage('assets/product_img/default_produit_image.png');
                }
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
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _afficherConfirmationPublication(annonce);
                          },
                          child: ListTile(
                            title: Text(
                              annonce.titre,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Text(
                                  annonce.description,
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(height: 40),
                                Text(
                                  'Durée maximale de réservation: ${annonce.dureeReservationMax} jours',
                                  style: TextStyle(fontSize: 8),
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage: image,
                            ),
                            trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        annonce.enLigne == 1 ? Icons.check_circle : Icons.cancel,
                                        color: annonce.enLigne ==1  ? Colors.green : Colors.red, size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        annonce.enLigne == 1 ? 'Publiée' : 'Non publiée',
                                        style: TextStyle(
                                          color: annonce.enLigne ==1 ? Colors.green : Colors.red,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Etat : ${annonce.etat}",
                                    style: TextStyle(fontSize: 8),
                                  ),
                                ]
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, size: 16, color: Colors.red),
                        onPressed: () {
                          _confirmerSuppressionAnnonce(annonce);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
