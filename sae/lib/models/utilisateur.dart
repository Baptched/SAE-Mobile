import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:convert/convert.dart';

class Utilisateur {
  final int id;
  final String prenom;
  final String nom;
  final String pseudo;
  final String motDePasse;
  final Uint8List? imageProfilBytes;

  Utilisateur({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.pseudo,
    required this.motDePasse,
    this.imageProfilBytes,
  });

  static Utilisateur fromJson(Map<String, dynamic> json) {
    // convert base 64 string to bytes
    Uint8List? tableauBits;
    // print the type of json['imageprofil']
    print(json['imageprofil'].runtimeType);
    if (json['imageprofil'] != null) {
      String hex = json['imageprofil'];
      String hexStr = hex.replaceAll('\\x', '');
      List<int> bytes = [];
      for (int i = 0; i < hexStr.length; i += 2) {
        String byteString = hexStr.substring(i, i + 2);
        bytes.add(int.parse(byteString, radix: 16));
      }
      tableauBits = Uint8List.fromList(bytes);
    }

    return Utilisateur(
      id: json['idu'],
      prenom: json['prenomu'],
      nom: json['nomu'],
      pseudo: json['pseudo'],
      motDePasse: json['motdepasse'],
      imageProfilBytes: tableauBits,
    );
  }

  @override
  String toString() {
    return 'Utilisateur{id: $id, prenom: $prenom, nom: $nom, pseudo: $pseudo, motDePasse: $motDePasse, imageProfilBytes: $imageProfilBytes}';
  }

}
