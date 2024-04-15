class Reservation {
  final int id;
  final int idAnnonce;
  final int idUtilisateur;
  final DateTime startDate;
  final DateTime endDate;
  bool isEvaluated;

  Reservation({
    required this.id,
    required this.idAnnonce,
    required this.idUtilisateur,
    required this.startDate,
    required this.endDate,
    required this.isEvaluated,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['idr'],
      idAnnonce: json['ida'],
      idUtilisateur: json['idu'],
      startDate: DateTime.parse(json['datedebut']),
      endDate: DateTime.parse(json['datefin']),
      isEvaluated: json['isEvaluate']
    );
  }
}