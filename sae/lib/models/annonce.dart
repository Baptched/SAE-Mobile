class Annonce{

  int? id;
  String titre;
  int duree;
  String etat;
  int idProduit;

  Annonce({
    this.id,
    required this.titre,
    required this.duree,
    required this.etat,
    required this.idProduit,
  });

  static fromJson(Map<String, dynamic> json) {
    return Annonce(
      id: json['ida'],
      titre: json['titrea'],
      duree: json['dureereservation'],
      etat: json['etata'],
      idProduit: json['idp'],
    );
  }
}