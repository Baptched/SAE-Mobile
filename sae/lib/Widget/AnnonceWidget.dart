import 'package:flutter/material.dart';
import 'package:sae/models/annonce.dart';
import 'package:sae/models/produit.dart';
import 'package:sae/database/supabase/produitDB.dart';
import 'package:sae/models/utilisateur.dart';
import 'package:sae/database/supabase/utilisateurDB.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sae/database/supabase/favDB.dart';
import 'package:sae/UI/detail_annonce.dart';

class AnnonceWidget extends StatefulWidget {
  final Annonce annonce;

  AnnonceWidget({Key? key, required this.annonce}) : super(key: key);

  @override
  _AnnonceWidgetState createState() => _AnnonceWidgetState();
}

class _AnnonceWidgetState extends State<AnnonceWidget> {
  bool _isLiked = false;
  int _likesCount = 0;
  Produit? _produit;
  Utilisateur? _utilisateur;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    chargerProduitEtUtilisateur();
  }

  Future<void> chargerProduitEtUtilisateur() async {
    try {
      int? idUser = await SharedPreferences.getInstance().then((prefs) {
        return prefs.getInt('idUtilConnecte');
      });

      _isLiked =
          await FavDB.isAnnonceLiked(widget.annonce.id ?? 0, idUser ?? 0);
      _likesCount = await FavDB.getLikesCount(widget.annonce.id ?? 0);
      _produit = await ProduitDB.getProduitById(widget.annonce.idProduit);
      while (_produit == null) {
        await Future.delayed(Duration(seconds: 1));
      }
      _utilisateur =
          await UtilisateurDB.getUtilisateurById(_produit!.idUtilisateur ?? 0);
    } catch (e) {
      print('Erreur lors du chargement des informations : $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : _produit != null && _utilisateur != null
            ? GestureDetector(
                // Wrap AnnonceWidget in GestureDetector
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailAnnonce(annonce: widget.annonce, produit: _produit!, utilisateur: _utilisateur!, isLiked: _isLiked, likesCount: _likesCount)
                    ),
                  );
                },
                child: buildAnnonceWidget(),
              )
            : SizedBox();
  }

  Widget buildAnnonceWidget() {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: _utilisateur!.imageUint8List != null
                        ? Image.memory(_utilisateur!.imageUint8List!).image
                        : null,
                  ),
                  title: Text(widget.annonce.titre),
                  subtitle: Text('Publié par: ${_utilisateur?.pseudo ?? ""}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Condition: ${_produit?.condition ?? ""}'),
                      Text('Description: ${widget.annonce.description}'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : null,
                      ),
                      onPressed: () async {
                        int? idUser =
                            await SharedPreferences.getInstance().then((prefs) {
                          return prefs.getInt('idUtilConnecte');
                        });
                        while (idUser == null) {
                          await Future.delayed(Duration(seconds: 1));
                          idUser = await SharedPreferences.getInstance()
                              .then((prefs) {
                            return prefs.getInt('idUtilConnecte');
                          });
                        }
                        FavDB.likeUnLikeAnnonce(
                            widget.annonce.id ?? 0, idUser ?? 0);
                        setState(() {
                          _isLiked = !_isLiked;
                          if (_isLiked) {
                            _likesCount++;
                          } else {
                            _likesCount--;
                          }
                        });
                      },
                    ),
                    Text('$_likesCount Likes'),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _produit!.imageUint8List != null
                  ? SizedBox(
                      width: 150.0, // Ajustez la largeur selon vos besoins
                      child: Image.memory(
                        _produit!.imageUint8List!,
                        fit: BoxFit.cover, // ou tout autre ajustement souhaité
                      ),
                    )
                  : SizedBox(), // Placeholder if no image
            ),
          ),
        ],
      ),
    );
  }
}
