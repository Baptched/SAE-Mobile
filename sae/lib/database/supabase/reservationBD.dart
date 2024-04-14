import 'dart:async';
import 'package:sae/main.dart';
import 'package:sae/models/reservation.dart';

class ReservationBD{

  static Future<void> addReservation(
      int idAnnonce, int idUtilisateur, DateTime dateDebut, DateTime dateFin) async {
    // Formater les dates en chaînes de caractères
    String formattedStartDate = dateDebut.toIso8601String();
    String formattedEndDate = dateFin.toIso8601String();

    // Insérer la réservation avec les dates formatées dans la base de données
    await MyApp.client.from('reservation').insert([
      {
        'ida': idAnnonce,
        'idu': idUtilisateur,
        'datedebut': formattedStartDate,
        'datefin': formattedEndDate,
      }
    ]);
  }

  static Future<List<Reservation>> getReservationsByUtilisateur(int idUtilisateur) async {
    // Récupérer les réservations associées à l'utilisateur depuis la base de données
    final response = await MyApp.client
        .from('reservation')
        .select()
        .eq('idu', idUtilisateur);


    List<Reservation> reservations = [];
    for (var d in response) {
      reservations.add(Reservation.fromJson(d));
    }
    return reservations;
  }
}