import 'package:flutter/material.dart';
import 'package:sae/database/supabase/reservationBD.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sae/main.dart';
import 'package:sae/models/reservation.dart';
import '../Widget/ReservationCardWidget.dart'; // Correction de l'import

class MesReservationsPage extends StatefulWidget {
  @override
  _MesReservationsPageState createState() => _MesReservationsPageState();
}

class _MesReservationsPageState extends State<MesReservationsPage> {
  List<Reservation> reservations = [];

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    int? idUtilisateur = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getInt('idUtilConnecte');
    });
    while (idUtilisateur == null) {
      idUtilisateur = await SharedPreferences.getInstance().then((prefs) {
        return prefs.getInt('idUtilConnecte');
      });
    }
    List<Reservation> fetchedReservations =
    await ReservationBD.getReservationsByUtilisateur(idUtilisateur);
    setState(() {
      reservations = fetchedReservations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Réservations'),
      ),
      body: Expanded(
        child: ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            return ReservationCard(reservation: reservations[index]);
          },
        ),
      ),
    );
  }
}
