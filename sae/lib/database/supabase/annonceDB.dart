import 'package:sae/main.dart';
import 'package:sae/models/annonce.dart';

class AnnonceDB {

  static Future<List<Annonce>> getAllAnnoncesDifferentFromUser(pseudo) async {
    final data = await MyApp.client
        .from('annonce')
        .select();
    List<Annonce> annonces = [];
    for (var d in data) {
      annonces.add(Annonce.fromJson(d));
    }
    return annonces;
  }

  static Future<List<Annonce>> getAnnonces() async {
    final data = await MyApp.client
        .from('annonce')
        .select();
    List<Annonce> annonces = [];
    for (var d in data) {
      annonces.add(Annonce.fromJson(d));
    }
    return annonces;
  }

  static Future<int> insererAnnonce(Annonce annonce) async
  {
    final response = await MyApp.client
        .from('annonce')
        .insert([{
      'titrea': annonce.titre,
      'descriptiona': annonce.description,
      'dureereservation': annonce.dureeReservationMax,
      'etata': annonce.etat,
      'idp': annonce.idProduit,

    }
    ]);
    // return id of the created object
    return response.data[0]['ida'];
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
}