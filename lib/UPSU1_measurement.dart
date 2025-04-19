import 'package:flutter/material.dart';
import './dbHelper/mongodbjsb.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // Add this impor

class UPSU1MeasurementPage extends StatefulWidget {
  @override
  _UPSU1MeasurementPageState createState() => _UPSU1MeasurementPageState();
}

class _UPSU1MeasurementPageState extends State<UPSU1MeasurementPage> {
  final TextEditingController _UPSmNumberController =
      TextEditingController(text: 'UPS-200kva');
  final TextEditingController _upsmunitController =
      TextEditingController(text: 'unit 1');

  final TextEditingController _upsmdateController = TextEditingController();
  final TextEditingController _upsmtimeController = TextEditingController();
  final TextEditingController _upsmbranchController =
      TextEditingController(text: 'JSB');

  final  _upsmoutputControllers = List.generate(12, (_) => TextEditingController()); // Ensure 14 controllers

  // Ensure 6 controllers

  final _upsminverterControllers =List.generate(4, (_) => TextEditingController());
  final _upsmbatteryControllers =List.generate(3, (_) => TextEditingController());
  final _upsmrectControllers =List.generate(6, (_) => TextEditingController());
  final _outputControllers =List.generate(2, (_) => TextEditingController());
  final _upsmpowerControllers =List.generate(7, (_) => TextEditingController());
  final _upsmbypassControllers =List.generate(4, (_) => TextEditingController()); // Ensure 13 controllers
  //final _upsmbatControllers =List.generate(2, (_) => TextEditingController()); // Ensure 13 controllers

  final _minValues = {
    'out': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    'inv':[0.0, 0.0, 0.0, 0.0],
    'rect':[0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    'bat':[0.0, 0.0, 0.0],
    'pow':[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    'bypass':[0.0, 0.0, 0.0, 0.0],
  };
  final _maxValues = {
    'out': [440.0, 415.0, 415.0, 250.0, 240.0, 240.0, 150.0, 51.0, 300.0, 200.0, 200.0, 2.0],
    'pow':[100.0, 50.0, 50.0, 50.0, 50.0, 50.0, 1.0],
    'inv':[440.0, 415.0, 415.0, 100.0],
    'bat':[450.0, 10.0, 25.0],
    'rect':[450.0, 433.0, 433.0, 450.0, 300.0, 50.0],
    'bypass':[450.0, 433.0, 433.0, 50.0],
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
        _upsmtimeController.text = timeFormat.format(now);
      });
    });
  }

  @override
