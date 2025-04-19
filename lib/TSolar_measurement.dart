import 'package:flutter/material.dart';
import './dbHelper/mongodbjsb.dart'; // Ensure this import is correct
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

class TSolarMeasurementPage extends StatefulWidget {
  @override
  _TSolarMeasurementPageState createState() => _TSolarMeasurementPageState();
}

class _TSolarMeasurementPageState extends State<TSolarMeasurementPage> {
  final _transformerNumberController =
      TextEditingController(text: 'Solar Panel');
  final _unitController = TextEditingController(text: '200 KW');
  //final _referenceNumberController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _branchController = TextEditingController(text: 'THUSMA');
  final _outputControllers =
      List.generate(21, (index) => TextEditingController());
  final _output1Controllers =
      List.generate(10, (index) => TextEditingController());
  final _minValues = {
    'check': [
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0
    ]
  };
  final _maxValues = {
    'check': [
      245.0,
      245.0,
      245.0,
      10.0,
      10.0,
      10.0,
      52.0,
      10.0,
      10.0,
      10.0,
      1.0,
      99.99,
      10.0,
      1.0,
      10.0,
      10.0,
      10.0,
      10.0,
      10.0,
      10.0,
      10.0
    ]
  };

  bool _isFormValid = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
    _addListeners();
    _startTimer();
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

  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');
    setState(() {
      _dateController.text =
          dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
      _timeController.text = timeFormat.format(now);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if it's still running
    for (var controller in _outputControllers) {
      controller.dispose(); // Dispose of all controllers
    }
    for (var controller in _output1Controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addListeners() {
    final controllers = [
      ..._outputControllers,
      ..._output1Controllers,
    ];

    for (var controller in controllers) {
      controller.addListener(_validateForm);
    }
  }

  bool _validateNumericFieldGroup(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      final text = controller.text;
      if (text.isEmpty) return false; // Ensure field is not empty

      // Validate the number or allow a hyphen as a valid input
      if (double.tryParse(text) == null && text != '-') {
        print('Validation failed for value: $text'); // Log invalid value
        return false;
      }
    }
    return true;
  }

  bool _validateFieldGroup(
      List<TextEditingController> controllers, List<double> minValues,
      {List<double>? maxValues}) {
    if (controllers.length != minValues.length) {
      return false;
    }

    for (int i = 0; i < controllers.length; i++) {
      final controller = controllers[i];
      final minValue = minValues[i];
      final maxValue = maxValues != null
          ? maxValues[i]
          : double.infinity; // No upper limit if maxValues is null
      final text = controller.text;

      if (text.isEmpty) return false; // Ensure field is not empty

      // Validate the number or allow a hyphen as a valid input
      final number = double.tryParse(text);
      if ((number == null || number < minValue || number > maxValue) &&
          text != '-') {
        print('Validation failed for value: $text'); // Log invalid value
        return false;
      }
    }

    return true;
  }

  void _validateForm() {
    final tableValid = _validateFieldGroup(
      _outputControllers,
      _minValues['check']!,
      maxValues: _maxValues['check'],
    );
    final outValid = _validateNumericFieldGroup(_output1Controllers);

    setState(() {
      _isFormValid = tableValid && outValid;
    });

    // Logging
    print('table Valid: $tableValid');
    print('out Valid: $outValid');
    print('Form Valid: $_isFormValid');
  }

  Future<void> _handleSubmit(BuildContext context) async {
    try {
      await MongoDatabase.connect();
      final uuid = Uuid();
      final measurementData = {
        '_id': uuid.v4(),
        'Panel Name': _transformerNumberController.text,
        'unit': _unitController.text,
        //'referenceNumber': _referenceNumberController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'branch': _branchController.text,
        //'voltage': _outputControllers.sublist(0, 11).map((c) => c.text).toList(),
        //'current': _outputControllers.sublist(11, 22).map((c) => c.text).toList(),
        //'present': _outputControllers.sublist(22, 33).map((c) => c.text).toList(),
        //'cumulativeKWH': _outputControllers.sublist(33, 44).map((c) => c.text).toList(),
        //'cumulativeKVAH': _outputControllers.sublist(44, 55).map((c) => c.text).toList(),
        //'demand': _outputControllers.map((c) => c.text).toList(),
        'Vr': _outputControllers[0].text,
        'Vy': _outputControllers[1].text,
        'Vb': _outputControllers[2].text,
        'Ir': _outputControllers[3].text,
        'Iy': _outputControllers[4].text,
        'Ib': _outputControllers[5].text,
        'Frequency(Hz)': _outputControllers[6].text,
        'Pr KW': _outputControllers[7].text,
        'Pr KVA': _outputControllers[8].text,
        'Pr KVAR': _outputControllers[9].text,
        'Pr P.F': _outputControllers[10].text,
        'Cumulative KWH': _output1Controllers[0].text,
        'TOD-1 KWH': _output1Controllers[1].text,
        'TOD-2 KWH': _output1Controllers[2].text,
        'TOD-4 KWH': _output1Controllers[3].text,
        'TOD-5 KWH': _output1Controllers[4].text,
        'KVARH LAG': _outputControllers[11].text,
        'KVARH LEAD': _outputControllers[12].text,
        'Cumulative KVAH': _output1Controllers[5].text,
        'TOD-1 KVAH': _output1Controllers[6].text,
        'TOD-2 KVAH': _output1Controllers[7].text,
        'TOD-4 KVAH': _output1Controllers[8].text,
        'TOD-5 KVAH': _output1Controllers[9].text,
        'APF': _outputControllers[13].text,
        'KW': _outputControllers[14].text,
        'KW(max)': _outputControllers[15].text,
        'KVA(max)': _outputControllers[16].text,
        'TOD-1 KW': _outputControllers[17].text,
        'TOD-2 KW': _outputControllers[18].text,
        'TOD-4 KW': _outputControllers[19].text,
        'TOD-5 KW': _outputControllers[20].text,
      };
      await MongoDatabase.insert(measurementData, 'Solar Panel Measurement');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Measurement submitted successfully!')));
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit measurement: $e')));
    }
  }

  void _resetForm() {
    for (var controller in [
      ..._outputControllers,
      ..._output1Controllers,
    ]) {
      controller.clear();
    }

    setState(() {
      _isFormValid = false;
    });
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
              _buildTextField(_transformerNumberController, 'Panel',
                  readOnly: true),
              _buildTextField(_unitController, 'Unit', readOnly: true),
              //_buildTextField(_referenceNumberController, 'Reference Number'),
              _buildTextField(_dateController, 'Date and Day', readOnly: true),
              _buildTextField(_timeController, 'Time', readOnly: true),
              _buildTextField(_branchController, 'Branch', readOnly: true),
              SizedBox(height: 20.0),
              _buildSectionHeader('Control Panel'),
              _buildVoltageTable(),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _isFormValid ? () => _handleSubmit(context) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isFormValid ? Colors.green[700] : Colors.grey,
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

  /* Widget _buildTextField(TextEditingController controller, String labelText, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }*/
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF2D293), // Light Gold
            Color(0xFFD7CF85), // Light Olive
            Color(0xFF9DC866), // Light Green
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildVoltageTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Vr'),
            _buildTableCell(_outputControllers[0], 0, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Vy'),
            _buildTableCell(_outputControllers[1], 1, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Vb'),
            _buildTableCell(_outputControllers[2], 2, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Ir'),
            _buildTableCell(_outputControllers[3], 3, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Iy'),
            _buildTableCell(_outputControllers[4], 4, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Ib'),
            _buildTableCell(_outputControllers[5], 5, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Frequency(Hz)'),
            _buildTableCell(_outputControllers[6], 6, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Pr KW'),
            _buildTableCell(_outputControllers[7], 7, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Pr KVA'),
            _buildTableCell(_outputControllers[8], 8, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Pr KVAR'),
            _buildTableCell(_outputControllers[9], 9, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Pr P.F'),
            _buildTableCell(_outputControllers[10], 10, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Cumulative KWH'),
            _buildTableCell(_output1Controllers[0], 0, 'chk'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-1 KWH'),
            _buildTableCell(_output1Controllers[1], 1, 'chk'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-2 KWH'),
            _buildTableCell(_output1Controllers[2], 2, 'chk'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-4 KWH'),
            _buildTableCell(_output1Controllers[3], 3, 'chk'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-5 KWH'),
            _buildTableCell(_output1Controllers[4], 4, 'chk'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('KVARH LAG'),
            _buildTableCell(_outputControllers[11], 11, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('KVARH LEAD'),
            _buildTableCell(_outputControllers[12], 12, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Cumulative KVAH'),
            _buildTableCell(_output1Controllers[5], 5, 'chk'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-1 KVAH'),
            _buildTableCell(_output1Controllers[6], 6, 'chk'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-2 KVAH'),
            _buildTableCell(_output1Controllers[7], 7, 'chk'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-4 KVAH'),
            _buildTableCell(_output1Controllers[8], 8, 'chk'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-5 KVAH'),
            _buildTableCell(_output1Controllers[9], 9, 'chk'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('APF'),
            _buildTableCell(_outputControllers[13], 13, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('KW'),
            _buildTableCell(_outputControllers[14], 14, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('KW(max)'),
            _buildTableCell(_outputControllers[15], 15, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('KVA(max)'),
            _buildTableCell(_outputControllers[16], 16, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-1 KW'),
            _buildTableCell(_outputControllers[17], 17, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-2 KW'),
            _buildTableCell(_outputControllers[18], 18, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-4 KW'),
            _buildTableCell(_outputControllers[19], 19, 'check'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('TOD-5 KW'),
            _buildTableCell(_outputControllers[20], 20, 'check'),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.green[200],
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTableCell(
      TextEditingController controller, int index, String type) {
    bool isValid = true;
    String? errorMessage;

    // Determine the min and max values based on the type and index
    double minValue = _minValues[type]?[index] ?? 0.0;
    double maxValue = _maxValues[type]?[index] ?? double.infinity;

    // Check if the value is within the valid range
    if (controller.text.isNotEmpty) {
      String text = controller.text;

      // Allow hyphen as a valid input (e.g., for negative numbers)
      if (text == '-') {
        isValid = true;
      } else {
        double? value = double.tryParse(text);
        if (value == null || value < minValue || value > maxValue) {
          isValid = false;
          errorMessage = 'Enter a valid value between $minValue and $maxValue';
        }
      }
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: isValid ? Colors.black : Colors.red),
            ),
            filled: true,
            fillColor: Colors.white54,
            errorText: isValid ? null : errorMessage,
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(
                r'^-?\d*\.?\d*$')), // Allow numbers with optional decimal point
            LengthLimitingTextInputFormatter(
                10), // Adjust the length limit as needed
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: readOnly
            ? TextInputType.text
            : TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          if (!readOnly) FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
        ],
      ),
    );
  }
}

