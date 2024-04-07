import 'package:flutter/material.dart';
import 'package:sae/models/annonce.dart';
import 'package:sae/models/produit.dart';
import 'package:sae/database/supabase/produitDB.dart';
import 'package:sae/models/utilisateur.dart';
import 'package:sae/database/supabase/utilisateurDB.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sae/database/supabase/favDB.dart';

class DetailAnnonce extends StatefulWidget {
  final Annonce annonce;
  final Produit produit;
  final Utilisateur utilisateur;
  final bool isLiked;
  final int likesCount;

  DetailAnnonce({
    Key? key,
    required this.annonce,
    required this.produit,
    required this.utilisateur,
    required this.isLiked,
    required this.likesCount,
  }) : super(key: key);

  @override
  _DetailAnnonceState createState() => _DetailAnnonceState();
}

class _DetailAnnonceState extends State<DetailAnnonce> {
  bool _isLiked = false;
  late int _likesCount;

  @override
  void initState() {
    _isLiked = widget.isLiked;
    _likesCount = widget.likesCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'annonce'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.produit.label ?? "",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      title: Text(
                        'État : ${widget.produit.condition ?? ""}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Description : ${widget.annonce.description}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    widget.produit.imageUint8List != null
                        ? Image.memory(
                            widget.produit.imageUint8List!,
                            fit: BoxFit.cover,
                          )
                        : SizedBox(),
                    SizedBox(height: 16),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            int? idUser = await SharedPreferences.getInstance()
                                .then(
                                    (prefs) => prefs.getInt('idUtilConnecte'));
                            while (idUser == null) {
                              await Future.delayed(Duration(seconds: 1));
                              idUser = await SharedPreferences.getInstance()
                                  .then((prefs) =>
                                      prefs.getInt('idUtilConnecte'));
                            }
                            FavDB.likeUnLikeAnnonce(
                                widget.annonce.id ?? 0, idUser ?? 0);
                            setState(() {
                              _isLiked = !_isLiked;
                              if (_isLiked) {
                                _likesCount++;
                              } else {
                                _likesCount = _likesCount - 1;
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isLiked ? Colors.red : null,
                              ),
                              SizedBox(width: 8),
                              Text('$_likesCount Likes'),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Ajoutez ici la logique pour réserver l'annonce
                          },
                          child: Text('Réserver'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Publié par :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: widget
                                          .utilisateur.imageUint8List !=
                                      null
                                  ? Image.memory(
                                          widget.utilisateur.imageUint8List!)
                                      .image
                                  : null,
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${widget.utilisateur.pseudo ?? ""}'),
                                SizedBox(height: 8),
                                Text(
                                  '/5',
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Ajoutez ici la logique pour envoyer un message
                          },
                          child: Row(
                            children: [
                              Icon(Icons.message),
                              SizedBox(width: 8),
                              Text('Message'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
