class Produit {
  final int? id;
  final String label;
  final String condition;
  final int disponible;
  String lienImageProduit;

  Produit({
    this.id,
    required this.label,
    required this.condition,
    required this.disponible,
    this.lienImageProduit = 'default_produit_image.png',
  });


}
