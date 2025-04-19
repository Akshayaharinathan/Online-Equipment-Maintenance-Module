import 'package:flutter/material.dart';
import './dbHelper/mongodbjsb.dart'; // Ensure this import is correct
import 'package:intl/intl.dart';
import 'dart:async'; // Add this import for the Timer

class Generator2ChecklistPage extends StatefulWidget {
  @override
  _Generator2ChecklistPageState createState() =>
      _Generator2ChecklistPageState();
}

class _Generator2ChecklistPageState extends State<Generator2ChecklistPage> {
  final _Generator1NumberController =
      TextEditingController(text: 'Generator-600kva,440V,50HZ');
  final _gen1unitController = TextEditingController();

  final _gen1dateController = TextEditingController();
  final _gen1timeController = TextEditingController();
  final _gen1branchController = TextEditingController(text: 'JSB');
  final _gen1remarksControllers =
      List<TextEditingController>.generate(12, (_) => TextEditingController());

  final List<bool> _isYesChecked = List<bool>.generate(12, (_) => false);
  final List<bool> _isNoChecked = List<bool>.generate(12, (_) => false);

  bool _isSubmitEnabled = false; // Add this line to declare the state variable
  Timer? _timer; // Declare a timer
  // Define checklist titles directly
  List<String> checklistTitles = [
    'Check Diesel Generator area - Clean',
    'Check Generator - Clean',
    'Check Oil/Fuel/Water - Leakage',
    'Check Radiator Coolant level',
    'Any abnormal Noise in the generator',
    'Abnormal vibration in generator',
    'Oil leakage in the generator',
    'Check diesel sufficient in barrel',
    'Check diesel level',
    'Check engine oil level',
    'Check DG temperature in Engine/Alternator/Fuel system',
    'Cooling fan operation normal',
  ];

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
    _startTimer(); // Start the timer
    _validateFields(); // Initial validation check
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd'); // Format for the date
    final timeFormat = DateFormat('HH:mm:ss'); // Format for the time

    _gen1dateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _gen1timeController.text = timeFormat.format(now);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        final timeFormat = DateFormat('HH:mm:ss');
        _gen1timeController.text = timeFormat.format(now);
      });
    });
  }

  @override
  void dispose() {
    _Generator1NumberController.dispose();
    _gen1unitController.dispose();

    _gen1dateController.dispose();
    _gen1timeController.dispose();
    _gen1branchController.dispose();
    for (var controller in _gen1remarksControllers) {
      controller.dispose();
    }
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  void _handleYesChanged(int index, bool? value) {
    setState(() {
      _isYesChecked[index] = value ?? false;
      if (_isYesChecked[index]) {
        _isNoChecked[index] = false;
      }
      _validateFields();
    });
  }

  void _handleNoChanged(int index, bool? value) {
    setState(() {
      _isNoChecked[index] = value ?? false;
      if (_isNoChecked[index]) {
        _isYesChecked[index] = false;
      }
      _validateFields();
    });
  }

  void _validateFields() {
    bool allFieldsFilled = _Generator1NumberController.text.isNotEmpty &&
       // _gen1unitController.text.isNotEmpty &&
        _gen1dateController.text.isNotEmpty &&
        _gen1timeController.text.isNotEmpty &&
        _gen1branchController.text.isNotEmpty;

    bool allChecklistItemsValid =
        checklistTitles.asMap().entries.every((entry) {
      int index = entry.key;
      return _isYesChecked[index] || _isNoChecked[index];
    });

    setState(() {
      _isSubmitEnabled = allFieldsFilled && allChecklistItemsValid;
    });
  }

  Future<void> _handleSubmit() async {
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm:ss');
    _gen1timeController.text = timeFormat.format(now); // Update time before submission
    await MongoDatabase.connect();
    final checklistData = {
      'generatorNumber': _Generator1NumberController.text,
      'unit': _gen1unitController.text,
      'date': _gen1dateController.text,
      'time': _gen1timeController.text,
      'branch': _gen1branchController.text,
      'checklist': _buildChecklistData(),
    };
    await MongoDatabase.insert(checklistData, 'Generator 2 Checklist');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checklist submitted successfully!')));
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      for (var controller in _gen1remarksControllers) {
        controller.clear();
      }
      for (int i = 0; i < _isYesChecked.length; i++) {
        _isYesChecked[i] = false;
        _isNoChecked[i] = false;
      }
      _isSubmitEnabled = false;
    });
  }

  Map<String, dynamic> _buildChecklistData() {
  Map<String, dynamic> checklistData = {};

  for (int i = 0; i < checklistTitles.length; i++) {
    if (_isYesChecked[i] || _isNoChecked[i]) {
      checklistData[checklistTitles[i]] = {
        'response': _isYesChecked[i] ? 'Yes' : 'No',
        'remarks': _gen1remarksControllers[i].text,
      };
    }
  }

  return checklistData;
}

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        readOnly: readOnly, // Ensure this property is correctly set
        onChanged: (text) => _validateFields(),
      ),
    );
  }

  Widget _buildChecklistItem(String title, int index) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF2D293), // Light Gold
            Color(0xFFD7CF85), // Light Olive
            Color(0xFF9DC866), // Light Green
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        border: Border.all(color: Colors.green[700]!, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
          ),
          Row(
            children: [
              Text('Yes',
                  style: TextStyle(fontSize: 16.0, color: Colors.green[900])),
              Checkbox(
                value: _isYesChecked[index],
                onChanged: (value) => _handleYesChanged(index, value),
                activeColor: Colors.green[700],
              ),
              SizedBox(width: 20.0),
              Text('No',
                  style: TextStyle(fontSize: 16.0, color: Colors.green[900])),
              Checkbox(
                value: _isNoChecked[index],
                onChanged: (value) => _handleNoChanged(index, value),
                activeColor: Colors.red,
              ),
            ],
          ),
          TextField(
            controller: _gen1remarksControllers[index],
            decoration: InputDecoration(
              labelText: 'Remarks',
              labelStyle: TextStyle(color: Colors.green[900]),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green[700]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green[900]!),
              ),
            ),
            maxLines: 3,
            onChanged: (text) => _validateFields(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ONLINE EQUIPMENT MAINTENANCE MODULE'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.green[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_Generator1NumberController, 'Generator Number',
                  readOnly: true),
              _buildTextField(_gen1unitController, 'Old', readOnly: false),
              _buildTextField(_gen1dateController, 'Date and Day',
                  readOnly: true),
              _buildTextField(_gen1timeController, 'Timing', readOnly: true),
              _buildTextField(_gen1branchController, 'Branch', readOnly: true),
              SizedBox(height: 20.0),
              ...checklistTitles.asMap().entries.map((entry) {
                int index = entry.key;
                String title = entry.value;
                return Column(
                  children: [
                    _buildChecklistItem(title, index),
                    SizedBox(height: 20.0),
                  ],
                );
              }).toList(),
              Center(
                child: ElevatedButton(
                  onPressed: _isSubmitEnabled ? _handleSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isSubmitEnabled ? Colors.green[700] : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

