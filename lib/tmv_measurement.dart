import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './dbHelper/mongodbthusma.dart';
import 'package:intl/intl.dart';
import 'dart:async'; 

class TMVMeasurementPage extends StatefulWidget {
  @override
  _TMVMeasurementPageState createState() => _TMVMeasurementPageState();
}

class _TMVMeasurementPageState extends State<TMVMeasurementPage> {
  final _mvmunitController = TextEditingController(text: 'MV Panel-1250 A/4P');
  final _mvmdateController = TextEditingController();
  final _mvmtimeController = TextEditingController();
  final _mvmbranchController = TextEditingController(text: 'THUSMA');




  final List<TextEditingController> _mvmvol1Controllers =
      List.generate(3, (index) => TextEditingController());
  final List<TextEditingController> _mvmvol2Controllers =
      List.generate(3, (index) => TextEditingController());
  final List<TextEditingController> _mvmphaseangle1Controllers = List.generate(1, (index) => TextEditingController());
  final List<TextEditingController> _mvmphaseangle2Controllers = List.generate(1, (index) => TextEditingController());
  final List<TextEditingController> _mvmphaseangle3Controllers = List.generate(1, (index) => TextEditingController());
  final List<TextEditingController> _mvmphaseangle4Controllers = List.generate(1, (index) => TextEditingController());
  final List<TextEditingController> _mvmphaseangle5Controllers = List.generate(1, (index) => TextEditingController());
  final List<TextEditingController> _mvmphaseangle6Controllers = List.generate(1, (index) => TextEditingController());
  //final List<TextEditingController> _mvmcurrent1Controllers =List.generate(1, (index) => TextEditingController()); 
  final List<TextEditingController> _mvmtotalHoursControllers =
      List.generate(3, (index) => TextEditingController());
  final List<TextEditingController> _mvmcurrentControllers =List.generate(3, (index) => TextEditingController()); 
  final List<TextEditingController> _mvmTHDControllers =
      List.generate(3, (index) => TextEditingController());
  final List<TextEditingController> _KFControllers = List.generate(1, (index) => TextEditingController());       
  final List<TextEditingController> _realControllers = List.generate(1, (index) => TextEditingController());
  final List<TextEditingController> _reactControllers = List.generate(1, (index) => TextEditingController());
  final List<TextEditingController> _appControllers = List.generate(1, (index) => TextEditingController());
  final List<TextEditingController> _powerFactorControllers = List.generate(1, (index) => TextEditingController());
  final List<TextEditingController> _frequencyControllers = List.generate(1, (index) => TextEditingController());
  final List<TextEditingController> _energyControllers = List.generate(1, (index) => TextEditingController());
  
  

 // Define min and max values for each field
  final _minValues = {
    'vol1': [0.0, 0.0, 0.0],
    'vol2': [0.0, 0.0, 0.0],
    'pa2': [0.0],
    'pa3': [0.0],
    'pa4':[0.0],
    'pa5':[0.0],
    'pa6':[0.0],
    'L1': [0.0, 0.0, 0.0],
    'cur': [0.0, 0.0, 0.0],
    'L2': [0.0, 0.0, 0.0],
    'real': [0.0],
    'react': [0.0],
    'app': [0.0],
    'pf': [0.0],
    'freq': [48.0],
  };
  final _maxValues = {
    'vol1': [433.0, 433.0, 433.0],
    'vol2': [245.0, 245.0, 245.0],
    'pa2': [245.0],
    'pa3': [125.0],
    'pa4':[99.99],
    'pa5':[99.99],
    'pa6':[99.99],
    'L1': [50.0, 50.0, 50.0],
    'cur': [1250.0, 1250.0, 1250.0],
    'L2': [50.0, 50.0, 50.0],
    'real': [930.0],
    'react': [950.0],
    'app': [300.0],
    'pf': [0.999],
    'freq': [52.0],  
    
  };

  bool _isFormValid = false;
  Timer? _timer; 

  @override
  void initState() {
    super.initState();
    _addListeners();
    _initializeDateTime();
    _startTimer();
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');
    _mvmdateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _mvmtimeController.text = timeFormat.format(now);
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        final timeFormat = DateFormat('HH:mm:ss');
        _mvmtimeController.text = timeFormat.format(now);
      });
    });
  }

  @override
