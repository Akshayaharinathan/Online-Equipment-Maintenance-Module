import 'package:flutter/material.dart';
import 'mvpanel.dart'; // Assuming this is another page
import 'dgpanel.dart'; 
import 'solarpanel.dart';// Assuming this is another page

class PanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel Room'),
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
              label: 'MV Panel',
              imagePath: 'assets/png_images/mvpanel.png',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => mvPage()), // Ensure mvPage() is defined
                );
              },
            ),
            EquipmentButton(
              label: 'DG synchronization panel',
              imagePath: 'assets/png_images/dgpanel.png',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DGPage()), // Ensure DGPage() is defined
                );
              },
            ),
            EquipmentButton(
              label: 'Solar panel',
              imagePath: 'assets/png_images/solar.png',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SolarPage()), // Ensure DGPage() is defined
                );
              },
            ),
            // Remove the recursive navigation
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
