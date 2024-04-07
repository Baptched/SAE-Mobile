import 'package:sae/main.dart';
import 'package:sae/models/annonce.dart';

class AnnonceDB {

  static Future<List<Annonce>> getAllAnnoncesDifferentFromUser(pseudo) async {
    final data = await MyApp.client
        .from('annonce')
        .select();
    List<Annonce> annonces = [];
    for (var d in data) {
      print(d);
      annonces.add(Annonce.fromJsonSupabase(d));
    }
    return annonces;
  }

  static Future<List<Annonce>> getAnnonces() async {
    final data = await MyApp.client
        .from('annonce')
        .select();
    List<Annonce> annonces = [];
    print(data) ;
    for (var d in data) {
      annonces.add(Annonce.fromJsonSupabase(d));
    }
    return annonces;
  }

  // get annonce by attributs
  static Future<Annonce?> getAnnonceByAttributs(Annonce annonce) async {
    final data = await MyApp.client
        .from('annonce')
        .select()
        .eq('titrea', annonce.titre)
        .eq('descriptiona', annonce.description)
        .eq('dureereservation', annonce.dureeReservationMax);
    if (data.isEmpty) {
      return null;
    }
    return Annonce.fromJsonSupabase(data[0]);
  }

  /// get id annonce by attributs
  static Future<int?> getIdAnnonceByAttributs(Annonce annonce) async {
    final data = await MyApp.client
        .from('annonce')
        .select('ida')
        .eq('titrea', annonce.titre)
        .eq('descriptiona', annonce.description)
        .eq('dureereservation', annonce.dureeReservationMax);
    if (data.isEmpty) {
      return null;
    }
    return data[0]['ida'] as int;
  }



  /// L'id du produit associé à l'annonce est passé en paramètre
  /// Il faut le passer car par défaut le modèle à l'id du produit de la base locale
  /// or ici nous avons besoin de l'id du produit de la base distante
  static Future<int> insererAnnonce(Annonce annonce, int idProduitSupabase) async
  {
    final response = await MyApp.client
        .from('annonce')
        .insert([{
      'titrea': annonce.titre,
      'descriptiona': annonce.description,
      'dureereservation': annonce.dureeReservationMax,
      'etata': annonce.etat,
      'idp': idProduitSupabase,

    }
    ]);

    int? idA = await AnnonceDB.getIdAnnonceByAttributs(annonce);
    if (idA == null) {
      return -1;
    }
    print("id A :${idA}");
    return idA;
  }

  static Future<void> deleteAnnonceById(int id) async {
    await MyApp.client
        .from('annonce')
        .delete()
        .eq('ida', id);
  }

  static Future<void> deleteAnnonceByIdProduit(int id) async {
    await MyApp.client
        .from('annonce')
        .delete()
        .eq('idp', id);
  }

  static Future<void> deleteAnnonceByAttributs(Annonce annonce) async {
    await MyApp.client
        .from('annonce')
        .delete()
        .eq('titrea', annonce.titre)
        .eq('descriptiona', annonce.description)
        .eq('dureereservation', annonce.dureeReservationMax)
        .eq('idp', annonce.idProduit);
  }
}