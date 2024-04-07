import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:image_picker/image_picker.dart';

class Utilisateur {
  final int id;
  final String prenom;
  final String nom;
  final String pseudo;
  final String motDePasse;
  final String? imageProfilBytes;
  final Uint8List? imageUint8List ;
  final XFile? image;

  Utilisateur({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.pseudo,
    required this.motDePasse,
    this.imageProfilBytes,
    this.imageUint8List,
    this.image
  });

  static Utilisateur fromJson(Map<String, dynamic> json) {
    String hexDecode = json['imageprofil'].toString().substring(2);
    return Utilisateur(
      // Définir les autres attributs selon les besoins
      id: json['idu'],
      prenom: json['prenomu'],
      nom: json['nomu'],
      pseudo: json['pseudo'],
      motDePasse: json['motdepasse'],
      imageProfilBytes: json['imageprofil'],
      imageUint8List: Uint8List.fromList(hex.decode(hexDecode))
    );
  }

  @override
  String toString() {
    return 'Utilisateur{id: $id, prenom: $prenom, nom: $nom, pseudo: $pseudo, motDePasse: $motDePasse, imageProfilBytes: $imageProfilBytes}';
  }

}
