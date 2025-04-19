import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:JSBE3M/dbHelper/mongodbjsb.dart';
import 'dart:async';

class DGMeasurementPage extends StatefulWidget {
  @override
  _DGMeasurementPageState createState() => _DGMeasurementPageState();
}

class _DGMeasurementPageState extends State<DGMeasurementPage> {
 // final _transformerNumberController = TextEditingController(text:'Number');
  final _dgmunitController = TextEditingController(text : 'DG Panel');
  //final _dgmreferenceNumberController = TextEditingController(text:'Ref Number');
  final _dgmdateController = TextEditingController();
  final _dgmtimeController = TextEditingController();
  final _dgmbranchController = TextEditingController(text: 'JSB');
  final _dgmvoltageControllers = List.generate(6, (index) => TextEditingController());
  final _dgmcurrentControllers = List.generate(3, (index) => TextEditingController());
  final _dgmpowerControllers = List.generate(3, (index) => TextEditingController());
  //final _dgmpControllers = List.generate(4, (index) => TextEditingController());
  //final _dgmtemperatureControllers = List.generate(60, (index) => TextEditingController());
  //final _dgmphaseAngleControllers = List.generate(31, (index) => TextEditingController());
  final _dgmCurrControllers = List.generate(1, (index) => TextEditingController());
  final _dgmfreqControllers = List.generate(1, (index) => TextEditingController());
  final _dgmpower1FactorController =List.generate(1, (index) => TextEditingController());
   final _dgmcurrent1Controllers = List.generate(1, (index) => TextEditingController());

final _minValues = {
    'volt': [0.0, 0.0,0.0,0.0,0.0,0.0],
    'curr': [0.0, 0.0, 0.0],
    'pf': [0.9],
    'freq': [48.0],
    'power': [0.0, 0.0,0.0],
  };
  final _maxValues = {
    'volt': [440.0, 440.0,440.0,245.0,245.0,245.0],
    'curr': [1300.0, 1300.0, 1300.0],
    'pf': [1.0],
    'freq': [52.0],
    'power': [1600.0, 1600.0,300.0],
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
        _dgmtimeController.text = timeFormat.format(now);
      });
    });
  }

  @override
