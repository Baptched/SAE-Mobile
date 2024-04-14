import 'package:flutter/material.dart';
import 'package:sae/models/annonce.dart';
import 'package:sae/models/produit.dart';
import 'package:sae/models/reservation.dart';
import 'package:sae/database/supabase/evaluationBD.dart';

class ReservationDetailPage extends StatelessWidget {
  final Reservation reservation;
  final Annonce annonce;
  final Produit produit;

  ReservationDetailPage({
    required this.reservation,
    required this.annonce,
    required this.produit,
  });

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
                      'Produit: ${produit.label}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        produit.imageUint8List!,
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
                  'Annonce: ${annonce.id}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4,
              child: ListTile(
                title: Text(
                  'Date début: ${reservation.startDate}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            Card(
              elevation: 4,
              child: ListTile(
                title: Text(
                  'Date fin: ${reservation.endDate}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            FutureBuilder<bool>(
              future: EvaluationBD().isEvaluate(reservation.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Placeholder while waiting for future result
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == true) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        'État: Évaluée',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        'État: À évaluer',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              int? _rating;
                              bool _isButtonDisabled = true; // État initial du bouton Évaluer

                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return AlertDialog(
                                    title: Text('Évaluer la réservation'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Veuillez entrer une note entre 1 et 5 :'),
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            int? rating = int.tryParse(value);
                                            if (rating != null && rating >= 1 && rating <= 5) {
                                              _rating = rating;
                                            } else {
                                              _rating = null;
                                            }

                                            // Mettre à jour l'état du bouton Évaluer en fonction de la validité de la note
                                            setState(() {
                                              _isButtonDisabled = _rating == null;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Annuler'),
                                      ),
                                      ElevatedButton(
                                        onPressed: _isButtonDisabled ? null : () {
                                          EvaluationBD.ajouterEvaluation(reservation.id, _rating!);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Évaluer'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Text('Évaluer'),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
