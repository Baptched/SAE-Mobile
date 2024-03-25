import 'package:flutter/material.dart';

class AnnoncesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Text(
                  'Annonces',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Divider(thickness: 4),
                SizedBox(height: 35),
                Divider(thickness: 4),
              ],
            ),
          ),
          // Ajoutez ici le contenu de votre page d'annonces
        ],
      ),
    );
  }
}