class Utilisateur{

  final int id;
  final String prenom;
  final String nom;
  final String pseudo;
  final String motDePasse;
  String imageProfil;

  Utilisateur({required this.id, required this.prenom, required this.nom, required this.pseudo, required this.motDePasse,this.imageProfil = 'default_user_image.png'});


  static fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['idu'],
      prenom: json['prenomu'],
      nom: json['nomu'],
      pseudo: json['pseudo'],
      motDePasse: json['motdepasse'],
      imageProfil: json['imageprofil'],
    );
  }
}