void dispose() {
  // Dispose all controllers to free up resources
  _UPSmNumberController.dispose();
  _upsmunitController.dispose();
  _upsmdateController.dispose();
  _upsmtimeController.dispose();
  _upsmbranchController.dispose();
  
  for (var controller in [
    ..._upsmoutputControllers,
    ..._outputControllers,
    ..._upsmpowerControllers,
    ..._upsminverterControllers,
    ..._upsmbatteryControllers,
    ..._upsmrectControllers,
    ..._upsmbypassControllers,
  ]) {
    controller.dispose();
  }

  // Cancel the timer if it's still active
  _timer?.cancel();

  super.dispose();
}


  


  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');

    _upsmdateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _upsmtimeController.text = timeFormat.format(now);
  }

  void _addListeners() {
    final controllers = [
      ..._upsmoutputControllers,
      ..._upsmpowerControllers,
      ..._outputControllers,
      ..._upsminverterControllers,
      ..._upsmbatteryControllers,
     // ..._upsmbatControllers,
      ..._upsmrectControllers,
      ..._upsmbypassControllers,
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
      _upsmoutputControllers,
      _minValues['out']!,
      maxValues: _maxValues['out'],
    );
    final powValid = _validateFieldGroup(
      _upsmpowerControllers,
      _minValues['pow']!,
      maxValues: _maxValues['pow'],
    );
    final invValid = _validateFieldGroup(
      _upsminverterControllers,
      _minValues['inv']!,
      maxValues: _maxValues['inv'],
    );
    final rectValid = _validateFieldGroup(
      _upsmrectControllers,
      _minValues['rect']!,
      maxValues: _maxValues['rect'],
    );
    final batValid = _validateFieldGroup(
      _upsmbatteryControllers,
      _minValues['bat']!,
      maxValues: _maxValues['bat'],
    );
    final bypassValid = _validateFieldGroup(
      _upsmbypassControllers,
      _minValues['bypass']!,
      maxValues: _maxValues['bypass'],
    );
    final outputValid =_validateNumericFieldGroup(_outputControllers);

    setState(() {
      _isFormValid = outValid &&
          powValid &&
          rectValid &&
          batValid &&
          invValid &&
          bypassValid &&
          outputValid;
    });

    // Logging
    print('out Valid: $outValid');
    print('output Valid: $outputValid');
    print('pow Valid: $powValid');
    print('bat Valid: $batValid');
    print('bypass Valid: $bypassValid');
    print('inv Valid: $invValid');
    print('rect Valid: $rectValid');
    print('Form Valid: $_isFormValid');
  }


  Future<void> _handleSubmit() async {
    try {
      await MongoDatabase.connect();
      final measurementData = {
        'UPS Number': _UPSmNumberController.text,
        'Unit': _upsmunitController.text,
        'Date and Day': _upsmdateController.text,
        'Time': _upsmtimeController.text,
        'Branch': _upsmbranchController.text,

        'UPS System Output': {
          'V12': _upsmoutputControllers[0].text,
          'V23': _upsmoutputControllers[1].text,
          'V31': _upsmoutputControllers[2].text,
          'V1': _upsmoutputControllers[3].text,
          'V2': _upsmoutputControllers[4].text,
          'V3': _upsmoutputControllers[5].text,
          'S(KVA)': _upsmoutputControllers[6].text,
          'Freq(HZ)': _upsmoutputControllers[7].text,
          'I1': _upsmoutputControllers[8].text,
          'I2': _upsmoutputControllers[9].text,
          'I3': _upsmoutputControllers[10].text,
          'CF': _upsmoutputControllers[11].text,
          'Load Rate (%)': _outputControllers[0].text,
          'Room Temp in Celsius': _outputControllers[1].text,
        },
        'UPS System Output Power': {
          'L1 Pa(KW)': _upsmpowerControllers[0].text,
          'L1 S(KVA)': _upsmpowerControllers[1].text,
          'L2 Pa(KW)': _upsmpowerControllers[2].text,
          'L2 S(KVA)': _upsmpowerControllers[3].text,
          'L3 Pa(KW)': _upsmpowerControllers[4].text,
          'L3 S(KVA)': _upsmpowerControllers[5].text,
          'Power factor': _upsmpowerControllers[6].text,
        },
        'Inverter Measurements': {
          'V12': _upsminverterControllers[0].text,
          'V23': _upsminverterControllers[1].text,
          'V31': _upsminverterControllers[2].text,
          'Freq (HZ)': _upsminverterControllers[3].text,
        },
        'Battery Measurements': {
          'V bat': _upsmbatteryControllers[0].text,
          'I bat': _upsmbatteryControllers[1].text,
          'T bat': _upsmbatteryControllers[2].text,
        },
        'Rectifier Measurements': {
          'V12': _upsmrectControllers[0].text,
          'V23': _upsmrectControllers[1].text,
          'V31': _upsmrectControllers[2].text,
          'V dc': _upsmrectControllers[3].text,
          'I dc': _upsmrectControllers[4].text,
          'Freq': _upsmrectControllers[5].text,
        },
        'Bypass Measurements': {
          'V12': _upsmbypassControllers[0].text,
          'V23': _upsmbypassControllers[1].text,
          'V31': _upsmbypassControllers[2].text,
          'Freq': _upsmbypassControllers[3].text,
        },
        
        //'Frequency': _frequencyController.text,
        //'PowerFactor': _powerFactorController.text,
      };

      await MongoDatabase.insert(measurementData, 'UPS 1 Unit 1 Measurement');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Measurement submitted successfully!')));
      _resetForm();
    } catch (e) {
      print('Error occurred: $e'); // Print the error message to the console
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit measurement')));
    }
  }

  void _resetForm() {
    setState(() {
      // Clear all specific controllers

      // Clear all lists of controllers
      for (var controller in [
        ..._upsmoutputControllers,
        ..._outputControllers,
        ..._upsmpowerControllers,
        ..._upsminverterControllers,
        ..._upsmbatteryControllers,
        //..._upsmbatControllers,
        ..._upsmrectControllers,
        ..._upsmbypassControllers,
        // Use spread operator here
      ]) {
        controller.clear();
      }

      // Reset form validity status
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
              _buildTextField(_UPSmNumberController, 'UPS Number',
                  readOnly: true),
              _buildTextField(_upsmunitController, 'Unit', readOnly: true),
              _buildTextField(_upsmdateController, 'Date and Day',
                  readOnly: true),
              _buildTextField(_upsmtimeController, 'Time', readOnly: true),
              _buildTextField(_upsmbranchController, 'Branch', readOnly: true),
              SizedBox(height: 20.0),
              _buildSectionHeader('MEASUREMENTS : UPS SYSTEM OUTPUT'),
              _buildOutputTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('MEASUREMENTS : UPS SYSTEM OUTPUT POW'),
              _buildOutputpowTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('INVERTER MEASUREMENTS'),
              _buildInverterTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('BATTERY MEASUREMENTS'),
              _buildBatteryTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('RECTIFIER MEASUREMENTS'),
              _buildRectifierTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('BYPASS MEASUREMENTS'),
              _buildBypassTable(),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _isFormValid ? _handleSubmit : null,
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

  Widget _buildOutputTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('V12'),
            _buildTableCell(_upsmoutputControllers[0],0,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V23'),
            _buildTableCell(_upsmoutputControllers[1],1,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V31'),
            _buildTableCell(_upsmoutputControllers[2],2,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V1'),
            _buildTableCell(_upsmoutputControllers[3],3,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V2'),
            _buildTableCell(_upsmoutputControllers[4],4,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V3'),
            _buildTableCell(_upsmoutputControllers[5],5,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('S(KVA)'),
            _buildTableCell(_upsmoutputControllers[6],6,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Freq(HZ)'),
            _buildTableCell(_upsmoutputControllers[7],7,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('I1'),
            _buildTableCell(_upsmoutputControllers[8],8,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('I2'),
            _buildTableCell(_upsmoutputControllers[9],9,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('I3'),
            _buildTableCell(_upsmoutputControllers[10],10,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('CF'),
            _buildTableCell(_upsmoutputControllers[11],11,'out'),
          ],
        ),Row(
          children: [
            _buildTableHeaderCell('Load Rate (%)'),
            _buildTableCell(_outputControllers[0],0,'output'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Room Temp in celsius'),
            _buildTableCell(_outputControllers[1],1,'output'),
          ],
        ),
      ],
    );
  }

  Widget _buildOutputpowTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('L1'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Pa(KW)'),
            _buildTableCell(_upsmpowerControllers[0],0,'pow'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('S(KVA)'),
            _buildTableCell(_upsmpowerControllers[1],1,'pow'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('L2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Pa(KW)'),
            _buildTableCell(_upsmpowerControllers[2],2,'pow'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('S(KVA)'),
            _buildTableCell(_upsmpowerControllers[3],3,'pow'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('L3'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Pa(KW)'),
            _buildTableCell(_upsmpowerControllers[4],4,'pow'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('S(KVA)'),
            _buildTableCell(_upsmpowerControllers[5],5,'pow'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Power factor'),
            _buildTableCell(_upsmpowerControllers[6],6,'pow'), // Fixed index here
          ],
        ),
      ],
    );
  }

  Widget _buildInverterTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('V12'),
            _buildTableCell(_upsminverterControllers[0],0,'inv'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V23'),
            _buildTableCell(_upsminverterControllers[1],1,'inv'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V31'),
            _buildTableCell(_upsminverterControllers[2],2,'inv'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Freq (HZ)'),
            _buildTableCell(_upsminverterControllers[3],3,'inv'),
          ],
        ),
      ],
    );
  }

  Widget _buildBatteryTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('V bat'),
            _buildTableCell(_upsmbatteryControllers[0],0,'bat'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('I bat'),
            _buildTableCell(_upsmbatteryControllers[1],1,'bat'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('T bat'),
            _buildTableCell(_upsmbatteryControllers[2],2,'bat'),
          ],
        ),
      ],
    );
  }

  Widget _buildRectifierTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('V12'),
            _buildTableCell(_upsmrectControllers[0],0,'rect'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V23'),
            _buildTableCell(_upsmrectControllers[1],1,'rect'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V31'),
            _buildTableCell(_upsmrectControllers[2],2,'rect'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V dc'),
            _buildTableCell(_upsmrectControllers[3],3,'rect'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('I dc'),
            _buildTableCell(_upsmrectControllers[4],4,'rect'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Freq'),
            _buildTableCell(_upsmrectControllers[5],5,'rect'),
          ],
        ),
      ],
    );
  }

  Widget _buildBypassTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('V12'),
            _buildTableCell(_upsmbypassControllers[0],0,'bypass'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V23'),
            _buildTableCell(_upsmbypassControllers[1],1,'bypass'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V31'),
            _buildTableCell(_upsmbypassControllers[2],2,'bypass'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Freq'),
            _buildTableCell(_upsmbypassControllers[3],3,'bypass'),
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

