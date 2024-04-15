import 'package:flutter/material.dart';
import 'package:sae/UI/detail_message.dart';
import 'package:sae/UI/profil_autre_utilisateur.dart';
import 'package:sae/database/supabase/avisutilisateurDB.dart';
import 'package:sae/database/supabase/favDB.dart';
import 'package:sae/database/supabase/reservationBD.dart';
import 'package:sae/models/annonce.dart';
import 'package:sae/models/produit.dart';
import 'package:sae/models/utilisateur.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  double? _note;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() async {
    _isLiked = widget.isLiked;
    _likesCount = widget.likesCount;
    int? idUser = await SharedPreferences.getInstance().then(
      (prefs) => prefs.getInt('idUtilConnecte'),
    );
    while (idUser == null) {
      await Future.delayed(Duration(seconds: 1));
      idUser = await SharedPreferences.getInstance()
          .then((prefs) => prefs.getInt('idUtilConnecte'));
    }
    double? noteUtil =
        await AvisUtilisateurDB.getMoyenne(widget.utilisateur.id);
    setState(() {
      _note = noteUtil;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'annonce'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print('Retour à la page précédente');
            Navigator.pop(context, {
              'isLiked': _isLiked,
              'likesCount': _likesCount,
            });
          },
        ),
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
                    if (widget.produit.imageUint8List != null)
                      Image.memory(
                        widget.produit.imageUint8List!,
                        fit: BoxFit.cover,
                      ),
                    SizedBox(height: 16),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            int? idUser =
                                await SharedPreferences.getInstance().then(
                              (prefs) => prefs.getInt('idUtilConnecte'),
                            );
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
                            _showDateSelection(context);
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilUtilisateurPage(
                                  pseudo: widget.utilisateur.pseudo ?? '',
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              if (widget.utilisateur.imageUint8List != null)
                                CircleAvatar(
                                  backgroundImage: Image.memory(
                                          widget.utilisateur.imageUint8List!)
                                      .image,
                                ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${widget.utilisateur.pseudo ?? ""}'),
                                  SizedBox(height: 8),
                                  Text('${_note ?? 0}/5'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            int? idUser =
                                await SharedPreferences.getInstance().then(
                              (prefs) => prefs.getInt('idUtilConnecte'),
                            );
                            while (idUser == null) {
                              await Future.delayed(Duration(seconds: 1));
                              idUser = await SharedPreferences.getInstance()
                                  .then((prefs) =>
                                      prefs.getInt('idUtilConnecte'));
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConversationWidget(
                                  idUserConnected: idUser ?? 0,
                                  idUserToChat: widget.utilisateur.id,
                                ),
                              ),
                            );
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

  void _showDateSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height * 0.35,
          child: DateSelectionPage(
            idAnnonce: widget.annonce.id ?? 0,
          ),
        );
      },
    );
  }
}

class DateSelectionPage extends StatefulWidget {
  final int idAnnonce;
  int idUtilisateur = 0;

  DateSelectionPage({required this.idAnnonce});

  @override
  _DateSelectionPageState createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends State<DateSelectionPage> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // Initialize start and end dates to today and tomorrow respectively
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(Duration(days: 1));
    _loadIdUtilisateur();
  }

  Future<void> _loadIdUtilisateur() async {
    int? idUser = await SharedPreferences.getInstance().then((prefs) {
      return prefs.getInt('idUtilConnecte');
    });
    print('idUtilisateur: $idUser');
    widget.idUtilisateur = idUser ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 50),
        ListTile(
          title: Text("Date de début"),
          subtitle: Text("${_startDate.toLocal()}".split(' ')[0]),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _startDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null && pickedDate != _startDate)
              setState(() {
                _startDate = pickedDate;
              });
          },
        ),
        ListTile(
          title: Text("Date de fin"),
          subtitle: Text("${_endDate.toLocal()}".split(' ')[0]),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _endDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null && pickedDate != _endDate)
              setState(() {
                _endDate = pickedDate;
              });
          },
        ),
        ElevatedButton(
          onPressed: () {
            print('Date de début: $_startDate');
            print('Date de fin: $_endDate');
            print(
                'idAnnonce: ${widget.idAnnonce}, idUtilisateur: ${widget.idUtilisateur}');

            ReservationBD.addReservation(
                widget.idAnnonce, widget.idUtilisateur, _startDate, _endDate);
            Navigator.pop(context, {
              'startDate': _startDate,
              'endDate': _endDate,
            });
          },
          child: Text('Réserver'),
        ),
      ],
    );
  }
}