void dispose() {
  _dgmunitController.dispose();
  _dgmdateController.dispose();
  _dgmtimeController.dispose();
  _dgmbranchController.dispose();

  for (var controller in [
    ..._dgmvoltageControllers,
    ..._dgmcurrentControllers,
    ..._dgmpowerControllers,
    ..._dgmCurrControllers,
    ..._dgmfreqControllers,
    ..._dgmcurrent1Controllers,
    ..._dgmpower1FactorController,
  ]) {
    controller.dispose();
  }

  _timer?.cancel(); // Cancel the timer if it's running
  super.dispose();
}

  

  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');

    _dgmdateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _dgmtimeController.text = timeFormat.format(now);
  }

  void _addListeners() {
    final controllers = [
     ... _dgmpower1FactorController,
      ..._dgmvoltageControllers,
       ..._dgmcurrent1Controllers,
      ..._dgmpowerControllers,
      ..._dgmCurrControllers,
      ..._dgmcurrentControllers,
     
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
      if (double.tryParse(text) == null && text != '-') {
        print('Validation failed for value: $text'); // Log invalid value
        return false;
      }
    }
    return true;
  }

  void _validateForm() {
  final voltValid = _validateFieldGroup(
    _dgmvoltageControllers,
    _minValues['volt']!,
    maxValues: _maxValues['volt'],
  );
  final currentValid = _validateFieldGroup(
    _dgmcurrentControllers,
    _minValues['curr']!,
    maxValues: _maxValues['curr'],
  );
  final pfValid = _validateFieldGroup(
    _dgmCurrControllers,
    _minValues['pf']!,
    maxValues: _maxValues['pf'],
  );
  final freqValid = _validateFieldGroup(
    _dgmfreqControllers,
    _minValues['freq']!,
    maxValues: _maxValues['freq'],
  );
  final powerValid = _validateFieldGroup(
    _dgmpowerControllers,
    _minValues['power']!,
    maxValues: _maxValues['power'],
  );
  final powerKWHValid = _validateNumericFieldGroup(_dgmpower1FactorController);
  final energyValid = _validateNumericFieldGroup(_dgmcurrent1Controllers);

  setState(() {
    _isFormValid = voltValid &&
        currentValid &&
        freqValid &&
        powerValid &&
        powerKWHValid &&
        pfValid &&
        energyValid;
  });

  // Logging
  print('Voltage Valid: $voltValid');
  print('Frequency Valid: $freqValid');
  print('Current Valid: $currentValid');
  print('Power Valid: $powerValid');
  print('Power KWH Valid: $powerKWHValid');
  print('Power Factor Valid: $pfValid');
  print('Energy Valid: $energyValid');
  print('Form Valid: $_isFormValid');
}


  Future<void> _handleSubmit(BuildContext context) async {
    try {
      await MongoDatabase.connect();
      final measurementData = {
        'DG Panel': _dgmunitController.text,
        //'unit': _dgmunitController.text,
        //'referenceNumber': _dgmreferenceNumberController.text,
        'date': _dgmdateController.text,
        'time': _dgmtimeController.text,
        'branch': _dgmbranchController.text,
        'Voltage':{
          //'Voltage Line-Line' : _dgmvoltageControllers[0].text,
          'Voltage RY' : _dgmvoltageControllers[0].text,
          'Voltage YB' : _dgmvoltageControllers[1].text,
          'Voltage BR' : _dgmvoltageControllers[2].text,
         // 'Voltage Line-Neutral' : _dgmvoltageControllers[4].text,
          'Voltage RN' : _dgmvoltageControllers[3].text,
          'Voltage YN' : _dgmvoltageControllers[4].text,
          'Voltage BN' : _dgmvoltageControllers[5].text,
        },
        'power':{
          'Real Power(P) - Total KW':_dgmpowerControllers[0].text,
          'Reactive Power(Q) - Total KVA': _dgmpowerControllers[1].text,
          'Apparent Power(S) - Total KVAR': _dgmpowerControllers[2].text,
          'Run Absolute (Hours)': _dgmpower1FactorController[0].text,    
        },
        'Current':{
          'R' : _dgmcurrentControllers[0].text,
          'Y' : _dgmcurrentControllers[1].text,
          'B' : _dgmcurrentControllers[2].text,
        },
        'powerfactor':_dgmCurrControllers[0].text,
        'frequency':_dgmfreqControllers[0].text,
        'energy total':_dgmcurrent1Controllers[0].text,
      };
      await MongoDatabase.insert(measurementData, 'DG Measurement');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Measurement submitted successfully!')));
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit measurement')));
    }
  }
  void _resetForm() {
    setState(() {
      for (var controller in [
        ..._dgmvoltageControllers,
        ..._dgmcurrentControllers,
        ..._dgmpowerControllers,
        ..._dgmCurrControllers,
        ..._dgmfreqControllers,
        ..._dgmcurrent1Controllers,
        ..._dgmpower1FactorController,
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
              _buildTextField(_dgmunitController, 'DG Panel', readOnly: true),
             // _buildTextField(_dgmreferenceNumberController, 'Reference Number', readOnly: true),
              _buildTextField(_dgmdateController, 'Date and Day', readOnly: true),
              _buildTextField(_dgmtimeController, 'Time', readOnly: true),
              _buildTextField(_dgmbranchController, 'Branch', readOnly: true),

              SizedBox(height: 20.0),
              _buildSectionHeader('VOLTAGE'),
              _buildVoltageTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('CURRENT'),
              _buildCurrentTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('POWERFACTOR'),
              _buildpfTable(),

              SizedBox(height: 20.0),
              _buildSectionHeader('FREQUENCY (HZ)'),
              _buildfreqTable(),

              SizedBox(height: 20.0),
              _buildSectionHeader('POWER'),
              _buildPowerTable(),
              Center(
  child: ElevatedButton(
    onPressed: _isFormValid ? () => _handleSubmit(context) : null,
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
          _isFormValid ? Colors.lightGreen : Colors.grey),
      foregroundColor:
          MaterialStateProperty.all<Color>(Colors.black), 
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

  Widget _buildVoltageTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Line-Line'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('RY'),
            _buildTableCell(_dgmvoltageControllers[0],0,'volt'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('YB'),
            _buildTableCell(_dgmvoltageControllers[1],1,'volt'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('BR'),
            _buildTableCell(_dgmvoltageControllers[2],2,'volt'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Line-Neutral'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('RN'),
            _buildTableCell(_dgmvoltageControllers[3],3,'volt'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('YN'),
            _buildTableCell(_dgmvoltageControllers[4],4,'volt'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('BN'),
            _buildTableCell(_dgmvoltageControllers[5],5,'volt'),
            
          ],
        ),
      ],
    );
  }

  Widget _buildPowerTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Real Power(P) - Total KW'),
            _buildTableCell(_dgmpowerControllers[0],0,'power'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Reactive Power(Q) - Total KVA'), 
            _buildTableCell(_dgmpowerControllers[1],1,'power'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Apparent Power(S) - Total KVAR'),
            _buildTableCell(_dgmpowerControllers[2],2,'power'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Run Absolute (Hours)'),
            _buildTableCell(_dgmpower1FactorController[0],0,'powerfact'),
            
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('R'),
            _buildTableCell(_dgmcurrentControllers[0],0,'curr'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Y'),
            _buildTableCell(_dgmcurrentControllers[1],1,'curr'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('B'),
            _buildTableCell(_dgmcurrentControllers[2],2,'curr'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Total Energy'),
            _buildTableCell(_dgmcurrent1Controllers[0],0,'energy'),
          ],
        ),
      ],
    );
  }


  Widget _buildpfTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Power Factor'),
            _buildTableCell(_dgmCurrControllers[0],0,'pf'),
          ],
        ),
      ],
    );
  }

  Widget _buildfreqTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Freq(Hz)'),
            _buildTableCell(_dgmfreqControllers[0],0,'freq'),
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



