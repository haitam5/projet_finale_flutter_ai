import 'package:flutter/material.dart';
import 'package:projet_finale_mathieu/ModelD/modelActivity.dart';

class PageDetailsActivite extends StatelessWidget {
  final listeactivite activity;

  PageDetailsActivite(this.activity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'activité'),
        backgroundColor: Color.fromARGB(255, 1, 29, 52),
        titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.bold,
          fontSize: 28.0,
        ),
      ),
      body: Center(
        child: Container(
          width: 300, // Ajustez la largeur selon vos besoins
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Afficher l'image de l'activité
              Container(
                width: double.infinity,
                height: 200, // Ajustez la hauteur selon vos besoins
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(activity.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Titre: ${activity.titre}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Catégorie: ${activity.categorie}'),
              Text('Lieu: ${activity.lieu}'),
              Text('Nombre Minimum: ${activity.nombre_min}'),
              Text('Prix: ${activity.prix}'),
              // Ajoutez d'autres détails selon vos besoins
            ],
          ),
        ),
      ),
    );
  }
}
