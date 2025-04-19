import 'package:flutter/material.dart';
//import 'tac1.dart';
import 'tac2.dart';
import 'tac3.dart';
import 'tac4.dart';
import 'tac5.dart';


class Tac extends StatelessWidget {
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
          ),),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 400.0, // Adjust the width as needed
              maxHeight: 600.0, // Adjust the height as needed
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/png_images/airchiller.png', // Replace with your custom icon path
                    height: 100.0,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'AIR CHILLER',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
/*                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Tac1()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.black,
                      minimumSize: Size(200.0, 50.0),
                    ),
                    child: Text('Air chiller 1 : 7.5 KW'),
                  ),
*/
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Tac2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.black,
                      minimumSize: Size(200.0, 50.0),
                    ),
                    child: Text('Air Chiller 1 : China'),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Tac3()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.black,
                      minimumSize: Size(200.0, 50.0),
                    ),
                    child: Text('Air Chiller 2 : 46.83 KW'),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Tac4()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.black,
                      minimumSize: Size(200.0, 50.0),
                    ),
                    child: Text('Air Chiller 3 : 46.83 KW'),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Tac5()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.black,
                      minimumSize: Size(200.0, 50.0),
                    ),
                    child: Text('Air Chiller 4 : 46.83 KW'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}