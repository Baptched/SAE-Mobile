import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sae/UI/home.dart';
import 'package:sae/database/sqflite/db_models/AnnonceDB.dart';
import 'package:sae/database/sqflite/db_models/ProduitDB.dart';
import 'package:sae/main.dart';

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
    await AnnonceDB.getAnnonces().then((value) => setState(() {
      _annonces = value;
    }));
  }

  Future<void> _chargerProduits() async {
    await ProduitDB.getProduits().then((value) => setState(() {
      _produits = value;
    }));
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
    // Mettre à jour l'état de l'annonce dans la base de données ou effectuer toute autre opération nécessaire
    // Ici, vous pouvez appeler votre méthode pour mettre à jour l'état de l'annonce
    // par exemple : await AnnonceDB.publierAnnonce(annonce.id, publier);
    if (publier){
      //TODO : penser aux SEtState
    }
    else{
      //TODO: on enlève l'annonce  de la base en ligne
    }
  }

  Future<void> _supprimerAnnonce(Annonce annonce) async {

    //TODO: supprimer en ligne si elle l'est et en local
    if (annonce.enLigne == 1){
      await AnnonceDB.deleteAnnonce(annonce.id as int);
      MyApp.client.from('annonce').delete()
          .eq('titrea', annonce.titre)
          .eq('descriptiona', annonce.description)
          .eq('dureereservation', annonce.dureeReservationMax);
    }
    else {
      await AnnonceDB.deleteAnnonce(annonce.id as int);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des annonces'),
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
                child: Text('Aucune annonce disponible.'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: _annonces!.length,
                itemBuilder: (context, index) {
                  final annonce = _annonces![index];
                  // Récupérer le produit associé à l'annonce
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
                            offset:
                            Offset(0, 2), // changes position of shadow
                          ),
                        ],
                  ),
                  child: ListTile(
                    title: Text(annonce.titre, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(annonce.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        Text('Durée maximale de réservation: ${annonce.dureeReservationMax} jours', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    leading: CircleAvatar(
                      // Vous pouvez afficher l'image de l'objet associé à l'annonce ici
                      backgroundImage: image,
                    ),
                    trailing:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              annonce.enLigne == 1 ? Icons.check_circle : Icons.cancel,
                              color: annonce.enLigne ==1  ? Colors.green : Colors.red,
                            ),
                            SizedBox(width: 4),
                            Text(
                              annonce.enLigne == 1 ? 'Publiée' : 'Non publiée',
                              style: TextStyle(
                                color: annonce.enLigne ==1 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("Etat : ${annonce.etat}", style: TextStyle(fontSize: 8)),
                        SizedBox(height: 32),
                        // icon delete to delete
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _supprimerAnnonce(annonce);
                          },
                        ),
                      ]
                    )

                  ));
                },
              ),
          ],
        ),
      ),
    );
  }
}
