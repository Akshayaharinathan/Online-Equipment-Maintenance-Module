import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './dbHelper/mongodbjsb.dart';
import 'dart:async'; // Add this import for the Timer

class acChecklistPage extends StatefulWidget {
  @override
  _acChecklistPageState createState() => _acChecklistPageState();
}

class _acChecklistPageState extends State<acChecklistPage> {
  final _acNumberController = TextEditingController(text: 'Air Chiller');
  //final _acUnitController = TextEditingController(text: 'Air Chiller - 1');
  //final _acReferenceNumberController = TextEditingController(text: 'ccc');
  final _acDateController = TextEditingController();
  final _acTimeController = TextEditingController();
  final _acBranchController = TextEditingController(text: 'JSB');
  final _acRemarksControllers =
      List<TextEditingController>.generate(8, (_) => TextEditingController());

  final List<bool> _isYesChecked = List<bool>.generate(8, (_) => false);
  final List<bool> _isNoChecked = List<bool>.generate(8, (_) => false);

  final List<String> checklistTitles = [
    'Air Chiller - Clean',
    'Check the working condition of Air Chiller Display',
    'Check chiller parameters Temp /Pressure / % Load',
    'Any abnormal noise or smell in Air Chiller',
    'Check earthing of Air Chiller',
    'Check Cable Temperature of chiller',
    'Check cables - any abnormality',
    'Check any Vibration',
  ];

  bool _isSubmitEnabled = false;
  Timer? _timer; // Declare a timer

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
    _validateFields(); // Initial validation check
    _startTimer(); // Start the timer
    _validateFields();
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');
    _acDateController.text =
        '${dateFormat.format(now)} (${DateFormat('EEEE').format(now)})';
    _acTimeController.text = timeFormat.format(now);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        final timeFormat = DateFormat('HH:mm:ss');
        _acTimeController.text = timeFormat.format(now);
      });
    });
  }

  @override
  void dispose() {
    _acNumberController.dispose();
   // _acUnitController.dispose();
    //_acReferenceNumberController.dispose();
    _acDateController.dispose();
    _acTimeController.dispose();
    _acBranchController.dispose();
    for (var controller in _acRemarksControllers) {
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
    bool allItemsFilled = true;

    for (int i = 0; i < checklistTitles.length; i++) {
      if (!_isYesChecked[i] && !_isNoChecked[i]) {
        allItemsFilled = false;
        break;
      }
    }

    setState(() {
      _isSubmitEnabled = allItemsFilled &&
          _acNumberController.text.isNotEmpty &&
         // _acUnitController.text.isNotEmpty &&
         // _acReferenceNumberController.text.isNotEmpty &&
          _acBranchController.text.isNotEmpty;
    });
  }

  Future<void> _handleSubmit() async {
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm:ss');
    _acTimeController.text = timeFormat.format(now); // Update time before submission
    await MongoDatabase.connect();
    final checklistData = {
      'ACNumber': _acNumberController.text,
     // 'unit': _acUnitController.text,
     // 'referenceNumber': _acReferenceNumberController.text,
      'date': _acDateController.text,
      'time': _acTimeController.text,
      'branch': _acBranchController.text,
      'checklist': _buildChecklistData(),
    };
    await MongoDatabase.insert(checklistData, 'Air Chiller Checklist');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checklist submitted successfully!')),
    );
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      for (var controller in _acRemarksControllers) {
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
        'remarks': _acRemarksControllers[i].text,
      };
    }
  }

  return checklistData;
}

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          errorText: controller.text.isEmpty && !readOnly
              ? 'This field is required'
              : null,
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
                activeColor: Colors.red[700],
              ),
            ],
          ),
          TextField(
            controller: _acRemarksControllers[index],
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
              _buildTextField(_acNumberController, 'Air Chiller', readOnly: true),
              //_buildTextField(_acUnitController, 'Unit', readOnly: true),
              //_buildTextField(_acReferenceNumberController, 'Reference Number',readOnly: true),
              _buildTextField(_acDateController, 'Date and Day',
                  readOnly: true),
              _buildTextField(_acTimeController, 'Time', readOnly: true),
              _buildTextField(_acBranchController, 'Branch', readOnly: true),
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

