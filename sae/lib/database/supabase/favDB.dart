import 'dart:async';
import 'package:sae/main.dart';

class FavDB {

  static Future<void> likeUnLikeAnnonce(int ida, int idu) async {
    final data = await MyApp.client.from('Favoris').select().eq('ida', ida).eq('idu', idu);
    if (data.isEmpty) {
      await MyApp.client.from('Favoris').insert({'ida': ida, 'idu': idu});
    } else {
      await MyApp.client.from('Favoris').delete().eq('ida', ida).eq('idu', idu);
    }
  }

  static Future<bool> isAnnonceLiked(int ida, int idu) async {
    final dataa = await MyApp.client.from('Favoris').select() ;
    print(dataa);
    final data = await MyApp.client.from('Favoris').select().eq('ida', ida).eq('idu', idu);
    print(data.isNotEmpty);
    return data.isNotEmpty;
  }

  static Future<int> getLikesCount(int ida) async {
    final data = await MyApp.client.from('Favoris').select().eq('ida', ida);
    return data.length;
  }
}