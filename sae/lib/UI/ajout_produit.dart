import 'package:flutter/material.dart';
import 'dart:io'; // Pour File
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // Importez le package path_provider
import 'package:sae/database/sqflite/db_models/ProduitDB.dart';

import '../models/produit.dart';

class PageAjoutProduit extends StatefulWidget {

  final Function() refresh;

  PageAjoutProduit({Key ?key, required this.refresh}) : super(key: key);

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

  Future<void> _ajouterProduit() async {

    print( _imageProduit != null ? _imageProduit!.path : 'default_produit_image.png');

    String nomImage = 'default_produit_image.png';
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if ( _imageProduit != null ){
        print(p.basename(_imageProduit!.path));
        final repertoire = await getApplicationDocumentsDirectory();
        nomImage = p.basename(_imageProduit!.path);


        final newPath = p.join(
            repertoire.path, 'sae_mobile_product_img', nomImage);
        print(newPath);
        final newDirectory = Directory(p.dirname(newPath));
        print(newDirectory);
        if (!newDirectory.existsSync()) {
          newDirectory.createSync(recursive: true);
        }
        _imageProduit!.copy(newPath);
      }

      Produit produit = Produit(
        id: 0,
        label: _label,
        condition: _condition,
        disponible: _disponible ? 1 : 0,
        lienImageProduit: nomImage,
      );

      await ProduitDB.insererProduit(produit).then((value) =>
        widget.refresh());
    }
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
              SizedBox(height: 16.0),
              if (_imageProduit != null)
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 250,
                    maxWidth: 200,
                  ), // Taille de la prévisualisation de l'image
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: FileImage(_imageProduit!),
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
                  _ajouterProduit().then((value) =>
                    Navigator.pop(context)
                  );
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
