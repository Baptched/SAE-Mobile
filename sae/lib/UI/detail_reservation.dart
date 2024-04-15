import 'package:flutter/material.dart';
import 'package:sae/models/annonce.dart';
import 'package:sae/models/produit.dart';
import 'package:sae/models/reservation.dart';
import 'package:sae/models/utilisateur.dart';
import '../Widget/AjoutAvis.dart';
import '../database/supabase/utilisateurDB.dart';
import 'package:sae/database/supabase/reservationBD.dart';

class ReservationDetailPage extends StatefulWidget {
  final Reservation reservation;
  final Annonce annonce;
  final Produit produit;

  ReservationDetailPage({
    required this.reservation,
    required this.annonce,
    required this.produit,
  });

  @override
  _ReservationDetailPageState createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage> {
  bool isReservationPassed = false;

  @override
  void initState() {
    super.initState();
    isReservationPassed = DateTime.now().isAfter(widget.reservation.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la réservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Produit: ${widget.produit.label}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (widget.produit.imageUint8List != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(
                          widget.produit.imageUint8List!,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 200.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4,
              child: ListTile(
                title: Text(
                  'Date début: ${widget.reservation.startDate}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            Card(
              elevation: 4,
              child: ListTile(
                title: Text(
                  'Date fin: ${widget.reservation.endDate}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            if (!widget.reservation.isEvaluated && isReservationPassed)
              Card(
                elevation: 4,
                child: ListTile(
                  title: Text(
                    'Ajouter un avis',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () async {
                    Utilisateur? utilisateur = await UtilisateurDB.getUtilisateurById(widget.produit.idUtilisateur ?? 0);
                    // Afficher la boîte de dialogue pour ajouter un avis
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: utilisateur != null
                              ? AjouterAvisWidget(
                            pseudoUtilisateur: utilisateur.pseudo,
                            idUtilisateur: utilisateur.id,
                          )
                              : Text('Utilisateur introuvable.'),
                        );

                      },
                    );
                    ReservationBD.isEvaluated(widget.reservation.id) ;
                    setState(() {
                      widget.reservation.isEvaluated = true;
                    });

                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
