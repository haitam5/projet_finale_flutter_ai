import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AjoutActivite extends StatefulWidget {
  const AjoutActivite({Key? key}) : super(key: key);

  @override
  _PageAjoutActiviteState createState() => _PageAjoutActiviteState();
}

class _PageAjoutActiviteState extends State<AjoutActivite> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  var _recognitions;
  var v = "";
  String categorie = '';
  String imageUrl = '';
  String lieu = '';
  int nombre_min = 0;
  int prix = 0;
  String titre = '';

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detectImage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future detectImage(File image) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
      v = recognitions.toString();
    });
    print("//////////////////////////////////////////////////");
    print(_recognitions);
    print("//////////////////////////////////////////////////");
    int endTime = DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une activité"),
        backgroundColor: Color.fromARGB(255, 1, 29, 52),
        titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.bold,
          fontSize: 28.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Choisir une image'),
              ),
              if (_image != null)
                Image.memory(
                  file!.readAsBytesSync(),
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              if (_recognitions != null)
                Text(
                  'Détection d\'objets : $_recognitions',
                  style: TextStyle(fontSize: 16),
                ),
              _buildTextField("Libellé", (value) {
                setState(() {
                  categorie = value;
                });
              }),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              if (imageUrl.isNotEmpty)
                const SizedBox(height: 16),
              _buildTextField("Lieu", (value) {
                setState(() {
                  lieu = value;
                });
              }),
              const SizedBox(height: 16),
              _buildNumberTextField("Nombre Minimum", (value) {
                setState(() {
                  nombre_min = int.tryParse(value) ?? 0;
                });
              }),
              const SizedBox(height: 16),
              _buildNumberTextField("Prix", (value) {
                setState(() {
                  prix = int.tryParse(value) ?? 0;
                });
              }),
              const SizedBox(height: 16),
              _buildTextField("Titre", (value) {
                setState(() {
                  titre = value;
                });
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Ajouter l'activité à Firestore
                  ajouterActiviteAFirestore();
                },
                child: Text("Ajouter"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberTextField(String label, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }

  void ajouterActiviteAFirestore() async {
    try {
      await firestore.collection("master2").add({
        'categorie': categorie,
        'image': imageUrl,
        'lieu': lieu,
        'nbr_min': nombre_min,
        'prix': prix,
        'titre': titre,
      });

      // Réinitialisez les valeurs après l'ajout réussi
      setState(() {
        categorie = '';
        imageUrl = '';
        lieu = '';
        nombre_min = 0;
        prix = 0;
        titre = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Activité ajoutée avec succès'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'activité dans Firestore : $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de l\'ajout de l\'activité'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
