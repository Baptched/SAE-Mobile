import 'package:sae/main.dart';
import 'package:sae/models/avisutilisateur.dart';

class AvisUtilisateurDB {


  static Future<void> addAvisUtilisateur(int idUtilisateur,
      int idUtilisateurNote, int note, String commentaire) async {
    await MyApp.client.from('avisutilisateur').insert([
      {
        'idu_donneur': idUtilisateur,
        'idu_receveur': idUtilisateurNote,
        'note': note,
        'commentaire': commentaire,
      }
    ]);
  }

  // getMoyenne
  static Future<double> getMoyenne(int idUtilisateur) async {
    final response = await MyApp.client
        .from('avisutilisateur')
        .select('note')
        .eq('idu_receveur', idUtilisateur);

    double moyenne = 0;
    int count = 0;
    print(response);
    for (var d in response) {
      moyenne += d['note'];
      count++;
    }
    if (count == 0) {
      return 0;
    }
    return moyenne / count;
  }

  static Future<List<AvisUtilisateur>> getAvisUtilisateurByUtilisateur(
      int idUtilisateur) async {
    final response = await MyApp.client
        .from('avisutilisateur')
        .select()
        .eq('idu_receveur', idUtilisateur);

    List<AvisUtilisateur> avis = [];
    for (var d in response) {
      avis.add(AvisUtilisateur.fromJson(d));
    }
    return avis;
  }
}