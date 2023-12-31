import 'package:cloud_firestore/cloud_firestore.dart';

class listeactivite {
  String id;
  String categorie;
  String imageUrl;
  String lieu;
  int nombre_min;
  int prix;
  String titre;

  listeactivite({
    required this.id,
    required this.categorie,
    required this.imageUrl,
    required this.lieu,
    required this.nombre_min,
    required this.prix,
    required this.titre,
  });

  factory listeactivite.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return listeactivite(
      id: doc.id,
      categorie: data['categorie'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      lieu: data['lieu'] ?? '',
      nombre_min: data['nombre_min'] ?? 0,
      prix: data['prix'] ?? 0,
      titre: data['titre'] ?? '',
    );
  }
}
