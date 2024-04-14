import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sae/main.dart';
import 'package:sae/models/produit.dart';
import 'dart:io';
import '../../UI/home.dart';

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

  static Future<List<int>> getReservationsByUtilisateur(int idUtilisateur) async {
    final data = await MyApp.client.from('reservation').select().eq('idu', idUtilisateur);
    List<int> lesAnnoncesId = [];
    for (var d in data) {
      lesAnnoncesId.add(d['ida'] as int);
    }
    return lesAnnoncesId;
  }
}