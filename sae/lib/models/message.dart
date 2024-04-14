class Message {
  int id;
  String contenu;
  int idUtilisateurEnvoi;
  int idUtilisateurRecoit;
  String dateEnvoi;

  Message({
    required this.id,
    required this.contenu,
    required this.idUtilisateurEnvoi,
    required this.idUtilisateurRecoit,
    required this.dateEnvoi,
  });

  static fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['idm'],
      contenu: json['contenu'],
      idUtilisateurEnvoi: json['iduenvoi'],
      idUtilisateurRecoit: json['idurecoit'],
      dateEnvoi: json['dateenvoi'],
    );
  }

  @override
  String toString() {
    return 'Message{id: $id, contenu: $contenu, idUtilisateurEnvoi: $idUtilisateurEnvoi, idUtilisateurRecoit: $idUtilisateurRecoit, dateEnvoi: $dateEnvoi}';
  }

  // getteurs

  int get getId => id;

  String get getContenu => contenu;

  int get getIdUtilisateurEnvoi => idUtilisateurEnvoi;

  int get getIdUtilisateurRecoit => idUtilisateurRecoit;

  String get getDateEnvoi => dateEnvoi;

  // setteurs

  set setId(int id) {
    this.id = id;
  }

  set setContenu(String contenu) {
    this.contenu = contenu;
  }

  set setIdUtilisateurEnvoi(int idUtilisateurEnvoi) {
    this.idUtilisateurEnvoi = idUtilisateurEnvoi;
  }

  set setIdUtilisateurRecoit(int idUtilisateurRecoit) {
    this.idUtilisateurRecoit = idUtilisateurRecoit;
  }

  set setDateEnvoi(String dateEnvoi) {
    this.dateEnvoi = dateEnvoi;
  }
}
