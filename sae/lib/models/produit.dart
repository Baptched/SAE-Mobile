class Produit {
  int? id;
  String label;
  String condition;
  int disponible;
  String lienImageProduit;

  Produit({
    this.id,
    required this.label,
    required this.condition,
    required this.disponible,
    this.lienImageProduit = 'default_produit_image.png',
  });


}
