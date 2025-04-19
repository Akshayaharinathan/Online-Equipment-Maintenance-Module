import 'package:flutter/material.dart';
import './dbHelper/mongodbjsb.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class UPSU3MeasurementPage extends StatefulWidget {
  @override
  _UPSU3MeasurementPageState createState() => _UPSU3MeasurementPageState();
}

class _UPSU3MeasurementPageState extends State<UPSU3MeasurementPage> {
  final TextEditingController _transformerNumberController =
      TextEditingController(text: 'UPS-400kva');
  final TextEditingController _unitController =
      TextEditingController(text: 'unit 2');

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _branchController =
      TextEditingController(text: 'JSB');
  

  
  final List<TextEditingController> _phaseAngle1Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle2Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle3Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle4Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle5Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle6Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle7Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle8Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle9Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle10Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle11Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle12Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle13Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle14Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle15Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle16Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle17Controllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _phaseAngle18Controllers =
      List.generate(1, (_) => TextEditingController());
  
  final List<TextEditingController> _voltageControllers =
      List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _tempControllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _pfControllers =
      List.generate(1, (_) => TextEditingController());
  final List<TextEditingController> _currentControllers =
      List.generate(3, (_) => TextEditingController());

// Define min and max values for each field
  final _minValues = {
    'bv': [0.0],
    'bf': [0.0],
    'bab': [0.0],
    'bbc': [0.0],
    'bca': [0.0],
    
    
    'iv': [0.0],
    'if': [0.0],
    'iab': [0.0],
    'ibc': [0.0],
    'ica': [0.0],
    
    'batteryv': [0.0],
    'ov': [0.0],
    'of': [0.0],
    'oab': [0.0],
    'obc': [0.0],
    'oca': [0.0],
    'ofreq': [0.0],
    'ocur': [0.0],
    'vol': [0.0,0.0,0.0],
    'temp': [0.0],
    'pf': [0.0],
    'current': [0.0,0.0,0.0],



  };

