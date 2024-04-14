import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sae/database/supabase/utilisateurDB.dart';
import 'package:sae/models/utilisateur.dart';
import 'package:sae/Widget/AvisUtilisateur.dart';
import 'package:sae/database/supabase/avisUtilisateurDB.dart';
import '../Widget/AjoutAvis.dart';
import '../models/avisutilisateur.dart';

class ProfilUtilisateurPage extends StatefulWidget {
  final String pseudo;

  const ProfilUtilisateurPage({Key? key, required this.pseudo}) : super(key: key);

  @override
  _ProfilUtilisateurPageState createState() => _ProfilUtilisateurPageState();
}

class _ProfilUtilisateurPageState extends State<ProfilUtilisateurPage> {
  late Future<Utilisateur>? _utilisateurFuture = Future.value(Utilisateur(
    id: 0,
    pseudo: 'Utilisateur introuvable',
    nom: '',
    prenom: '',
    motDePasse: '',
    imageUint8List: null,
  ));

  late Future<List<AvisUtilisateur>> _avisFuture = Future.value([]);
  late int _idUtilisateur;

  @override
  void initState() {
    super.initState();
    _loadUtilisateur();
    _loadAvis();
  }

  Future<void> _loadUtilisateur() async {
    try {
      final utilisateur = await UtilisateurDB.getUtilisateurByPseudo(widget.pseudo);
      setState(() {
        _utilisateurFuture = Future.value(utilisateur);
        _idUtilisateur = utilisateur!.id;
      });
    } catch (e) {
      print('Erreur lors du chargement de l\'utilisateur: $e');
    }
  }

  Future<void> _loadAvis() async {
    try {
      final utilisateur = await UtilisateurDB.getUtilisateurByPseudo(widget.pseudo);
      final lesAvis = await AvisUtilisateurDB.getAvisUtilisateurByUtilisateur(utilisateur!.id);
      setState(() {
        _avisFuture = Future.value(lesAvis);
      });
    } catch (e) {
      print('Erreur lors du chargement des avis: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil de ${widget.pseudo}'),
      ),
      body: Center(
        child: FutureBuilder<Utilisateur>(
          future: _utilisateurFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else if (snapshot.hasData) {
              Utilisateur utilisateur = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    utilisateur.imageUint8List != null
                        ? CircleAvatar(
                      radius: 50,
                      backgroundImage: MemoryImage(utilisateur.imageUint8List!),
                    )
                        : CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/user_img/default_user_image.png'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nom: ${utilisateur.nom}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Prénom: ${utilisateur.prenom}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Naviguer vers la page des annonces de l'utilisateur
                        // Utilisez Navigator.push pour naviguer à la page des annonces de l'utilisateur
                      },
                      child: Text('Voir ses annonces'),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 20),
                    Text(
                      'Avis des utilisateurs',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: FutureBuilder<List<AvisUtilisateur>>(
                        future: _avisFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Erreur: ${snapshot.error}'),
                            );
                          } else if (snapshot.hasData) {
                            List<AvisUtilisateur> avis = snapshot.data!;
                            return ListView.builder(
                              itemCount: avis.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: AvisWidget(
                                    auteurId: avis[index].idu_donneur,
                                    note: avis[index].note,
                                    avis: avis[index].commentaire,
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text('Cet utilisateur n\'a reçu aucun avis pour le moment.'),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Si l'utilisateur n'est pas chargé, affichez un CircularProgressIndicator
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: AjouterAvisWidget(
                    pseudoUtilisateur: widget.pseudo,
                    idUtilisateur: _idUtilisateur,
                  ),
                );
              },
            );
          },
          child: Text('Ajouter un avis', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
