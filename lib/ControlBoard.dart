// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'Transformer.dart';
import 'generator.dart';
import 'panelroom.dart';
import 'ups.dart';
import 'acomp.dart';
import 'control_panel_page.dart';
import 'waterchiller.dart';
import 'airchiller.dart';



class ControlBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ONLINE EQUIPMENT MAINTENANCE MODULE'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBAD9B7), // Light Gold
              Color(0xFF80BC7B), // Light Green
              Color(0xFF92DE6E), // Light Olive
            ],
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            EquipmentButton(
              label: 'Transformer',
              imagePath: 'assets/png_images/transformer.png',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Transformer()),
                );
              },
            ),
            EquipmentButton(
              label: 'Generator',
              imagePath: 'assets/png_images/generator.png',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeneratorPage()),
                );
              },
            ),
            EquipmentButton(
  label: 'Panel Room',
  imagePath: 'assets/png_images/panelroom.png',
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PanPage()), // This should navigate to PanPage
    );
  },
),

            EquipmentButton(
              label: 'UPS',
              imagePath: 'assets/png_images/UPS.png',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UPSPage()),
                );
              },
            ),
            EquipmentButton(
              label: 'Air Compressor',
              imagePath: 'assets/png_images/aircompressor.png',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => acomp()),
                );
              },
            ),
            EquipmentButton(
              label: 'Control panel',
              imagePath: 'assets/png_images/controlpanel.png',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => cnPage()),
                );
              },
            ),
            EquipmentButton(
              label: 'Water Chiller',
              imagePath: 'assets/png_images/waterchiller.png',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => wc()),
                );
              },
            ),
            EquipmentButton(
              label: 'Air Chiller',
              imagePath: 'assets/png_images/airchiller.png',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ac()),
                );
              },
            ),
            
            
          ],
        ),
      ),
    );
  }
}

class EquipmentButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onPressed;

  EquipmentButton({
    required this.label,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imagePath,
              height: 80.0,
            ),
            SizedBox(height: 10.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
