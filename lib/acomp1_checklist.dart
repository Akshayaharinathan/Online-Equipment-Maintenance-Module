import 'package:flutter/material.dart';
import './dbHelper/mongodbjsb.dart';
import 'package:intl/intl.dart'; // Ensure this import is correct
import 'dart:async'; // Add this import for the Timer
class acomp1ChecklistPage extends StatefulWidget {
  @override
  _acomp1ChecklistPageState createState() => _acomp1ChecklistPageState();
}

class _acomp1ChecklistPageState extends State<acomp1ChecklistPage> {
  final _ACOMP2NumberController =
      TextEditingController(text: 'Air Compressor 1');
  final _acomp2unitController =
      TextEditingController(text: '7.5 KW');
  //final _acomp2referenceNumberController =TextEditingController(text: 'reference');
  final _acomp2dateController = TextEditingController();
  final _acomp2timeController = TextEditingController();
  final _acomp2branchController = TextEditingController(text: 'JSB');
  final _acomp2remarksControllers =
      List<TextEditingController>.generate(100, (_) => TextEditingController());

  final List<bool> _isYesChecked = List<bool>.generate(100, (_) => false);
  final List<bool> _isNoChecked = List<bool>.generate(100, (_) => false);

  final List<String> checklistTitles = [
    'Air Compressor - Clean',
    'Check the working condition of Air Compressor Display',
    'Check Air compressor display parameters',
    'Any abnormal noise or smell in Air Compressor',
    'Check earthing of Air Compressor',
    'Check Cable Temperature',
    'Check cables - any abnormality',
    'Check any Vibration',
  ];

  bool _isSubmitEnabled = false;
  Timer? _timer; // Declare a timer

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

    _acomp2dateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _acomp2timeController.text = timeFormat.format(now);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        final timeFormat = DateFormat('HH:mm:ss');
        _acomp2timeController.text = timeFormat.format(now);
      });
    });
  }


  

  @override
  void dispose() {
    _ACOMP2NumberController.dispose();
    _acomp2unitController.dispose();
    //_acomp2referenceNumberController.dispose();
    _acomp2dateController.dispose();
    _acomp2timeController.dispose();
    _acomp2branchController.dispose();
    for (var controller in _acomp2remarksControllers) {
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
          _ACOMP2NumberController.text.isNotEmpty &&
          _acomp2unitController.text.isNotEmpty &&
          //_acomp2referenceNumberController.text.isNotEmpty &&
          _acomp2branchController.text.isNotEmpty;
    });
  }

  Future<void> _handleSubmit() async {

    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm:ss');
    _acomp2timeController.text = timeFormat.format(now); // Update time before submission
    
    
    
    await MongoDatabase.connect();
    final checklistData = {
      'ACompNumber': _ACOMP2NumberController.text,
      'unit': _acomp2unitController.text,
     // 'referenceNumber': _acomp2referenceNumberController.text,
      'date': _acomp2dateController.text,
      'time': _acomp2timeController.text,
      'branch': _acomp2branchController.text,
      'checklist': _buildChecklistData(),
    };
    await MongoDatabase.insert(checklistData, 'Air Compressor Unit 1 Checklist');
    //await MongoDatabase.exportToExcel(checklistData,'Air Compressor Unit 1 Checklist' );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checklist submitted successfully!')),
    );
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      for (var controller in _acomp2remarksControllers) {
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
        'remarks': _acomp2remarksControllers[i].text,
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
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Text('Yes',
                  style: TextStyle(fontSize: 16.0, color: Colors.black)),
              Checkbox(
                value: _isYesChecked[index],
                onChanged: (value) => _handleYesChanged(index, value),
                activeColor: Colors.green[700],
              ),
              SizedBox(width: 20.0),
              Text('No', style: TextStyle(fontSize: 16.0, color: Colors.black)),
              Checkbox(
                value: _isNoChecked[index],
                onChanged: (value) => _handleNoChanged(index, value),
                activeColor: Colors.red[700],
              ),
            ],
          ),
          TextField(
            controller: _acomp2remarksControllers[index],
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
              _buildTextField(_ACOMP2NumberController, 'Air Compressor', readOnly: true),
              _buildTextField(_acomp2unitController, 'Unit', readOnly: true),
             // _buildTextField(_acomp2referenceNumberController, 'Reference Number',readOnly: true),
              _buildTextField(_acomp2dateController, 'Date and Day',
                  readOnly: true),
              _buildTextField(_acomp2timeController, 'Time', readOnly: true),
              _buildTextField(_acomp2branchController, 'Branch',
                  readOnly: true),
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