void dispose() {
  // Dispose all the TextEditingControllers to avoid memory leaks
  _mvmunitController.dispose();
  _mvmdateController.dispose();
  _mvmtimeController.dispose();
  _mvmbranchController.dispose();

  for (var controller in [
    ..._mvmvol1Controllers,
    ..._mvmvol2Controllers,
    ..._mvmphaseangle1Controllers,
    ..._mvmphaseangle2Controllers,
    ..._mvmphaseangle3Controllers,
    ..._mvmphaseangle4Controllers,
    ..._mvmphaseangle5Controllers,
    ..._mvmphaseangle6Controllers,
    ..._mvmtotalHoursControllers,
    ..._mvmcurrentControllers,
    ..._mvmTHDControllers,
    ..._KFControllers,
    ..._realControllers,
    ..._reactControllers,
    ..._appControllers,
    ..._powerFactorControllers,
    ..._frequencyControllers,
    ..._energyControllers,
  ]) {
    controller.dispose();
  }

  // Cancel the timer if it's active
  _timer?.cancel();

  super.dispose();
}



  void _addListeners() {
    final controllers = [
     
      _mvmunitController,
      _mvmtimeController,
      _mvmdateController,
      _mvmbranchController,
      ..._mvmvol1Controllers,
      ..._mvmvol2Controllers,
      ..._mvmphaseangle1Controllers,
      ..._mvmphaseangle2Controllers,
      ..._mvmphaseangle3Controllers,
      ..._mvmphaseangle4Controllers,
      ..._mvmphaseangle5Controllers,
      ..._mvmphaseangle6Controllers,
      ..._mvmtotalHoursControllers,
      ..._mvmcurrentControllers,
      ..._mvmTHDControllers,
      ..._KFControllers,
      ..._realControllers,
      ..._reactControllers,
      ..._appControllers,
      ..._powerFactorControllers,
      ..._frequencyControllers,
      ..._energyControllers,
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


    final vol1Valid = _validateFieldGroup(
      _mvmvol1Controllers,
      _minValues['vol1']!,
      maxValues: _maxValues['vol1'],
    );

    final vol2Valid = _validateFieldGroup(
      _mvmvol2Controllers,
      _minValues['vol2']!,
      maxValues: _maxValues['vol2'],
    );

    final pa2Valid = _validateFieldGroup(
      _mvmphaseangle2Controllers,
      _minValues['pa2']!,
      maxValues: _maxValues['pa2'],
    );

    final pa3Valid = _validateFieldGroup(
      _mvmphaseangle3Controllers,
      _minValues['pa3']!,
      maxValues: _maxValues['pa3'],
    );

    final L1Valid = _validateFieldGroup(
      _mvmtotalHoursControllers,
      _minValues['L1']!,
      maxValues: _maxValues['L1'],
    );

    final curValid = _validateFieldGroup(
      _mvmcurrentControllers,
      _minValues['cur']!,
      maxValues: _maxValues['cur'],
    );

    final L2Valid = _validateFieldGroup(
      _mvmTHDControllers,
      _minValues['L2']!,
      maxValues: _maxValues['L2'],
    );

    final realValid = _validateFieldGroup(
      _realControllers,
      _minValues['real']!,
      maxValues: _maxValues['real'],
    );

    final reactValid = _validateFieldGroup(
      _reactControllers,
      _minValues['react']!,
      maxValues: _maxValues['react'],
    );

    final appValid = _validateFieldGroup(
      _appControllers,
      _minValues['app']!,
      maxValues: _maxValues['app'],
    );

    final pfValid = _validateFieldGroup(
      _powerFactorControllers,
      _minValues['pf']!,
      maxValues: _maxValues['pf'],
    );

    final freqValid = _validateFieldGroup(
      _frequencyControllers,
      _minValues['freq']!,
      maxValues: _maxValues['freq'],
    );
   /* final c1Valid=
        _validateNumericFieldGroup(_mvmcurrent1Controllers);*/
    
    final pa1Valid =
        _validateNumericFieldGroup(_mvmphaseangle1Controllers);
    final pa4Valid =
        _validateNumericFieldGroup(_mvmphaseangle4Controllers);
    final pa5Valid =
        _validateNumericFieldGroup(_mvmphaseangle5Controllers);
    final pa6Valid =
        _validateNumericFieldGroup(_mvmphaseangle6Controllers);

    final KFValid =
        _validateNumericFieldGroup(_KFControllers); 

    final energyValid =
        _validateNumericFieldGroup(_energyControllers);        

    
    setState(() {
      _isFormValid = vol1Valid &&
          vol2Valid &&
          pa1Valid &&
          pa2Valid &&
          pa3Valid &&
          pa4Valid &&
          pa5Valid &&
          pa6Valid &&
         // c1Valid &&
          L1Valid &&
          L2Valid &&
          curValid &&
          KFValid &&
          realValid &&
          reactValid &&
          appValid &&
          pfValid &&
          freqValid &&
          energyValid;        
    });

    // Logging
    print('Voltage Valid: $vol1Valid');
    print('Voltage Valid: $vol2Valid');
    print('phaseangle Valid: $pa1Valid');
    print('phaseangle Valid: $pa2Valid');
    print('phaseangle Valid: $pa3Valid');
    print('%THD: $L1Valid');
    print('current: $curValid');
    print('%THD: $L2Valid');
    print('K factor: $KFValid');
    print('realpower: $realValid');
    print('reactivepower: $reactValid');
    print('apparentpower: $appValid');
    print('powerfactor: $pfValid');
    print('frequency: $freqValid');
    print('energy: $energyValid');
    print('Form Valid: $_isFormValid');
    
  }

  Future<void> _handleSubmit() async {
    try {
      await MongoDatabase.connect();


       // Define headings for each measurement type
      /*final voltagelinelineHeadings = ['RY', 'YB', 'BR'];
      final voltagelineneutralHeadings = ['RN', 'YN', 'BN'];
      final pa1Headings = [''];
      final pa2Headings = [''];
      final pa3Headings = [''];
      final VTHDHeadings = ['L1', 'L2', 'L3'];
      final currentHeadings = ['R', 'Y', 'B', 'N'];
      final CTHDHeadings = ['L1', 'L2', 'L3'];
      final KFHeadings = [''];
      final realpowerHeadings = [''];
      final reactivepowerHeadings = [''];
      final apparentpowerHeadings = [''];
      final powerfactorHeadings = [''];
      final frequencyHeadings = [''];
      final energyHeadings = [''];*/




      final measurementData = {
        'unit': _mvmunitController.text,
        'date': _mvmdateController.text,
        'time': _mvmtimeController.text,
        'branch': _mvmbranchController.text,
        'VoltageOutput': {
         // 'Voltage Line-Line': _mvmvol1Controllers[0].text,
          'Voltage RY': _mvmvol1Controllers[0].text,
          'Voltage YB': _mvmvol1Controllers[1].text,
          'Voltage BR': _mvmvol1Controllers[2].text,
          //'Voltage Line-Neutral': _mvmvol2Controllers[0].text,
          'Voltage RN': _mvmvol2Controllers[0].text,
          'Voltage YN': _mvmvol2Controllers[1].text,
          'Voltage BN': _mvmvol2Controllers[2].text,
          'Voltage Phase Angle R': _mvmphaseangle1Controllers[0].text,
          'Voltage Phase Angle Y': _mvmphaseangle2Controllers[0].text,
          'Voltage Phase Angle B': _mvmphaseangle3Controllers[0].text,
          'Voltage %THDv L1': _mvmtotalHoursControllers[0].text,
          'Voltage %THDv L2': _mvmtotalHoursControllers[1].text,
          'Voltage %THDv L3': _mvmtotalHoursControllers[2].text,
        },
        'CurrentOutput': {
          
          'Current R': _mvmcurrentControllers[0].text,
          'Current Y': _mvmcurrentControllers[1].text,
          'Current B': _mvmcurrentControllers[2].text,

          'Current Phase Angle R': _mvmphaseangle4Controllers[0].text,
          'Current Phase Angle Y': _mvmphaseangle5Controllers[0].text,
          'Current Phase Angle B': _mvmphaseangle6Controllers[0].text,


         // 'Current N': _mvmcurrent1Controllers[0].text,
          'Current %THDi L1': _mvmTHDControllers[0].text,
          'Current %THDi L2': _mvmTHDControllers[1].text,
          'Current %THDi L3': _mvmTHDControllers[2].text,
          'Current K-Factor': _KFControllers[0].text,
        },
        'Power': {
          'ReactivePower(Q)-Total KVA': _reactControllers[0].text,
          'RealPower(Q)-Total KW': _realControllers[0].text,
          'ApparentPower(S)-Total KVAR': _appControllers[0].text,
          'Frequency': _frequencyControllers[0].text,
          'PowerFctor': _powerFactorControllers[0].text,
          'Energy(KWH)': _energyControllers[0].text
        },
      };
      await MongoDatabase.insert(measurementData, 'MV measurements');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Measurement submitted successfully!')),
      );
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit measurement')),
      );
    }
  }

  void _resetForm() {
    for (var controller in [
      ..._mvmvol1Controllers,
      ..._mvmvol2Controllers,
      ..._mvmphaseangle1Controllers,
      ..._mvmphaseangle2Controllers,
      ..._mvmphaseangle3Controllers,
      ..._mvmphaseangle4Controllers,
      ..._mvmphaseangle5Controllers,
      ..._mvmphaseangle6Controllers,
      ..._mvmtotalHoursControllers,
      ..._mvmcurrentControllers,
      ..._mvmTHDControllers,
      ..._KFControllers,
      ..._realControllers,
      ..._reactControllers,
      ..._appControllers,
      ..._powerFactorControllers,
      ..._frequencyControllers,
      ..._energyControllers,
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
              _buildTextField(_mvmunitController, 'Unit', readOnly: true),
              _buildTextField(_mvmdateController, 'Date and Day', readOnly: true),
              _buildTextField(_mvmtimeController, 'Timing', readOnly: true),
              _buildTextField(_mvmbranchController, 'Branch', readOnly: true),
              SizedBox(height: 20.0),
              _buildSectionHeader('VOLTAGE'),
              _buildVoltageTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('CURRENT'),
              _buildCurrentTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('POWER'),
              _buildPowerTable(),
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

  /*Widget _buildTextField(TextEditingController controller, String labelText,
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
        ),
        readOnly: readOnly,
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
            _buildTableHeaderCell('Line-Line'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('RY'),
            _buildTableCell(_mvmvol1Controllers[0],0,'vol1'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('YB'),
            _buildTableCell(_mvmvol1Controllers[1],1,'vol1'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('BR'),
            _buildTableCell(_mvmvol1Controllers[2],2,'vol1'),
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
            _buildTableCell(_mvmvol2Controllers[0],0,'vol2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('YN'),
            _buildTableCell(_mvmvol2Controllers[1],1,'vol2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('BN'),
            _buildTableCell(_mvmvol2Controllers[2],2,'vol2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Voltage Phase Angle'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('R'),
            _buildTableCell(_mvmphaseangle1Controllers[0],0,'pa1'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Y'),
            _buildTableCell(_mvmphaseangle2Controllers[0],0,'pa2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('B'),
            _buildTableCell(_mvmphaseangle3Controllers[0],0,'pa3'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('% THDv'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('L1'),
            _buildTableCell(_mvmtotalHoursControllers[0],0,'L1'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('L2'),
            _buildTableCell(_mvmtotalHoursControllers[1],1,'L1'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('L3'),
            _buildTableCell(_mvmtotalHoursControllers[2],2,'L1'),
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
            _buildTableHeaderCell('Line'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('R'),
            _buildTableCell(_mvmcurrentControllers[0],0,'cur'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Y'),
            _buildTableCell(_mvmcurrentControllers[1],1,'cur'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('B'),
            _buildTableCell(_mvmcurrentControllers[2],2,'cur'),
          ],
        ), 


         Row(
          children: [
            _buildTableHeaderCell('Current Phase Angle'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('R'),
            _buildTableCell(_mvmphaseangle4Controllers[0],0,'pa4'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Y'),
            _buildTableCell(_mvmphaseangle5Controllers[0],0,'pa5'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('B'),
            _buildTableCell(_mvmphaseangle6Controllers[0],0,'pa6'),
          ],
        ),











        
         
       /* Row(
          children: [
            _buildTableHeaderCell('N'),
            _buildTableCell(_mvmcurrent1Controllers[0],0,'cur1'),
          ],
        ),  */  
        Row(
          children: [
            _buildTableHeaderCell('% THDi'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('L1'),
            _buildTableCell(_mvmTHDControllers[0],0,'L2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('L2'),
            _buildTableCell(_mvmTHDControllers[1],1,'L2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('L3'),
            _buildTableCell(_mvmTHDControllers[2],2,'L2'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('K-Factor'),
            _buildTableCell(_KFControllers[0],0,'kf'),
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
            _buildTableHeaderCell('Real Power(P)-Total KW'),
            _buildTableCell(_realControllers[0],0,'real'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Reactive Power(Q)-Total KVA'),
            _buildTableCell(_reactControllers[0],0,'react'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Apparent Power(S)-Total KVAR'),
            _buildTableCell(_appControllers[0],0,'app'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Frequency'),
            _buildTableCell(_frequencyControllers[0],0,'freq'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Power Factor'),
            _buildTableCell(_powerFactorControllers[0],0,'pf'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Energy KWH'),
            _buildTableCell(_energyControllers[0],0,'energy'),
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


