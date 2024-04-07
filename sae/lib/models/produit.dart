import 'dart:typed_data';

import 'package:convert/convert.dart';

class Produit {
  int? id;
  String label;
  String condition;
  int disponible;
  String lienImageProduit;
  int? idUtilisateur;
  Uint8List? imageUint8List;

  Produit({
    this.id,
    required this.label,
    required this.condition,
    required this.disponible,
    this.lienImageProduit = 'default_produit_image.png',
    this.idUtilisateur, // pour supabase, inutile pour le modèle produit local
    this.imageUint8List,
  });

  // toString
  @override
  String toString() {
    return 'Produit{id: $id, label: $label, condition: $condition, disponible: $disponible, lienImageProduit: $lienImageProduit}, idUtilisateur: $idUtilisateur';
  }

  // fromJson
  static Produit fromJson(Map<String, dynamic> json) {
    String hexDecode = json['imageproduit'].toString().substring(2);
    return Produit(
      id: json['idp'],
      label: json['labelp'],
      condition: json['conditionp'],
      disponible: json['disponible'],
      lienImageProduit: 'default_produit_image.png', // vu qu'on a pas d'images..
      idUtilisateur: json['idu'],
        imageUint8List: Uint8List.fromList(hex.decode(hexDecode))
    );
  }

}