  final _maxValues = {
    'bv': [440.0],
    'bf': [51.0],
    'bab': [440.0],
    'bbc': [440.0],
    'bca': [440.0],
    
    'iv': [440.0],
    'if': [51.0],
    'iab': [440.0],
    'ibc': [440.0],
    'ica': [440.0],
    
    'batteryv': [580.0],

    'ov': [425.0],
    'of': [51.0],
    'oab': [425.0],
    'obc': [425.0],
    'oca': [425.0],
    'ocur': [400.0],

    'vol': [245.0,245.0,245.0],
    'temp': [30.0],
    'pf': [1.0],
    'current': [400.0,400.0,400.0],
    


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

   @override
void dispose() {
  // Dispose of all controllers
  _transformerNumberController.dispose();
  _unitController.dispose();
  _dateController.dispose();
  _timeController.dispose();
  _branchController.dispose();
  
  for (var controller in [
    ..._phaseAngle1Controllers,
    ..._phaseAngle2Controllers,
    ..._phaseAngle3Controllers,
    ..._phaseAngle4Controllers,
    ..._phaseAngle5Controllers,
    ..._phaseAngle6Controllers,
    ..._phaseAngle7Controllers,
    ..._phaseAngle8Controllers,
    ..._phaseAngle9Controllers,
    ..._phaseAngle10Controllers,
    ..._phaseAngle11Controllers,
    ..._phaseAngle12Controllers,
    ..._phaseAngle13Controllers,
    ..._phaseAngle14Controllers,
    ..._phaseAngle15Controllers,
    ..._phaseAngle16Controllers,
    ..._phaseAngle17Controllers,
    ..._phaseAngle18Controllers,
    ..._voltageControllers,
    ..._tempControllers,
    ..._pfControllers,
    ..._currentControllers,
  ]) {
    controller.dispose();
  }

  _timer?.cancel(); // Cancel the timer if it's active

  super.dispose();
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
      ..._phaseAngle1Controllers,
      ..._phaseAngle2Controllers,
      ..._phaseAngle3Controllers,
      ..._phaseAngle4Controllers,
      ..._phaseAngle5Controllers,
      ..._phaseAngle6Controllers,
      ..._phaseAngle7Controllers,
      ..._phaseAngle8Controllers,
      ..._phaseAngle9Controllers,
      ..._phaseAngle10Controllers,
      ..._phaseAngle11Controllers,
      ..._phaseAngle12Controllers,
      ..._phaseAngle13Controllers,
      ..._phaseAngle14Controllers,
      ..._phaseAngle15Controllers,
      ..._phaseAngle16Controllers,
      ..._phaseAngle17Controllers,
      ..._phaseAngle18Controllers,
      
      
      
      ..._voltageControllers,
      ..._tempControllers,
      ..._pfControllers,
      ..._currentControllers,
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


    final bvValid = _validateFieldGroup(
      _phaseAngle1Controllers,
      _minValues['bv']!,
      maxValues: _maxValues['bv'],
    );
    final bfValid = _validateFieldGroup(
      _phaseAngle2Controllers,
      _minValues['bf']!,
      maxValues: _maxValues['bf'],
    );
    final babValid = _validateFieldGroup(
      _phaseAngle3Controllers,
      _minValues['bab']!,
      maxValues: _maxValues['bab'],
    );
    final bbcValid = _validateFieldGroup(
      _phaseAngle4Controllers,
      _minValues['bbc']!,
      maxValues: _maxValues['bbc'],
    );
    final bcaValid = _validateFieldGroup(
      _phaseAngle5Controllers,
      _minValues['bca']!,
      maxValues: _maxValues['bca'],
    );
    final ivValid = _validateFieldGroup(
      _phaseAngle6Controllers,
      _minValues['iv']!,
      maxValues: _maxValues['iv'],
    );
    final ifValid = _validateFieldGroup(
      _phaseAngle7Controllers,
      _minValues['if']!,
      maxValues: _maxValues['if'],
    );
    final iabValid = _validateFieldGroup(
      _phaseAngle8Controllers,
      _minValues['iab']!,
      maxValues: _maxValues['iab'],
    );
    final ibcValid = _validateFieldGroup(
      _phaseAngle9Controllers,
      _minValues['ibc']!,
      maxValues: _maxValues['ibc'],
    );
    final icaValid = _validateFieldGroup(
      _phaseAngle10Controllers,
      _minValues['ica']!,
      maxValues: _maxValues['ica'],
    );
    final batteryvValid = _validateFieldGroup(
      _phaseAngle11Controllers,
      _minValues['batteryv']!,
      maxValues: _maxValues['batteryv'],
    );
    final ovValid = _validateFieldGroup(
      _phaseAngle13Controllers,
      _minValues['ov']!,
      maxValues: _maxValues['ov'],
    );
    final ofValid = _validateFieldGroup(
      _phaseAngle14Controllers,
      _minValues['of']!,
      maxValues: _maxValues['of'],
    );
    final oabValid = _validateFieldGroup(
      _phaseAngle15Controllers,
      _minValues['oab']!,
      maxValues: _maxValues['oab'],
    );
    final obcValid = _validateFieldGroup(
      _phaseAngle16Controllers,
      _minValues['obc']!,
      maxValues: _maxValues['obc'],
    );
    final ocaValid = _validateFieldGroup(
      _phaseAngle17Controllers,
      _minValues['oca']!,
      maxValues: _maxValues['oca'],
    );
    final ocurValid = _validateFieldGroup(
      _phaseAngle18Controllers,
      _minValues['ocur']!,
      maxValues: _maxValues['ocur'],
    );
    final volValid = _validateFieldGroup(
      _voltageControllers,
      _minValues['vol']!,
      maxValues: _maxValues['vol'],
    );
    final tempValid = _validateFieldGroup(
      _tempControllers,
      _minValues['temp']!,
      maxValues: _maxValues['temp'],
    );
    final pfValid = _validateFieldGroup(
      _pfControllers,
      _minValues['pf']!,
      maxValues: _maxValues['pf'],
    );
    final currentValid = _validateFieldGroup(
      _currentControllers,
      _minValues['current']!,
      maxValues: _maxValues['current'],
    );
    final batterycValid =
        _validateNumericFieldGroup(_phaseAngle12Controllers);



    setState(() {
      _isFormValid =  bvValid &&
           bfValid &&
           babValid &&
           bbcValid &&
           bcaValid &&
           ivValid &&
           ifValid &&
           iabValid &&
           ibcValid &&
           icaValid &&
           batteryvValid &&
           batterycValid &&
           ovValid &&
           ofValid &&
           oabValid &&
           obcValid &&
           ocaValid &&
           ocurValid &&
           volValid &&
           tempValid &&
           pfValid &&
           currentValid ;



    });
          

  }

  Future<void> _handleSubmit() async {
    try {
      await MongoDatabase.connect();
      final measurementData = {
        'UPS Number': _transformerNumberController.text,
        'Unit': _unitController.text,
        'Date': _dateController.text,
        'Time': _timeController.text,
        'Branch': _branchController.text,
        'Table': {
          'Voltage(v) Bypass': _phaseAngle1Controllers[0].text,
          'Freq(HZ) Bypass': _phaseAngle2Controllers[0].text,
          'AB(v) Bypass': _phaseAngle3Controllers[0].text,
          'BC(v) Bypass': _phaseAngle4Controllers[0].text,
          'CA(v) Bypass': _phaseAngle5Controllers[0].text,
          
          'Voltage(v) Input': _phaseAngle6Controllers[0].text,
          'Freq(HZ) Input': _phaseAngle7Controllers[0].text,
          'AB(v) Input': _phaseAngle8Controllers[0].text,
          'BC(v) Input': _phaseAngle9Controllers[0].text,
          'CA(v) Input': _phaseAngle10Controllers[0].text,
          
          'Voltage(v) Battery': _phaseAngle11Controllers[0].text,
          'Current(A) Battery': _phaseAngle12Controllers[0].text,

          'Voltage(v) Output': _phaseAngle13Controllers[0].text,
          'Freq(HZ) Output': _phaseAngle14Controllers[0].text,
          'AB(v) Output': _phaseAngle15Controllers[0].text,
          'BC(v) Output': _phaseAngle16Controllers[0].text,
          'CA(v) Output': _phaseAngle17Controllers[0].text,
          'Current(A) Output': _phaseAngle18Controllers[0].text,
        },
        'Voltage': {
          'AN': _voltageControllers[0].text,
          'BN': _voltageControllers[1].text,
          'CN': _voltageControllers[2].text,
        },
        'Temperature': {
          'Room Temp in Celsius': _tempControllers[0].text,
        },
        'Power': {
          'Power Factor': _pfControllers[0].text,
        },
        'Current': {
          'IA': _currentControllers[0].text,
          'IB': _currentControllers[1].text,
          'IC': _currentControllers[2].text,
        },
      };

      await MongoDatabase.insert(measurementData, 'UPS 2 Unit 2 Measurement');
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
        ..._phaseAngle1Controllers,
      ..._phaseAngle2Controllers,
      ..._phaseAngle3Controllers,
      ..._phaseAngle4Controllers,
      ..._phaseAngle5Controllers,
      ..._phaseAngle6Controllers,
      ..._phaseAngle7Controllers,
      ..._phaseAngle8Controllers,
      ..._phaseAngle9Controllers,
      ..._phaseAngle10Controllers,
      ..._phaseAngle11Controllers,
      ..._phaseAngle12Controllers,
      ..._phaseAngle13Controllers,
      ..._phaseAngle14Controllers,
      ..._phaseAngle15Controllers,
      ..._phaseAngle16Controllers,
      ..._phaseAngle17Controllers,
      ..._phaseAngle18Controllers,
      
      
      
      ..._voltageControllers,
      ..._tempControllers,
      ..._pfControllers,
      ..._currentControllers,
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
              _buildTextField(_transformerNumberController, 'UPS Number',readOnly: true),
              _buildTextField(_unitController, 'Unit',readOnly: true),
              _buildTextField(_dateController, 'Date and Day',readOnly: true),
              _buildTextField(_timeController, 'Timing',readOnly: true),
              _buildTextField(_branchController, 'Branch',readOnly: true),
              SizedBox(height: 20.0),
              _buildSectionHeader(''),
              _buildSummaryTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('VOLTAGE'),
              _buildVoltTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('CURRENT'),
              _buildCurrTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('POWER'),
              _buildPowTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('TEMPERATURE'),
              _buildTempTable(),
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

  

  Widget _buildSummaryTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Bypass'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Voltage(V)'),
            _buildTableCell(_phaseAngle1Controllers[0],0,'bv'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Freq(HZ)'),
            _buildTableCell(_phaseAngle2Controllers[0],0,'bf'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('AB(V)'),
            _buildTableCell(_phaseAngle3Controllers[0],0,'bab'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('BC(V)'),
            _buildTableCell(_phaseAngle4Controllers[0],0,'bbc'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('CA(V)'),
            _buildTableCell(_phaseAngle5Controllers[0],0,'bca'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Input'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Voltage(V)'),
            _buildTableCell(_phaseAngle6Controllers[0],0,'iv'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Freq(HZ)'),
            _buildTableCell(_phaseAngle7Controllers[0],0,'if'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('AB(V)'),
            _buildTableCell(_phaseAngle8Controllers[0],0,'iab'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('BC(V)'),
            _buildTableCell(_phaseAngle9Controllers[0],0,'ibc'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('CA(V)'),
            _buildTableCell(_phaseAngle10Controllers[0],0,'ica'),
          ],
        ),    
        Row(
          children: [
            _buildTableHeaderCell(''),
            _buildTableHeaderCell('Voltage(V)'),
            _buildTableHeaderCell('Current(A)'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Battery'),
            _buildTableCell(_phaseAngle11Controllers[0],0,'batteryv'),
            _buildTableCell(_phaseAngle12Controllers[0],0,'batteryc'),
            
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Output'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Voltage(V)'),
            _buildTableCell(_phaseAngle13Controllers[0],0,'ov'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Freq(HZ)'),
            _buildTableCell(_phaseAngle14Controllers[0],0,'of'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('AB(V)'),
            _buildTableCell(_phaseAngle15Controllers[0],0,'oab'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('BC(V)'),
            _buildTableCell(_phaseAngle16Controllers[0],0,'obc'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('CA(V)'),
            _buildTableCell(_phaseAngle17Controllers[0],0,'oca'),
          ],
        ), 
        Row(
          children: [
            _buildTableHeaderCell('Current(A)'),
            _buildTableCell(_phaseAngle18Controllers[0],0,'ocur'),
          ],
        ),   
      ],
    );
  }

  Widget _buildVoltTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('AN'),
            _buildTableHeaderCell('BN'),
            _buildTableHeaderCell('CN'),
          ],
        ),
        Row(
          children: List.generate(3, (index) {
            return _buildTableCell(_voltageControllers[index],index,'vol');
          }),
        ),
      ],
    );
  }

  Widget _buildPowTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Power factor'),
            _buildTableCell(_pfControllers[0],0,'pf'),
          ],
        ),
      ],
    );
  }

  Widget _buildTempTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Room Temperature in celsius'),
            _buildTableCell(_tempControllers[0],0,'temp'),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('IA'),
            _buildTableHeaderCell('IB'),
            _buildTableHeaderCell('IC'),
          ],
        ),
        Row(
          children: List.generate(3, (index) {
            return _buildTableCell(_currentControllers[index],index,'current');
          }),
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
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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

