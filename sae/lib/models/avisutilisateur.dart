class AvisUtilisateur {
  int idu_donneur;
  int idu_receveur;
  int note;
  String commentaire;

  AvisUtilisateur({
    required this.idu_donneur,
    required this.idu_receveur,
    required this.note,
    required this.commentaire,
  });

  static fromJson(Map<String, dynamic> json) {
    return AvisUtilisateur(
      idu_donneur: json['idu_donneur'],
      idu_receveur: json['idu_receveur'],
      note: json['note'],
      commentaire: json['commentaire'],
    );
  }

}