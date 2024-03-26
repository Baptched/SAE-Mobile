import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Utilisateur {
  final int id;
  final String prenom;
  final String nom;
  final String pseudo;
  final String motDePasse;
  final List<int>? imageProfilBytes;

  Utilisateur({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.pseudo,
    required this.motDePasse,
    this.imageProfilBytes,
  });

  static fromJson(Map<String, dynamic> json) {
    if (json['imageprofil'] == null) {
      return Utilisateur(
        id: json['idu'],
        prenom: json['prenomu'],
        nom: json['nomu'],
        pseudo: json['pseudo'],
        motDePasse: json['motdepasse'],
      );
    }
    List<int> bytes = List<int>.from(json['imageprofil']);
    return Utilisateur(
      id: json['idu'],
      prenom: json['prenomu'],
      nom: json['nomu'],
      pseudo: json['pseudo'],
      motDePasse: json['motdepasse'],
      imageProfilBytes: bytes,
    );
  }
}
