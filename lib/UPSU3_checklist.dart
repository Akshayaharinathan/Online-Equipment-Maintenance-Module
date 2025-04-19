import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './dbHelper/mongodbjsb.dart'; // Ensure this import is correct
import 'dart:async'; // Add this import for the Timer

class UPSU3ChecklistPage extends StatefulWidget {
  @override
  _UPSU3ChecklistPageState createState() => _UPSU3ChecklistPageState();
}

class _UPSU3ChecklistPageState extends State<UPSU3ChecklistPage> {
  final _upsu1NumberController = TextEditingController(text: 'UPS-400kva');
  final _upsu1unitController = TextEditingController(text: 'unit 2');
  final _upsu1dateController = TextEditingController();
  final _upsu1timeController = TextEditingController();
  final _upsu1branchController = TextEditingController(text: 'JSB');
  final _upsu1remarksControllers =
      List<TextEditingController>.generate(13, (_) => TextEditingController());

  final List<bool> _isYesChecked = List<bool>.generate(13, (_) => false);
  final List<bool> _isNoChecked = List<bool>.generate(13, (_) => false);
  bool _isSubmitEnabled = false;
  Timer? _timer; // Declare a timer

  

  List<String> checklistTitles = [
    'UPS Room - Clean',
    'UPS Room Temperature - Appropriate',
    'HVAC system properly working',
    'Check the working condition of UPS Display',
    'Check Battery Terminals free from fungus',
    'Check Battery Voltage',
    'Check Battery Backup indication',
    'Any abnormal noise/ smell in UPS',
    'Check Cable Temperature',
    'Check cables - any abnormality',
    'Rubber Mat properly placed both sides',
    'Check earthing of UPS',
    'Check Fire Extinguisher - Near by'
  ];

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
    _validateFields();
     _startTimer(); // Start the timer
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd'); // Format for the date
    final timeFormat = DateFormat('HH:mm:ss'); // Format for the time

    _upsu1dateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _upsu1timeController.text = timeFormat.format(now);
  }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        final timeFormat = DateFormat('HH:mm:ss');
        _upsu1timeController.text = timeFormat.format(now);
      });
    });
  }
  @override
  void dispose() {
    _upsu1NumberController.dispose();
    _upsu1unitController.dispose();

    _upsu1dateController.dispose();
    _upsu1timeController.dispose();
    _upsu1branchController.dispose();
    for (var controller in _upsu1remarksControllers) {
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
      _validateFields(); // Validate fields after checkbox change
    });
  }

  void _handleNoChanged(int index, bool? value) {
    setState(() {
      _isNoChecked[index] = value ?? false;
      if (_isNoChecked[index]) {
        _isYesChecked[index] = false;
      }
      _validateFields(); // Validate fields after checkbox change
    });
  }

  void _validateFields() {
    bool allChecklistItemsValid =
        checklistTitles.asMap().entries.every((entry) {
      int index = entry.key;
      return _isYesChecked[index] || _isNoChecked[index];
    });

    setState(() {
      _isSubmitEnabled = allChecklistItemsValid;
    });
  }

  Future<void> _handleSubmit() async {
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm:ss');
    _upsu1timeController.text = timeFormat.format(now); // Update time before submission

    await MongoDatabase.connect();
    final checklistData = {
      'ups u3 Number': _upsu1NumberController.text,
      'unit': _upsu1unitController.text,
      'date': _upsu1dateController.text,
      'time': _upsu1timeController.text,
      'branch': _upsu1branchController.text,
      'checklist': _buildChecklistData(),
    };
    await MongoDatabase.insert(checklistData, 'UPS 2 Unit 2 Checklist');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checklist submitted successfully!')));
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      for (var controller in _upsu1remarksControllers) {
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
        'remarks': _upsu1remarksControllers[i].text,
      };
    }
  }

  return checklistData;
}

  /*String _buildChecklistItemTitle(int index) {
    // Define titles for checklist items
    const titles = [
      'UPS Room - Clean',
      'UPS Room Temperature - Clean',
      'HVAC system properly working - Leakage',
      'Check the working condition of UPS Display',
      'Check Battery Terminals free from fungus',
      'Check Battery Voltage',
      'Check Battery Backup indication',
      'Any abnormal noise/ smell in UPS',
      'Check Cable Temperature',
      'Check cables - any abnormality',
      'Rubber Mat properly placed both sides',
      'Check earthing of UPS',
      'Check Fire Extinguisher - Near by'
    ];
    return titles[index];
  }*/

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
            controller: _upsu1remarksControllers[index],
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
              _buildTextField(_upsu1NumberController, 'UPS Number',
                  readOnly: true),
              _buildTextField(_upsu1unitController, 'Unit', readOnly: true),
              _buildTextField(_upsu1dateController, 'Date and Day',
                  readOnly: true),
              _buildTextField(_upsu1timeController, 'Time', readOnly: true),
              _buildTextField(_upsu1branchController, 'Branch', readOnly: true),
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

