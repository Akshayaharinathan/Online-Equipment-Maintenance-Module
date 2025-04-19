import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './dbHelper/mongodbjsb.dart';
import 'package:intl/intl.dart';


class acomp2MeasurementPage extends StatefulWidget {
  @override
  _acomp2MeasurementPageState createState() => _acomp2MeasurementPageState();
}

class _acomp2MeasurementPageState extends State<acomp2MeasurementPage> {
  final TextEditingController _transformerNumberController =
      TextEditingController(text: 'Air Compressor 2');
  final TextEditingController _unitController =
      TextEditingController(text: '11 KW');
  //final TextEditingController _referenceNumberController =TextEditingController(text: 'Ref Number');
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _branchController =
      TextEditingController(text: 'JSB');
  final  _outputControllers =List.generate(4, (_) => TextEditingController());
  final  _outControllers =List.generate(6, (_) => TextEditingController());
  final  List<TextEditingController>_time1Controllers =List.generate(1, (_) => TextEditingController());
  final  List<TextEditingController>_time2Controllers =List.generate(1, (_) => TextEditingController());
  final  List<TextEditingController>_time3Controllers =List.generate(1, (_) => TextEditingController());
  final  List<TextEditingController>_time4Controllers =List.generate(1, (_) => TextEditingController());
  final  List<TextEditingController>_time5Controllers =List.generate(1, (_) => TextEditingController());
  final  List<TextEditingController>_time6Controllers =List.generate(1, (_) => TextEditingController());
  final  _phaseAngleControllers =List.generate(10, (_) => TextEditingController());
  

  final _minValuesFloat = {
  'out': [0.0, 0.0, 0.0, 0.0],
  'phase': [0.0, 0.0, 0.0, 0.0, 0.0,0.0,0.0,0.0,0.0,0.0],
};

final _maxValuesFloat = {
  'out': [10.0, 100.0, 100.0, 50.0],
  'phase': [100000,2000.0,100000, 2000.0,100000, 4000.0,100000, 4000.0,100000, 2000.0],
};

/*final _minValuesInt = {
  'time1': [1, 0],
  'time2': [1, 0],
  'time3': [1, 0],
};

final _maxValuesInt = {
  'time1': [12, 60],
  'time2': [12, 60],
  'time3': [12, 60],
};*/


  bool _isFormValid = false;
  Timer? _timer;

  @override
  void dispose() {
    // Dispose all controllers
    _transformerNumberController.dispose();
    _unitController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _branchController.dispose();

    for (var controller in [
      ..._outputControllers,
      ..._outControllers,
      ..._time1Controllers,
      ..._time2Controllers,
      ..._time3Controllers,
      ..._time4Controllers,
      ..._time5Controllers,
      ..._time6Controllers,
      ..._phaseAngleControllers,
    ]) {
      controller.dispose();
    }

    // Cancel the timer
    _timer?.cancel();

    super.dispose();
  }

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

