import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:sae/main.dart';
import 'package:sae/models/utilisateur.dart';

class UtilisateurDB {
  static Future<void> insererUtilisateur(Utilisateur utilisateur) async {
    Uint8List imageByte = await utilisateur.image!.readAsBytes();
    String hexEncoded = hex.encode(imageByte);
    await MyApp.client.from('utilisateur').insert([
      {
        'nomu': utilisateur.nom,
        'prenomu': utilisateur.prenom,
        'pseudo': utilisateur.pseudo,
        'motdepasse': utilisateur.motDePasse,
        'imageprofil': '\\x$hexEncoded',
      }
    ]);
  }

  // Méthode pour récupérer un utilisateur par son pseudo
  static Future<Utilisateur?> getUtilisateurByPseudo(String pseudo) async {
    final data =
        await MyApp.client.from('utilisateur').select().eq('pseudo', pseudo);

    if (data.isEmpty) {
      return null;
    }

    return Utilisateur.fromJson(data[0]);
  }

  static Future<Utilisateur?> getUtilisateurById(int id) async {
    final data = await MyApp.client.from('utilisateur').select().eq('idu', id);
    if (data.isEmpty) {
      return null;
    }
    return Utilisateur.fromJson(data[0]);
  }

  static Future<Utilisateur?> getUtilisateurByPseudoAndMotDePasse(
      String pseudo, String motDePasse) async {
    final data = await MyApp.client
        .from('utilisateur')
        .select()
        .eq('pseudo', pseudo)
        .eq('motdepasse', motDePasse);
    if (data.isEmpty) {
      return null;
    }
    return Utilisateur.fromJson(data[0]);
  }

  static Future<List<Utilisateur>> getAllUtilisateurs() async {
    final data = await MyApp.client.from('utilisateur').select();
    List<Utilisateur> utilisateurs = [];
    for (var utilisateur in data) {
      utilisateurs.add(Utilisateur.fromJson(utilisateur));
    }
    return utilisateurs;
  }

  static Future<void> updateUtilisateur(Utilisateur utilisateur) async {
    Uint8List imageByte = await utilisateur.image!.readAsBytes();
    String hexEncoded = hex.encode(imageByte);
    final response = await MyApp.client
        .from('utilisateur')
        .update({
      'nomu': utilisateur.nom,
      'prenomu': utilisateur.prenom,
      'motdepasse': utilisateur.motDePasse,
      'imageprofil': '\\x$hexEncoded',
    })
        .eq('idu', utilisateur.id);
  }

  static Future<void> updateUtilisateurWithoutImage(Utilisateur utilisateur) async {
    final response = await MyApp.client
        .from('utilisateur')
        .update({
      'pseudo' : utilisateur.pseudo,
      'nomu': utilisateur.nom,
      'prenomu': utilisateur.prenom,
      'motdepasse': utilisateur.motDePasse,
    })
        .eq('idu', utilisateur.id);
  }

  static Future<void> deleteUtilisateurById(int id) async {
    final response =
        await MyApp.client.from('utilisateur').delete().eq('id', id);
  }

  static Future<void> deleteUtilisateurByPseudo(String pseudo) async {
    final response =
        await MyApp.client.from('utilisateur').delete().eq('pseudo', pseudo);
  }

  static Future<void> deleteAllUtilisateurs() async {
    final response = await MyApp.client.from('utilisateur').delete();
  }
}
