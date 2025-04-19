import 'package:flutter/material.dart';
import 'package:JSBE3M/generator1_checklist.dart';
import 'package:JSBE3M/generator1_measurement.dart';
import 'package:JSBE3M/generator2_checklist.dart';
import 'package:JSBE3M/generator2_measurement.dart';
import 'package:JSBE3M/generator3_checklist.dart';
import 'package:JSBE3M/generator3_measurement.dart';



class GeneratorPage extends StatelessWidget {
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
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 400.0, // Adjust the width as needed
              maxHeight: 400.0, // Adjust the height as needed
            ),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the inner container
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/png_images/generator.png', // Replace with your custom icon path
                  height: 100.0,
                ),
                SizedBox(height: 20.0),
                Text(
                  'DIESEL GENERATOR',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Generator1()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    minimumSize: Size(200.0, 50.0),
                  ),
                  child: Text('Generator 1'),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Generator2()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    minimumSize: Size(200.0, 50.0),
                  ),
                  child: Text('Generator 2'),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Generator3()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    minimumSize: Size(200.0, 50.0),
                  ),
                  child: Text('Generator 3'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class Generator1 extends StatelessWidget {
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
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 400.0, // Adjust the width as needed
              maxHeight: 400.0, // Adjust the height as needed
            ),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the inner container
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/png_images/generator.png', // Replace with your custom icon path
                  height: 100.0,
                ),
                SizedBox(height: 20.0),
                Center( // Center the text horizontally
                  child: Text(
                    'GENERATOR 1 (600kva,440V,50HZ)',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Center the text inside its container
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Generator1ChecklistPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    minimumSize: Size(200.0, 50.0),
                  ),
                  child: Text('Check list'),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Generator1MeasurementPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    minimumSize: Size(200.0, 50.0),
                  ),
                  child: Text('Measurement'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class Generator2 extends StatelessWidget {
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
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 400.0, // Adjust the width as needed
              maxHeight: 400.0, // Adjust the height as needed
            ),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the inner container
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/png_images/generator.png', // Replace with your custom icon path
                  height: 100.0,
                ),
                SizedBox(height: 20.0),
                Center( // Center the text horizontally
                  child: Text(
                    'GENERATOR 2 (600kva,440V,50HZ)',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Center the text inside its container
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Generator2ChecklistPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    minimumSize: Size(200.0, 50.0),
                  ),
                  child: Text('Check list'),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Generator2MeasurementPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    minimumSize: Size(200.0, 50.0),
                  ),
                  child: Text('Measurement'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class Generator3 extends StatelessWidget {
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
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 400.0, // Adjust the width as needed
              maxHeight: 400.0, // Adjust the height as needed
            ),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the inner container
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/png_images/generator.png', // Replace with your custom icon path
                  height: 100.0,
                ),
                SizedBox(height: 20.0),
                Center( // Center the text horizontally
                  child: Text(
                    'GENERATOR 3 (400kva,440V,50HZ)',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Center the text inside its container
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Generator3ChecklistPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    minimumSize: Size(200.0, 50.0),
                  ),
                  child: Text('Check list'),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Generator3MeasurementPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.black,
                    minimumSize: Size(200.0, 50.0),
                  ),
                  child: Text('Measurement'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
