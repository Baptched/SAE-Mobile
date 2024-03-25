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
    required this.lienImageProduit,
  });

  Map<String, dynamic> toMap() {
    return {
      'idP': id,
      'labelP': label,
      'conditionP': condition,
      'disponible': disponible,
      'lienImageProduit': lienImageProduit,
    };
  }

  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      id: map['idP'],
      label: map['labelP'],
      condition: map['conditionP'],
      disponible: map['disponible'],
      lienImageProduit: map['lienImageProduit'],
    );
  }
}
