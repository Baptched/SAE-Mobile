import 'package:flutter/material.dart';
import 'package:sae/models/annonce.dart';
import 'package:sae/models/reservation.dart';
import 'package:sae/database/supabase/produitDB.dart';
import 'package:sae/models/produit.dart';
import 'package:sae/database/supabase/annonceDB.dart';
import 'package:sae/UI/detail_reservation.dart';


class ReservationCard extends StatefulWidget {
  final Reservation reservation;

  ReservationCard({required this.reservation});

  @override
  _ReservationCardState createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  Annonce? annonce;
  Produit? produit;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProduit();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationDetailPage(
                      reservation: widget.reservation,
                      annonce: annonce!,
                      produit: produit!
                    ),
                  ),
                );
              },
              leading: produit != null && produit!.imageUint8List != null
                  ? Image.memory(
                      produit!.imageUint8List!,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    )
                  : Container(),
              title: Text('Produit: ${produit?.label ?? "N/A"}'),
              subtitle: Text(
                  'État: ${determineReservationStatus(widget.reservation.startDate, widget.reservation.endDate)}'),
            ),
          );
  }

  Future<void> loadProduit() async {
    annonce = await AnnonceDB.getAnnonceById(widget.reservation.idAnnonce);
    while (annonce == null) {
      await Future.delayed(const Duration(seconds: 1));
      annonce = await AnnonceDB.getAnnonceById(widget.reservation.idAnnonce);
    }
    produit = await ProduitDB.getProduitById(annonce!.idProduit);
    while (produit == null) {
      await Future.delayed(const Duration(seconds: 1));
      produit = await ProduitDB.getProduitById(annonce!.idProduit);
    }
    setState(() {
      _isLoading = false;
    });
  }

  String determineReservationStatus(DateTime startDate, DateTime endDate) {
    DateTime now = DateTime.now();
    if (endDate.isBefore(now)) {
      return 'Terminée';
    } else if (startDate.isBefore(now)) {
      return 'En cours';
    } else {
      return 'À venir';
    }
  }
}
