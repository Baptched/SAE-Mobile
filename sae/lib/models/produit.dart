class Produit {
  int? id;
  String label;
  String condition;
  int disponible;
  String lienImageProduit;
  int? idUtilisateur;

  Produit({
    this.id,
    required this.label,
    required this.condition,
    required this.disponible,
    this.lienImageProduit = 'default_produit_image.png',
    this.idUtilisateur, // pour supabase, inutile pour le modèle produit local
  });

  // toString
  @override
  String toString() {
    return 'Produit{id: $id, label: $label, condition: $condition, disponible: $disponible, lienImageProduit: $lienImageProduit}, idUtilisateur: $idUtilisateur';
  }

  // fromJson
  static Produit fromJson(Map<String, dynamic> json) {
    return Produit(
      id: json['idp'],
      label: json['labelp'],
      condition: json['conditionp'],
      disponible: json['disponible'],
      lienImageProduit: 'default_produit_image.png', // vu qu'on a pas d'images..
      idUtilisateur: json['idu'], // pour supabase, a debug
    );
  }

}
