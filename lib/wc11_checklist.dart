import 'package:flutter/material.dart';
import './dbHelper/mongodbjsb.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class wc11ChecklistPage extends StatefulWidget {
  @override
  _wc11ChecklistPageState createState() => _wc11ChecklistPageState();
}

class _wc11ChecklistPageState extends State<wc11ChecklistPage> {
  final _WCNumberController = TextEditingController(text: 'Wter chiller 1');
  final _wcunitController = TextEditingController(text: 'Unit 1');

  final _wcdateController = TextEditingController();
  final _wctimeController = TextEditingController();
  final _wcbranchController = TextEditingController(text: 'JSB');
  final _wcremarksControllers =
      List<TextEditingController>.generate(8, (_) => TextEditingController());

  final List<bool> _isYesChecked = List<bool>.generate(8, (_) => false);
  final List<bool> _isNoChecked = List<bool>.generate(8, (_) => false);

  bool _isSubmitEnabled = false; // Add this line to declare the state variable
  Timer? _timer;
  // Define checklist titles directly
  List<String> checklistTitles = [
    'Water Chiller - Clean',
    'Check the working condition of Water Chiller Display',
    'Check chiller parameters Temp /Pressure / % Load',
    'Any abnormal noise or smell in the Chiller',
    'Check earthing of Air Chiller',
    'Check Cable Temperature of chiller',
    'Check cables - any abnormality',
    'Check any Vibration'
  ];
  @override
  void initState() {
    super.initState();
    _initializeDateTime();
    _startTimer(); // Start the timer
    _validateFields();
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd'); // Format for the date
    final timeFormat = DateFormat('HH:mm:ss'); // Format for the time

    _wcdateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _wctimeController.text = timeFormat.format(now);
  }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        final timeFormat = DateFormat('HH:mm:ss');
        _wctimeController.text = timeFormat.format(now);
      });
    });
  }

  @override
  void dispose() {
    _WCNumberController.dispose();
    _wcunitController.dispose();

    _wcdateController.dispose();
    _wctimeController.dispose();
    _wcbranchController.dispose();
    for (var controller in _wcremarksControllers) {
      controller.dispose();
    }
    _timer?.cancel();
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
    bool allFieldsFilled = _WCNumberController.text.isNotEmpty &&
        _wcunitController.text.isNotEmpty &&
        _wcdateController.text.isNotEmpty &&
        _wctimeController.text.isNotEmpty &&
        _wcbranchController.text.isNotEmpty;

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
    await MongoDatabase.connect();
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm:ss');
    _wctimeController.text = timeFormat.format(now);
    final checklistData = {
      'WCNumber': _WCNumberController.text,
      'unit': _wcunitController.text,
      'date': _wcdateController.text,
      'time': _wctimeController.text,
      'branch': _wcbranchController.text,
      'checklist': _buildChecklistData(),
    };
    await MongoDatabase.insert(
        checklistData, 'Waterchiller 1 Unit 1 Checklist');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checklist submitted successfully!')));
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      for (var controller in _wcremarksControllers) {
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
        'remarks': _wcremarksControllers[i].text,
      };
    }
  }

  return checklistData;
}

  String _buildChecklistItemTitle(int index) {
    const titles = [
      'Water Chiller - Clean',
      'Check the working condition of Water Chiller Display',
      'Check chiller parameters Temp /Pressure / % Load',
      'Any abnormal noise or smell in the Chiller',
      'Check earthing of Air Chiller',
      'Check Cable Temperature of chiller',
      'Check cables - any abnormality',
      'Check any Vibration'
    ];
    return titles[index];
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
        readOnly: readOnly,
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
            controller: _wcremarksControllers[index],
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
              _buildTextField(_WCNumberController, 'Water chiller Number',
                  readOnly: true),
              _buildTextField(_wcunitController, 'Unit Number', readOnly: true),
              _buildTextField(_wcdateController, 'Date and Day',
                  readOnly: true),
              _buildTextField(_wctimeController, 'Time', readOnly: true),
              _buildTextField(_wcbranchController, 'Branch', readOnly: true),
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

