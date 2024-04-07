class Annonce{

  int? id;
  String titre;
  String description;
  int dureeReservationMax;
  String etat;
  int enLigne;
  int idProduit;

  Annonce({
    this.id,
    required this.titre,
    required this.description,
    required this.dureeReservationMax,
    required this.etat,
    required this.enLigne,
    required this.idProduit,
  });

  static fromJsonSupabase(Map<String, dynamic> json) {
    return Annonce(
      id: json['ida'],
      titre: json['titrea'],
      description: json['descriptiona'],
      dureeReservationMax: json['dureereservation'],
      etat: json['etata'],
      enLigne: 1,
      idProduit: json['idp'],
    );
  }

  static fromJson(Map<String, dynamic> json) {
    return Annonce(
      id: json['ida'],
      titre: json['titrea'],
      description: json['descriptiona'],
      dureeReservationMax: json['dureereservation'],
      etat: json['etata'],
      enLigne: json['enligne'],
      idProduit: json['idp'],
    );
  }
}