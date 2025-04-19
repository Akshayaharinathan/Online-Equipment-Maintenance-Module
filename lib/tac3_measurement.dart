import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './dbHelper/mongodbthusma.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

class Tac3MeasurementPage extends StatefulWidget {
  @override
  _Tac3MeasurementPageState createState() => _Tac3MeasurementPageState();
}

class _Tac3MeasurementPageState extends State<Tac3MeasurementPage> {
  final TextEditingController _ACMNumberController = TextEditingController(text:'Air Chiller 2');
  final TextEditingController _acmunitController = TextEditingController(text:'46.83 KW');
  //final TextEditingController _acmreferenceNumberController = TextEditingController();
  final TextEditingController _acmdateController = TextEditingController();
  final TextEditingController _acmtimeController = TextEditingController();
  final TextEditingController _acmbranchController = TextEditingController(text:'JSB');
  final  _acmoutputControllers =List.generate(9, (_) => TextEditingController());
  final  _outputControllers =List.generate(1, (_) => TextEditingController());

  final _minValues = {
    'out': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
  };
  final _maxValues = {
    'out': [50.0, 20.0, 100.0, 100.0, 50.0, 100.0, 100.0, 100.0, 20.0],
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
        _acmtimeController.text = timeFormat.format(now);
      });
    });
  }
  @override
void dispose() {
  // Dispose all the controllers
  _ACMNumberController.dispose();
  _acmdateController.dispose();
  _acmtimeController.dispose();
  _acmbranchController.dispose();
  
  for (var controller in _acmoutputControllers) {
    controller.dispose();
  }
  
  for (var controller in _outputControllers) {
    controller.dispose();
  }

  // Cancel the timer if it's running
  _timer?.cancel();

  super.dispose();
}



  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');

    _acmdateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _acmtimeController.text = timeFormat.format(now);
  }

  void _addListeners() {
    final controllers = [
      ..._acmoutputControllers,
      ..._outputControllers,
    ];

    for (var controller in controllers) {
      controller.addListener(_validateForm);
    }
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

  void _validateForm() {
    final outValid = _validateFieldGroup(
      _acmoutputControllers,
      _minValues['out']!,
      maxValues: _maxValues['out'],
    );
    final outputValid =
        _validateNumericFieldGroup(_outputControllers);

    setState(() {
      _isFormValid = outValid &&
          outputValid;
    });

    // Logging
    print('Volt Valid: $outValid');
    print('Temp Valid: $outputValid');
    print('Form Valid: $_isFormValid');
  }


  Future<void> _handleSubmit(BuildContext context) async {
    try {
      await MongoDatabase.connect();
      final uuid = Uuid();
      final measurementData = {
        '_id': uuid.v4(),
        'AirChillerNumber': _ACMNumberController.text,
        'unit': _acmunitController.text,
        //'referenceNumber': _acmreferenceNumberController.text,
        'date': _acmdateController.text,
        'time': _acmtimeController.text,
        'branch': _acmbranchController.text,
        'Chiller Water Inlet Temp(c)': _acmoutputControllers[0].text,
        'Chiller Water Outlet Temp in Celsius': _acmoutputControllers[1].text,
        'Air Suction Temp in Celsius': _acmoutputControllers[2].text,
        'Air Discharge Temp in Celsius': _acmoutputControllers[3].text,
        'Compressor 1 Current (A)': _acmoutputControllers[4].text,
        'Air Suction Pressure (PSI)': _acmoutputControllers[5].text,
        'Air Suction Discharge (PSI)': _acmoutputControllers[6].text,
        'Compressor 1 Load (% Load)': _acmoutputControllers[7].text,
        'Set Temp': _acmoutputControllers[8].text,
        'Running Hours': _outputControllers[0].text,
      };
      await MongoDatabase.insert(measurementData, 'Air Chiller 2 Measurement');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Measurement submitted successfully!')));
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit measurement: $e')));
    }
  }

   void _resetForm() {
    setState(() {
      for (var controller in [
        ..._acmoutputControllers,
        ..._outputControllers
      ]) {
        controller.clear();
      }
      _isFormValid = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Equipment Maintenance Module'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.green[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_acmunitController, 'Unit', readOnly: true),
              _buildTextField(_ACMNumberController, 'Air Chiller', readOnly: true),
              
             // _buildTextField(_acmreferenceNumberController, 'Reference Number', readOnly: true),
              _buildTextField(_acmdateController, 'Date and Day',
                  readOnly: true),
              _buildTextField(_acmtimeController, 'Time', readOnly: true),
              _buildTextField(_acmbranchController, 'Branch', readOnly: true),
              SizedBox(height: 20.0),
              _buildSectionHeader('Measurement Inputs'),
              _buildOutputTable(),
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

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF2D293),
            Color(0xFFD7CF85),
            Color(0xFF9DC866),
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

  Widget _buildOutputTable() {
    return Column(
      children: [
         Row(
          children: [
            _buildTableHeaderCell('Chiller Water Inlet Temp (°C)'),
            _buildTableCell(_acmoutputControllers[0],0,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Chiller Water Outlet Temp (°C)'),
            _buildTableCell(_acmoutputControllers[1],1,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Air Suction Temp (°C)'),
            _buildTableCell(_acmoutputControllers[2],2,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Air Discharge Temp (°C)'),
            _buildTableCell(_acmoutputControllers[3],3,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Compressor 1 Current (A)'),
            _buildTableCell(_acmoutputControllers[4],4,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Air Suction Pressure (PSI)'),
            _buildTableCell(_acmoutputControllers[5],5,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Air Suction Discharge (PSI)'),
            _buildTableCell(_acmoutputControllers[6],6,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Compressor 1 Load (% Load)'),
            _buildTableCell(_acmoutputControllers[7],7,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Set Temp'),
            _buildTableCell(_acmoutputControllers[8],8,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Running Hours'),
            _buildTableCell(_outputControllers[0],0,'acmout'),
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

