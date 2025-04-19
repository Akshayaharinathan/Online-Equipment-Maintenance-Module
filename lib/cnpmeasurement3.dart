import 'package:flutter/material.dart';
import './dbHelper/mongodbjsb.dart'; // Ensure this import is correct
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class Unit3Page extends StatefulWidget {
  @override
  _Unit3PageState createState() => _Unit3PageState();
}

class _Unit3PageState extends State<Unit3Page> {
  final _transformerNumberController = TextEditingController(text: 'Control Panel');
  final _unitController = TextEditingController(text: 'Unit 3');
  //final _referenceNumberController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _branchController = TextEditingController(text:'JSB');
  final _outputControllers = List.generate(24, (index) => TextEditingController());
  
  
  final _minValues = {
    'output2': [0.0,
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
0.0,
0.0,
0.0,
/*0.0,
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
0.0,
0.0,
0.0*/
],
};
  final _maxValues = {
    'output2' : [300.0,500.0,500.0,500.0,440.0,75.0,75.0,75.0,75.0,75.0,75.0,75.0,75.0,40.0,40.0,40.0,40.0,150.0,150.0,150.0,150.0,150.0,150.0,150.0/*,60.0,20.0,200.0,40.0,20.0,75.0,15.0,25.0,60.0,15.0,5.0,15.0,15.0,15.0,15.0,75.0,25.0,5.0,15.0,10.0,15.0,15.0,15.0,15.0*/],
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
      _dateController.text = dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
      _timeController.text = timeFormat.format(now);
    });
  }

  @override
