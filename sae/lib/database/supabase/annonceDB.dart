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
}
