import 'package:flutter/material.dart';
import 'package:JSBE3M/dbHelper/mongodblogin.dart';
import 'thusmacontrolboard.dart';  // Ensure this import is correct
//import 'package:JSBE3M/MongoDBModel.dart';
//import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'ControlBoard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equipment Maintenance Module',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedBranch; // Allow null for no initial selection

  // Define constants for username and password
  static const String _constantUsername = 'jsb';
  static const String _constantPassword = 'jsb123';

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
          child: SingleChildScrollView(
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'assets/png_images/jeyshree logo.png', // Path to your local image
                      height: 100.0,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'JAYASHREE SPUN BOND',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.green),
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.green),
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      value: _selectedBranch,
                      items: [
                        DropdownMenuItem(
                          value: 'THUSMA',
                          child: Text('THUSMA'),
                        ),
                        DropdownMenuItem(
                          value: 'JSB',
                          child: Text('JSB'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedBranch = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Branch',
                        prefixIcon: Icon(Icons.business, color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[50], // Button color
                        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        // Validate username and password
                        if (_usernameController.text == _constantUsername &&
                            _passwordController.text == _constantPassword) {
                          // Insert the user data into the database
                         /* var id = mongo.ObjectId();
                          final user = MongoDBModel(
                            id: id,
                            username: _usernameController.text,
                            password: _passwordController.text,
                            branch: _selectedBranch ?? '',
                          );*/

                          try {
                            //await MongoDatabase.insert(user.toMap(), 'Admin Login');

                            // Check the selected branch and navigate accordingly
                            if (_selectedBranch == 'JSB') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ControlBoard()),
                              );
                            } else if (_selectedBranch == 'THUSMA') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TControlBoard()),
                              );
                            } else {
                              // Handle case where no branch is selected
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Please select a branch'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } catch (e) {
                            // Handle insertion error
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Error'),
                                //content: Text('Failed to insert data: $e'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          // Handle invalid credentials
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Invalid username or password'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text('LOGIN'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class equipmentButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  equipmentButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 200.0),
        // Adjust width as needed
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            // Set button color to green
            foregroundColor: Colors.white,
            padding: EdgeInsets.all(16.0),
            textStyle: TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            shadowColor: Colors.grey[50],
            elevation: 8.0,
          ),
          child: Center(
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

class EquipmentButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onPressed;

  EquipmentButton({required this.label, required this.imagePath, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imagePath,
              height: 60.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}













