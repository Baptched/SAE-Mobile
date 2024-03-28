import 'package:flutter/material.dart';
import 'dart:io'; // Pour File
import 'package:image_picker/image_picker.dart';

class PageAjoutProduit extends StatefulWidget {
  @override
  _PageAjoutProduitState createState() => _PageAjoutProduitState();
}

class _PageAjoutProduitState extends State<PageAjoutProduit> {
  late String _label;
  late String _condition = 'Neuf';
  late bool _disponible = true;
  File? _imageProduit;

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  Future<void> _choisirImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageProduit = File(image.path);
      });
    }
  }

  Future<void> _supprimerImage() async {
    setState(() {
      _imageProduit = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Label de l\'objet'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un label';
                  }
                  return null;
                },
                onSaved: (value) {
                  _label = value!;
                },
              ),
              SizedBox(height: 32.0),
              Text('Condition de l\'objet', style: TextStyle(fontSize: 16.0)),
              DropdownButtonFormField<String>(
                value: _condition,
                items: <String>['Neuf', 'Très bon état', 'Bon état','Etat moyen', 'Abîmé'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _condition = value!;
                  });
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _choisirImage,
                child: Text('Ajouter une image'),
              ),
              if (_imageProduit != null)
                Container(
                  height: 200,
                  width: 200,// Taille de la prévisualisation de l'image
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: FileImage(_imageProduit!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: _supprimerImage,
                        ),
                      ),
                    ],
                  ),
                ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Assurez-vous de valider et sauvegarder les informations du formulaire avant de procéder
                },
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