    _dateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _timeController.text = timeFormat.format(now);
  }

  void _addListeners() {
    final controllers = [
      ..._outputControllers,
      ..._phaseAngleControllers,
      ..._outControllers,
      ..._time1Controllers,
      ..._time2Controllers,
      ..._time3Controllers,
      ..._time4Controllers,
      ..._time5Controllers,
      ..._time6Controllers,

    ];

    for (var controller in controllers) {
      controller.addListener(_validateForm);
    }
  }

   bool _validateFieldGroup(
    List<TextEditingController> controllers, List<num> minValues,
    {List<num>? maxValues, bool isInteger = false}) {
  if (controllers.length != minValues.length) {
    return false;
  }

  for (int i = 0; i < controllers.length; i++) {
    final controller = controllers[i];
    final minValue = minValues[i];
    final maxValue = maxValues != null ? maxValues[i] : double.infinity;
    final text = controller.text;

    if (text.isEmpty) return false; // Ensure field is not empty

    // Validate the number based on whether it's supposed to be an integer
    final number = isInteger ? int.tryParse(text) : double.tryParse(text);
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
  final outputValid = _validateFieldGroup(
    _outputControllers,
    _minValuesFloat['out']!,
    maxValues: _maxValuesFloat['out'],
  );
  final phaseValid = _validateFieldGroup(
    _phaseAngleControllers,
    _minValuesFloat['phase']!,
    maxValues: _maxValuesFloat['phase'],
  );
  final time1Valid = _validateNumericFieldGroup(_time1Controllers);
  final time2Valid = _validateNumericFieldGroup(_time2Controllers);
  final time3Valid = _validateNumericFieldGroup(_time3Controllers);
  final time4Valid = _validateNumericFieldGroup(_time4Controllers);
  final time5Valid = _validateNumericFieldGroup(_time5Controllers);
  final time6Valid = _validateNumericFieldGroup(_time6Controllers);
  final outValid = _validateNumericFieldGroup(_outControllers);

  setState(() {
    _isFormValid = outputValid &&
        phaseValid &&
        outValid &&
        time2Valid &&
        time3Valid &&
        time1Valid &&
        time4Valid &&
        time5Valid &&
        time6Valid;
  });
  print('output Valid: $outputValid');
  print('phase Valid: $phaseValid');
  print('out Valid: $outValid');
  print('time1 Valid: $time1Valid');
  print('time2 Valid: $time2Valid');
  print('time3 Valid: $time3Valid');
  print('time4 Valid: $time4Valid');
  print('time5 Valid: $time5Valid');
  print('time6 Valid: $time6Valid');
  print('Form Valid: $_isFormValid');
}

   Future<void> _handleSubmit(BuildContext context) async {
    try {
      await MongoDatabase.connect();
      final measurementData = {
        'AirCompNumber': _transformerNumberController.text,
        'unit': _unitController.text,
        //'referenceNumber': _referenceNumberController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'branch': _branchController.text,
        'Discharge Pressure(Bar)': _outputControllers[0].text,
        'Discharge Temp (c)': _outputControllers[1].text,
        'Run Unload': {
          'minutes':_time1Controllers[0].text,
          'seconds':_time2Controllers[0].text,
          },
        'Run Load': {
          'minutes':_time3Controllers[0].text,
          'seconds':_time4Controllers[0].text,
        },

        'Stand BY': {
          'minutes':_time5Controllers[0].text,
          'seconds':_time6Controllers[0].text,
        },
        'Load Hours': _outControllers[0].text,
        'Un Load Hours': _outControllers[1].text,
        'Run Hours': _outControllers[2].text,
        'Stop Hours': _outControllers[3].text,
        'Fault Hours': _outControllers[4].text,
        'Stand By Hours': _outControllers[5].text,
        '% Utilization': _outputControllers[2].text,
        'KW': _outputControllers[3].text,
        ' ': {
          'Parameters:AirFilter(AFCT) ':
          {
            'set(hours)':_phaseAngleControllers[0].text,
            'service (hours)': _phaseAngleControllers[1].text,
            },
          'Parameters:OilFilter(OFCT) ':
              {
            'set(hours)':_phaseAngleControllers[2].text,
            'service (hours)': _phaseAngleControllers[3].text,
            },
          'Parameters:OilSeparator(OSCT) ':
              {
            'set(hours)':_phaseAngleControllers[4].text,
            'service (hours)': _phaseAngleControllers[5].text,
            },
          'Parameters:EngineOil(OCT) ':
             {
            'set(hours)':_phaseAngleControllers[6].text,
            'service (hours)': _phaseAngleControllers[7].text,
            },
          'Parameters:Grease(RGT)':
             {
            'set(hours)':_phaseAngleControllers[8].text,
            'service (hours)': _phaseAngleControllers[9].text,
            },
        }
        };
      await MongoDatabase.insert(measurementData, 'Air Compressor Unit 2 Measurement');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Measurement submitted successfully!')));
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit measurement')));
    }
  }

  void _resetForm() {
    setState(() {
      for (var controller in [
        ..._outputControllers,
        ..._phaseAngleControllers,
        ..._outControllers,
        ..._time1Controllers,
        ..._time2Controllers,
        ..._time3Controllers,
        ..._time4Controllers,
        ..._time5Controllers,
        ..._time6Controllers
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
              _buildTextField(_transformerNumberController, 'Air Compressor', readOnly: true),
              _buildTextField(_unitController, 'Unit', readOnly: true),
             // _buildTextField(_referenceNumberController, 'Reference Number',readOnly: true),
              _buildTextField(_dateController, 'Date and Day', readOnly: true),
              _buildTextField(_timeController, 'Time', readOnly: true),
              _buildTextField(_branchController, 'Branch', readOnly: true),
              SizedBox(height: 20.0),
              _buildSectionHeader(''),
              _buildOutputTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader(''),
              _buildBatteryTable(),
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
            _buildTableHeaderCell('Discharge Pressure (Bar)'),
            _buildTableCell(_outputControllers[0],0,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Discharge Temp(in celcius)'),
            _buildTableCell(_outputControllers[1],1,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Run Unload'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Minutes'),
            _buildTableCell(_time1Controllers[0],0,'time1'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Seconds'),
            _buildTableCell(_time2Controllers[0],0,'time2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Run Load'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Minutes'),
            _buildTableCell(_time3Controllers[0],0,'time3'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Seconds'),
            _buildTableCell(_time4Controllers[0],0,'time4'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Stand BY'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Minitues'),
            _buildTableCell(_time5Controllers[0],0,'time5'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Seconds'),
            _buildTableCell(_time6Controllers[0],0,'time6'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Load Hours'),
            _buildTableCell(_outControllers[0],0,'null'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Unload Hours'),
            _buildTableCell(_outControllers[1],1,'null'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Remaining Hours'),
            _buildTableCell(_outControllers[2],2,'null'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Stop Hours'),
            _buildTableCell(_outControllers[3],3,'null'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Fault Hours'),
            _buildTableCell(_outControllers[4],4,'null'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Stand by hours'),
            _buildTableCell(_outControllers[5],5,'null'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('% Utilization'),
            _buildTableCell(_outputControllers[2],2,'out'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('KW'),
            _buildTableCell(_outputControllers[3],3,'out'),
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
            _buildTableHeaderCell('Parameters'),
            _buildTableHeaderCell('Set(Hours)'),
            _buildTableHeaderCell('Service(Hours)'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Air Filter(AFCT)'),
            
            _buildTableCell(_phaseAngleControllers[0],0,'phase'),
            _buildTableCell(_phaseAngleControllers[1],1,'phase'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Oil Filter(OFCT)'),
            _buildTableCell(_phaseAngleControllers[2],2,'phase'),
            _buildTableCell(_phaseAngleControllers[3],3,'phase'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Oil Separator(OSCT)'),
            _buildTableCell(_phaseAngleControllers[4],4,'phase'),
            _buildTableCell(_phaseAngleControllers[5],5,'phase'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Engine Oil(OCT)'),
            _buildTableCell(_phaseAngleControllers[6],6,'phase'),
            _buildTableCell(_phaseAngleControllers[7],7,'phase'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Grease(RGT)'),
            _buildTableCell(_phaseAngleControllers[8],8,'phase'),
            _buildTableCell(_phaseAngleControllers[9],9,'phase'),
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
  num minValue;
  num maxValue;
  
    minValue = _minValuesFloat[type]?[index] ?? 0.0;
    maxValue = _maxValuesFloat[type]?[index] ?? double.infinity;
  

  // Check if the value is within the valid range
  if (controller.text.isNotEmpty) {
    String text = controller.text;

    // Allow hyphen as a valid input (e.g., for negative numbers)
    if (text == '-') {
      isValid = true;
    } else {
      num? value;
      if (type.startsWith('time')) {
        value = int.tryParse(text);
      } else {
        value = double.tryParse(text);
      }
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
            borderSide: BorderSide(color: isValid ? Colors.black : Colors.red),
          ),
          filled: true,
          fillColor: Colors.white54,
          errorText: isValid ? null : errorMessage,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: !type.startsWith('time')),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(
              r'^-?\d*\.?\d*$')), // Allow numbers with optional decimal point
          LengthLimitingTextInputFormatter(10), // Adjust the length limit as needed
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


