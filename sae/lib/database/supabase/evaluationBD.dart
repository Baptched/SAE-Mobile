import 'package:sae/main.dart';
import 'package:sae/models/annonce.dart';

class EvaluationBD{
  Future<bool> isEvaluate(int idR) async {
    final data = await MyApp.client
        .from('Evaluation')
        .select()
        .eq('idr', idR);
    if (data.isEmpty) {
      return false;
    }
    return true;
  }

  static Future<void> ajouterEvaluation(int idr, int note) async {
    await MyApp.client.from('Evaluation').insert([
      {
        'idr': idr,
        'note': note,
      }
    ]);
  }
}