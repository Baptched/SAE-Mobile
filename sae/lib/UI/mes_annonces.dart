import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sae/database/sqflite/db_models/AnnonceDB.dart';

import '../models/annonce.dart';

class WidgetAnnonces extends StatefulWidget {
  @override
  _WidgetAnnoncesState createState() => _WidgetAnnoncesState();
}

class _WidgetAnnoncesState extends State<WidgetAnnonces> {
  List<Annonce>? _annonces;

  Future<void> _chargerAnnonces() async {
    await AnnonceDB.getAnnonces().then((value) => setState(() {
      _annonces = value;
    }));
  }

  @override
  void initState() {
    super.initState();
    _initialiser();
  }

  void _initialiser() async {
    await _chargerAnnonces();
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
                  return ListTile(
                    title: Text(annonce.titre),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(annonce.description),
                        Text('Durée maximale de réservation: ${annonce.dureeReservationMax} jours'),
                      ],
                    ),
                    leading: CircleAvatar(
                      // Vous pouvez afficher l'image de l'objet associé à l'annonce ici
                      backgroundImage: AssetImage('assets/product_img_default_produit_image.png'),
                    ),
                    trailing: Row(
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
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
