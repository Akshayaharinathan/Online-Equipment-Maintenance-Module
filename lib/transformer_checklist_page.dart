import 'package:flutter/material.dart';
import './dbHelper/mongodbjsb.dart'; // Ensure this import is correct
import 'package:intl/intl.dart';
import 'dart:async'; // Add this import for the Timer

class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final _transformerNumberController = TextEditingController(text: 'Transformer-1250KVA');
  final _unitController = TextEditingController(text: '3 Phase');
  final _referenceNumberController = TextEditingController(text: '430V');
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _branchController = TextEditingController(text: 'JSB');
  final _remarksControllers =
      List<TextEditingController>.generate(12, (_) => TextEditingController());

  final List<String> checklistTitles = [
    'Transformer Yard - Clean',
    'Transformer - Clean',
    'Transformer Marshalling Box - Cleanliness',
    'Abnormal noise in the Transformer',
    'Oil Leakage in the Transformer',
    'Silica Gel Condition (Blue-safe, Pink-unsafe)',
    'Check Transformer Temperature in HV/LV Terminals',
    'Check VCB working condition',
    'Transformer Cable - any Abnormality',
    'Check Body Earthing, Neutral Earthing & Surge Arrester of the transformer for any loose connection',
    'Check the Fire Extinguishers',
    'Check Fire Buckets whether sand is there or not'
  ];

  final List<bool> _isYesChecked = List<bool>.generate(12, (_) => false);
  final List<bool> _isNoChecked = List<bool>.generate(12, (_) => false);
  bool _isSubmitEnabled = false;
  Timer? _timer; // Declare a timer


  @override
  void dispose() {
    _transformerNumberController.dispose();
    _unitController.dispose();
    _referenceNumberController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _branchController.dispose();
    for (var controller in _remarksControllers) {
      controller.dispose();
    }
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
    _startTimer(); // Start the timer
    _validateFields();
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');
    _dateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _timeController.text = timeFormat.format(now);
  }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        final timeFormat = DateFormat('HH:mm:ss');
        _timeController.text = timeFormat.format(now);
      });
    });
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
    bool allFieldsFilled = _transformerNumberController.text.isNotEmpty &&
        _unitController.text.isNotEmpty &&
        _referenceNumberController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty &&
        _branchController.text.isNotEmpty;

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
    _timeController.text = timeFormat.format(now); // Update time before submission
    await MongoDatabase.connect();
    final checklistData = {
      'transformerNumber': _transformerNumberController.text,
      'phase': _unitController.text,
      'spec': _referenceNumberController.text,
      'date': _dateController.text,
      'time': _timeController.text,
      'branch': _branchController.text,
      'checklist': _buildChecklistData(),
    };
    await MongoDatabase.insert(checklistData, 'Transformer Checklist');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checklist submitted successfully!')));
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      for (var controller in _remarksControllers) {
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
        'remarks': _remarksControllers[i].text,
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
            controller: _remarksControllers[index],
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
              _buildTextField(
                  _transformerNumberController, 'Transformer Number',readOnly: true),
              _buildTextField(_unitController, 'Phase', readOnly: true),
              _buildTextField(_referenceNumberController, 'Spec',readOnly: true),
              _buildTextField(_dateController, 'Date and Day', readOnly: true),
              _buildTextField(_timeController, 'Timing', readOnly: true),
              _buildTextField(_branchController, 'Branch', readOnly: true),
              SizedBox(height: 20.0),
              for (int i = 0; i < checklistTitles.length; i++) ...[
                _buildChecklistItem(checklistTitles[i], i),
                SizedBox(height: 20.0),
              ],
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