void dispose() {
  _timer?.cancel(); // Cancel the timer if it's still running
  for (var controller in _outputControllers) {
    controller.dispose(); // Dispose of all controllers
  }
  super.dispose();
}

  void _addListeners() {
    final controllers = [
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

  void _validateForm() {
    final tableValid = _validateFieldGroup(
      _outputControllers,
      _minValues['output2']!,
      maxValues: _maxValues['output2'],
    );

    setState(() {
      _isFormValid = tableValid;
    });

    // Logging
    print('table Valid: $tableValid');

    print('Form Valid: $_isFormValid');
  }


  Future<void> _handleSubmit(BuildContext context) async {
    try {
      await MongoDatabase.connect();
  
      final measurementData = {
        'Control Panel Number': _transformerNumberController.text,
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
        'controPanel':{
          'ExtruderCurrent': _outputControllers[0].text,
          'Phase A': _outputControllers[1].text,
          'Phase B': _outputControllers[2].text,
          'Phase C': _outputControllers[3].text,
          'Voltage': _outputControllers[4].text,
          'Section1Current': _outputControllers[5].text,
          'Section2Current': _outputControllers[6].text,
          'Section3Current': _outputControllers[7].text,
          'Section4Current': _outputControllers[8].text,
          'Section5Current': _outputControllers[9].text,
          'Section6Current': _outputControllers[10].text,
          'Section7Current': _outputControllers[11].text,
          'SpinneretTempControl': _outputControllers[12].text,
          'Cp1 Section1Current': _outputControllers[13].text,
          'Cp1 Section2Current': _outputControllers[14].text,
          'Cp1 Section3Current': _outputControllers[15].text,
          'Cp1 Section4Current': _outputControllers[16].text,
          'Cp2 TempControlCurrentCaseOilStove': _outputControllers[17].text,
          'Cp2 BasicCurrentCaseOilStove': _outputControllers[18].text,
          'Cp2 Calendar1OilStoveTempControlCurrent': _outputControllers[19].text,
          'CP2 Calendar1OilStoveBasicCurrent': _outputControllers[20].text,
          'Cp2 Calendar2OilStoveTempControlCurrent': _outputControllers[21].text,
          'CP2 Calendar2OilStoveBasicCurrent':_outputControllers[22].text,
          'SmallRollerCurrent':_outputControllers[23].text,
          /*'MixingMotorCurrent':_outputControllers[24].text,
          'LoaderMotorCurrent':_outputControllers[25].text,
          'ExtruderMotorCurrent':_outputControllers[26].text,
          'Co-ExtruderMotorCurrent':_outputControllers[27].text,
          'MatricMotorCurrent':_outputControllers[28].text,
          'CoolingMotor':_outputControllers[29].text,
          'PressRollerOilPumpMotorCurrent':_outputControllers[30].text,
          'SpinBeltMotorCurrent':_outputControllers[31].text,
          'CalendarMotorCurrent':_outputControllers[32].text,
          'CalendarHydraulicMotorCurrent':_outputControllers[33].text,
          'LubricanrMotorCurrent':_outputControllers[34].text,
          'MonomerMotorCurrent':_outputControllers[35].text,
          'DieOilPumpMotor':_outputControllers[36].text,
          'CalendarUpRollerPumpMotor':_outputControllers[37].text,
          'CalendarDownRollerPumpMotor':_outputControllers[38].text,
          'SuctionMotor':_outputControllers[39].text,
          'WinderMotorCurrent':_outputControllers[40].text,
          'DoffingMotorCurrent':_outputControllers[41].text,
          'AirCompressorCurrent':_outputControllers[42].text,
          'WinderCraneCurrent':_outputControllers[43].text,
          'PrimaryMotorCurrent':_outputControllers[44].text,
          'SecondaryMotorCurrent':_outputControllers[45].text,
          'CalenderHydraulicCoolingMotorCurrent':_outputControllers[46].text,
          'Cooling Roller Motor Current':_outputControllers[47].text,*/
        }
      };
      await MongoDatabase.insert(measurementData, 'Control Panel Unit 3 Measurement');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Measurement submitted successfully!')));
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit measurement: $e')));
    }
  }

  void _resetForm() {
    for (var controller in [
      ..._outputControllers,
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
              _buildTextField(_transformerNumberController, 'Control Panel Number', readOnly: true),
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
            _buildTableHeaderCell('Extruder Current'),
            _buildTableCell(_outputControllers[0], 0, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Phase A'),
            _buildTableCell(_outputControllers[1], 1, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Phase B'),
            _buildTableCell(_outputControllers[2], 2, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Phase C'),
            _buildTableCell(_outputControllers[3], 3, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Voltage'),
            _buildTableCell(_outputControllers[4], 4, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Section 1 Current'),
            _buildTableCell(_outputControllers[5], 5, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Section 2 Current'),
            _buildTableCell(_outputControllers[6], 6, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Section 3 Current'),
            _buildTableCell(_outputControllers[7], 7, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Section 4 Current'),
            _buildTableCell(_outputControllers[8], 8, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Section 5 Current'),
            _buildTableCell(_outputControllers[9], 9, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Section 6 Current'),
            _buildTableCell(_outputControllers[10], 10, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('CP1'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Section 7 Current'),
            _buildTableCell(_outputControllers[11], 11, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Spinneret Temp Control'),
            _buildTableCell(_outputControllers[12], 12, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Section 1 Current'),
            _buildTableCell(_outputControllers[13], 13, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Section 2 Current'),
            _buildTableCell(_outputControllers[14], 14, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Section 3 Current'),
            _buildTableCell(_outputControllers[15], 15, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Section 4 Current'),
            _buildTableCell(_outputControllers[16], 16, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('CP2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Temp control Current case oil stove'),
            _buildTableCell(_outputControllers[17], 17, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Basic Current of case oil stove'),
            _buildTableCell(_outputControllers[18], 18, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Calendar 1 Oil Stove Temp Control Current'),
            _buildTableCell(_outputControllers[19], 19, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Calendar 1 Oil Stove Basic Current'),
            _buildTableCell(_outputControllers[20], 20, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Calendar 2 Oil Stove Temp Control Current'),
            _buildTableCell(_outputControllers[21], 21, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Calendar 2 oil stove Basic Current'),
            _buildTableCell(_outputControllers[22], 22, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Small Roller Current'),
            _buildTableCell(_outputControllers[23], 23, 'output2'),
          ],
        ),
       /* Row(
          children: [
            _buildTableHeaderCell('Mixing Motor Current'),
            _buildTableCell(_outputControllers[24], 24, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Loader Motor Current'),
            _buildTableCell(_outputControllers[25], 25, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Extruder Motor Current'),
            _buildTableCell(_outputControllers[26], 26, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Co-Extruder Motor Current'),
            _buildTableCell(_outputControllers[27], 27, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Matric Motor Current'),
            _buildTableCell(_outputControllers[28], 28, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Cooling Motor'),
            _buildTableCell(_outputControllers[29], 29, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Press Roller Oil Pump Motor Current'),
            _buildTableCell(_outputControllers[30], 30, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Spin Belt Motor Current'),
            _buildTableCell(_outputControllers[31], 31, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Calender Motor Current'),
            _buildTableCell(_outputControllers[32], 32, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Calender Hydraulic Motor Current'),
            _buildTableCell(_outputControllers[33], 33, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Lubricant Motor Current'),
            _buildTableCell(_outputControllers[34], 34, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Monomer Motor Current'),
            _buildTableCell(_outputControllers[35], 35, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Die Oil Pump Motor'),
            _buildTableCell(_outputControllers[36], 36, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Calender Up Roller Pump Motor'),
            _buildTableCell(_outputControllers[37], 37, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Calender Down Roller Pump Motor'),
            _buildTableCell(_outputControllers[38], 38, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Suction Motor'),
            _buildTableCell(_outputControllers[39], 39, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Winder Motor Current'),
            _buildTableCell(_outputControllers[40], 40, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Doffing Motor Current'),
            _buildTableCell(_outputControllers[41], 41, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Air Compressor Current'),
            _buildTableCell(_outputControllers[42], 42, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Winder Crane Current'),
            _buildTableCell(_outputControllers[43], 43, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Primary Motor Current'),
            _buildTableCell(_outputControllers[44], 44, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Secondary Motor Current'),
            _buildTableCell(_outputControllers[45], 45, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Calender Hydraulic Cooling Motor Current'),
            _buildTableCell(_outputControllers[46], 46, 'output2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Cooling Roller Motor Current'),
            _buildTableCell(_outputControllers[47], 47, 'output2'),
          ],
        ),*/
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
}

  /*List<Widget> _buildTableCellList(List<String> labels) {
    return labels.map((label) {
      return Container(
        color: Colors.green[200],
        padding: EdgeInsets.all(8.0),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList();
  }

  List<Widget> _buildTableFieldList(List<TextEditingController> controllers) {
    return controllers.map((controller) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          style: TextStyle(backgroundColor: Colors.white),
        ),
      );
    }).toList();
  }
}*/