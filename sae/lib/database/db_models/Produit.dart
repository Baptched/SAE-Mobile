// classe de produit inutile pour le moment. Ne pas utiliser

class Produit {
  int? id;
  String label;
  String condition;
  int disponible;
  String imageProduit;

  Produit({
    this.id,
    required this.label,
    required this.condition,
    required this.disponible,
    required this.imageProduit,
  });

  Map<String, dynamic> toMap() {
    return {
      'idP': id,
      'labelP': label,
      'conditionP': condition,
      'disponible': disponible,
      'imageProduit': imageProduit,
    };
  }

  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      id: map['idP'],
      label: map['labelP'],
      condition: map['conditionP'],
      disponible: map['disponible'],
      imageProduit: map['imageProduit'],
    );
  }
}
