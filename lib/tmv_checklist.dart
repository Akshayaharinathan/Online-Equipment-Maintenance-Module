import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Add this import for the Timer
import './dbHelper/mongodbthusma.dart'; // Assume this is your MongoDB database handling file

class TMVChecklistPage extends StatefulWidget {
  @override
  _TMVChecklistPageState createState() => _TMVChecklistPageState();
}

class _TMVChecklistPageState extends State<TMVChecklistPage> {
  final _MVNumberController = TextEditingController(text: 'MV Panel');
  //final _mvunitController = TextEditingController(text: 'MV Panel : Unit-1');
  //final _mvreferenceNumberController =TextEditingController(text: 'Ref Number');
  final _mvdateController = TextEditingController();
  final _mvtimeController = TextEditingController();
  final _mvbranchController = TextEditingController(text: 'THUSMA');
  final _mvremarksControllers =
      List<TextEditingController>.generate(100, (_) => TextEditingController());

  final List<bool> _isYesChecked = List<bool>.generate(100, (_) => false);
  final List<bool> _isNoChecked = List<bool>.generate(100, (_) => false);

  final List<String> checklistTitles = [
    'Panel Room - Clean',
    'Panel Board (Dust free)- Clean',
    'Check the indication lamps working condition in panels',
    'Check all panel meters are working condition',
    'Any abnormal noise in Panel Board',
    'Rubber Mat properly placed both sides of the panels',
    'Any abnormal smell or noise at panels in electrical room.',
    'Check earthing of panel',
    'Check panel cable trench',
    'Check Remote tap changing Panel',
    'Check Tools box with all necessary tools',
    'Check cables - any abnormality',
    'Check Panel Bus Chamber / Cable Temperature',
    'Check the fire extinguishers',
    'Check the fire buckets whether sand is there or not',
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

    _mvdateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _mvtimeController.text = timeFormat.format(now);
  }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        final timeFormat = DateFormat('HH:mm:ss');
        _mvtimeController.text = timeFormat.format(now);
      });
    });
  }

  @override
  void dispose() {
    _MVNumberController.dispose();
    //_mvunitController.dispose();
    //_mvreferenceNumberController.dispose();
    _mvdateController.dispose();
    _mvtimeController.dispose();
    _mvbranchController.dispose();
    for (var controller in _mvremarksControllers) {
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
          _MVNumberController.text.isNotEmpty &&
          //_mvunitController.text.isNotEmpty &&
          //_mvreferenceNumberController.text.isNotEmpty &&
          _mvbranchController.text.isNotEmpty;
    });
  }

  Future<void> _handleSubmit() async {
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm:ss');
    _mvtimeController.text = timeFormat.format(now); // Update time before submission
    await MongoDatabase.connect();
    final checklistData = {
      'MVNumber': _MVNumberController.text,
      //'unit': _mvunitController.text,
      //'referenceNumber': _mvreferenceNumberController.text,
      'date': _mvdateController.text,
      'time': _mvtimeController.text,
      'branch': _mvbranchController.text,
      'checklist': _buildChecklistData(),
    };
    await MongoDatabase.insert(checklistData, 'MV Checklist');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checklist submitted successfully!')));
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      for (var controller in _mvremarksControllers) {
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
        'remarks': _mvremarksControllers[i].text,
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
            controller: _mvremarksControllers[index],
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
              _buildTextField(_MVNumberController, 'MV Panel', readOnly: true),
             // _buildTextField(_mvunitController, 'Unit', readOnly: true),
             // _buildTextField(_mvreferenceNumberController, 'Reference Number',readOnly: true),
              _buildTextField(_mvdateController, 'Date and Day',
                  readOnly: true),
              _buildTextField(_mvtimeController, 'Time', readOnly: true),
              _buildTextField(_mvbranchController, 'Branch', readOnly: true),
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


