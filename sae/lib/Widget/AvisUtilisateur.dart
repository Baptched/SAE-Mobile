import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sae/database/supabase/utilisateurDB.dart';
import 'package:sae/models/utilisateur.dart';

class AvisWidget extends StatefulWidget {
  final int auteurId;
  final int note;
  final String avis;

  const AvisWidget({
    Key? key,
    required this.auteurId,
    required this.note,
    required this.avis,
  }) : super(key: key);

  @override
  _AvisWidgetState createState() => _AvisWidgetState();
}

class _AvisWidgetState extends State<AvisWidget> {
  late Future<Utilisateur?> _auteurFuture;

  @override
  void initState() {
    super.initState();
    _auteurFuture = _getAuteur();
  }

  Future<Utilisateur?> _getAuteur() async {
    Utilisateur? auteur = await UtilisateurDB.getUtilisateurById(widget.auteurId);
    if (auteur != null) {
      return auteur;
    } else {
      return Utilisateur(
        id: 0,
        pseudo: 'Utilisateur introuvable',
        nom: '',
        prenom: '',
        motDePasse: '',
        imageUint8List: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Utilisateur?>(
      future: _auteurFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          Utilisateur auteur = snapshot.data!;
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.memory(
                          auteur.imageUint8List ?? Uint8List(0),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        auteur.pseudo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Note: ${widget.note}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 8),
                      // Icônes d'étoiles pour représenter la note
                      Row(
                        children: List.generate(
                          5,
                              (index) => Icon(
                            index < widget.note ? Icons.star : Icons.star_border,
                            color: index < widget.note ? Colors.orange : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Avis: ${widget.avis}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text('Auteur introuvable'));
        }
      },
    );
  }
}
