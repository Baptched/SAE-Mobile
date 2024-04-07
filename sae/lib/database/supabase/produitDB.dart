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

class ProduitDB {
  static Future<List<Produit>> getProduits() async {
    final data = await MyApp.client.from('produit').select();
    List<Produit> produits = [];
    for (var d in data) {
      produits.add(Produit.fromJson(d));
    }
    return produits;
  }

  static Future<List<Produit>> getProduitsByUtilisateur(
      int idUtilisateur) async {
    final data =
        await MyApp.client.from('produit').select().eq('idu', idUtilisateur);
    List<Produit> produits = [];
    for (var d in data) {
      produits.add(Produit.fromJson(d));
    }
    return produits;
  }

  static Future<Produit?> getProduitByAttributs(Produit produit) async {
    final data = await MyApp.client
        .from('produit')
        .select()
        .eq('labelp', produit.label)
        .eq('conditionp', produit.condition)
        .eq('disponible', produit.disponible)
        .eq('idu', produit.idUtilisateur as int);
    if (data.isEmpty) {
      return null;
    }
    return Produit.fromJson(data[0]);
  }

  // get id Produit by attributs
  static Future<int?> getIdProduitByAttributs(Produit produit) async {
    final data = await MyApp.client
        .from('produit')
        .select('idp')
        .eq('labelp', produit.label)
        .eq('conditionp', produit.condition)
        .eq('disponible', produit.disponible)
        .eq('idu', produit.idUtilisateur as int);
    if (data.isEmpty) {
      return null;
    }
    return data[0]['idp'] as int;
  }

  /// renvoie l'id du produit créé
  static Future<int> insererProduit(Produit produit) async {
    File imageFile =
        File(Home.lienDossierImagesLocal + "/" + produit!.lienImageProduit);
    // Transforme l'image en Uint8List
    Uint8List imageByte = await imageFile.readAsBytes();

    // Encode l'image en hexadécimal
    String hexEncoded = hex.encode(imageByte);

    final response = await MyApp.client.from('produit').insert([
      {
        'labelp': produit.label,
        'conditionp': produit.condition,
        'disponible': produit.disponible,
        'idu': produit.idUtilisateur,
        'imageproduit': '\\x$hexEncoded',
      }
    ]);

    int? idP = await ProduitDB.getIdProduitByAttributs(produit);
    if (idP == null) {
      return -1;
    }
    return idP;
  }

  static Future<void> deleteProduitById(int id) async {
    await MyApp.client.from('produit').delete().eq('idp', id);
  }

  static Future<void> deleteProduitByAttributs(Produit produit) async {
    await MyApp.client
        .from('produit')
        .delete()
        .eq('labelp', produit.label)
        .eq('conditionp', produit.condition)
        .eq('disponible', produit.disponible)
        .eq('idu', produit.idUtilisateur as int);
  }

  static Future<void> updateProduit(Produit produit) async {
    await MyApp.client.from('produit').update({
      'labelp': produit.label,
      'conditionp': produit.condition,
      'disponible': produit.disponible,
      'idu': produit.idUtilisateur,
    }).eq('idp', produit.id as int);
  }

  static Future<Produit?> getProduitById(int id) async {
    final data = await MyApp.client.from('produit').select().eq('idp', id);
    if (data.isEmpty) {
      return null;
    }
    return Produit.fromJson(data[0]);
  }
}
