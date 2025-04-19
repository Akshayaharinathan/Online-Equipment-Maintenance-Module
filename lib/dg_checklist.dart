import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './dbHelper/mongodbjsb.dart'; 
import 'dart:async';// Make sure to import your MongoDB connection and operations file

class DGChecklistPage extends StatefulWidget {
  @override
  _DGChecklistPageState createState() => _DGChecklistPageState();
}

class _DGChecklistPageState extends State<DGChecklistPage> {
  final _DGNumberController = TextEditingController(text: 'DG Panel');
  //final _dgunitController = TextEditingController(text: 'DG : Unit - 1');
  //final _dgreferenceNumberController =TextEditingController(text: 'Ref Number');
  final _dgdateController = TextEditingController();
  final _dgtimeController = TextEditingController();
  final _dgbranchController = TextEditingController(text: 'JSB');
  final _dgremarksControllers =
      List<TextEditingController>.generate(13, (_) => TextEditingController());

  final List<bool> _isYesChecked = List<bool>.generate(13, (_) => false);
  final List<bool> _isNoChecked = List<bool>.generate(13, (_) => false);

  final List<String> checklistTitles = [
    'Panel Room - Clean',
    'Panel Board (Dust Free) - Clean',
    'Check the indication lamps working condition in panels',
    'Check all panel meters are working condition',
    'Any abnormal noise in Panel Board',
    'Rubber Mat properly placed both sides of the panels',
    'Any abnormal smell or noise at panels in electrical room',
    'Check earthing of panel',
    'Check panel Cable trench',
    'Check cables - any abnormality',
    'Check Panel Bus Chamber / Cable Temperature',
    'Check Fire Extinguishers',
    'Check the fire buckets whether sand is there or not'
  ];

  bool _isSubmitEnabled = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
    _startTimer();
    _validateFields();
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd'); // Format for the date
    final timeFormat = DateFormat('HH:mm:ss'); // Format for the time

    _dgdateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _dgtimeController.text = timeFormat.format(now);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        final timeFormat = DateFormat('HH:mm:ss');
        _dgtimeController
        .text = timeFormat.format(now);
      });
    });
  }

  @override
  void dispose() {
    _DGNumberController.dispose();
    //_dgunitController.dispose();
    //_dgreferenceNumberController.dispose();
    _dgdateController.dispose();
    _dgtimeController.dispose();
    _dgbranchController.dispose();
    for (var controller in _dgremarksControllers) {
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
    bool allItemsFilled = true;

    for (int i = 0; i < checklistTitles.length; i++) {
      if (!_isYesChecked[i] && !_isNoChecked[i]) {
        allItemsFilled = false;
        break;
      }
    }

    setState(() {
      _isSubmitEnabled = allItemsFilled &&
          _DGNumberController.text.isNotEmpty &&
          //_dgunitController.text.isNotEmpty &&
          //_dgreferenceNumberController.text.isNotEmpty &&
          _dgbranchController.text.isNotEmpty;
    });
  }

  Future<void> _handleSubmit() async {
    await MongoDatabase.connect();
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm:ss');
    _dgtimeController.text = timeFormat.format(now);
    final checklistData = {
      'DGNumber': _DGNumberController.text,
      //'unit': _dgunitController.text,
      //'referenceNumber': _dgreferenceNumberController.text,
      'date': _dgdateController.text,
      'time': _dgtimeController.text,
      'branch': _dgbranchController.text,
      'checklist': _buildChecklistData(),
    };
    await MongoDatabase.insert(checklistData, 'DG Checklist');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checklist submitted successfully!')));
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      for (var controller in _dgremarksControllers) {
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
        'remarks': _dgremarksControllers[i].text,
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
            controller: _dgremarksControllers[index],
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
              _buildTextField(_DGNumberController, 'DG Panel', readOnly: true),
              //_buildTextField(_dgunitController, 'Unit', readOnly: true),
              //_buildTextField(_dgreferenceNumberController, 'Reference Number',readOnly: true),
              _buildTextField(_dgdateController, 'Date and Day',
                  readOnly: true),
              _buildTextField(_dgtimeController, 'Timing', readOnly: true),
              _buildTextField(_dgbranchController, 'Branch', readOnly: true),
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

