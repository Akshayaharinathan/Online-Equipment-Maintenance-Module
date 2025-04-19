import 'package:flutter/material.dart';
import './dbHelper/mongodbjsb.dart'; // Ensure this import is correct
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // Import for FilteringTextInputFormatter

class Generator3MeasurementPage extends StatefulWidget {
  @override
  _Generator3MeasurementPageState createState() =>
      _Generator3MeasurementPageState();
}

class _Generator3MeasurementPageState extends State<Generator3MeasurementPage> {
  final _GeneratorNumberController =
      TextEditingController(text: 'Generator-400kva,440V,50HZ');
  final _genm1unitController = TextEditingController();

  final _genm1dateController = TextEditingController();
  final _genm1timeController = TextEditingController();
  final _genm1branchController = TextEditingController(text: 'JSB');

  final _genm1totalControllers =
      List.generate(3, (index) => TextEditingController());
  final _genm1voltageControllers =
      List.generate(3, (index) => TextEditingController());
  final _genm1currentControllers =
      List.generate(3, (index) => TextEditingController());
  final _genm1powerControllers =
      List.generate(2, (index) => TextEditingController());
  final _genm1temperatureControllers =
      List.generate(2, (index) => TextEditingController()); // Adjusted to 3
  final _genm1frequencyControllers =
      List.generate(4, (index) => TextEditingController());
  final _powerControllers =
      List.generate(1, (index) => TextEditingController());

  final _minValues = {
    'volt': [0.0, 0.0, 0.0],
    'curr': [0.0, 0.0, 0.0],
    'pow': [0.0, 0.0],
    'tab': [75.0, 1495.0, 24.0, 48.0]
    //'temp': [0.0, 55.0]
  };
  final _maxValues = {
    'volt': [420.0, 420.0, 420.0],
    'curr': [556.0, 556.0, 556.0],
    'pow': [320.0, 400.0],
    'tab': [999.0, 1505.0, 27.0, 99.99]
    //'temp': [60.0, 92.0]
  };
  // Track if all fields are filled
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
        _genm1timeController.text = timeFormat.format(now);
      });
    });
  }

  @override
void dispose() {
  // Cancel the timer if it's still running
  _timer?.cancel();

  // Dispose all TextEditingController instances
  _GeneratorNumberController.dispose();
  _genm1unitController.dispose();
  _genm1dateController.dispose();
  _genm1timeController.dispose();
  _genm1branchController.dispose();

  for (var controller in [
    ..._genm1totalControllers,
    ..._genm1voltageControllers,
    ..._genm1currentControllers,
    ..._genm1powerControllers,
    ..._genm1temperatureControllers,
    ..._genm1frequencyControllers,
    ..._powerControllers,
  ]) {
    controller.dispose();
  }

  super.dispose();
}
  void _initializeDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd'); // Format for the date
    final timeFormat = DateFormat('HH:mm:ss'); // Format for the time

    _genm1dateController.text =
        dateFormat.format(now) + ' (${DateFormat('EEEE').format(now)})';
    _genm1timeController.text = timeFormat.format(now);
  }

  void _addListeners() {
    final controllers = [
      ..._genm1totalControllers,
      ..._genm1voltageControllers,
      ..._genm1currentControllers,
      ..._genm1powerControllers,
      ..._genm1temperatureControllers,
      ..._genm1frequencyControllers,
      ..._powerControllers
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
          text != '-'){
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
      _genm1voltageControllers,
      _minValues['volt']!,
      maxValues: _maxValues['volt'],
    );
    final currValid = _validateFieldGroup(
      _genm1currentControllers,
      _minValues['curr']!,
      maxValues: _maxValues['curr'],
    );
    final powValid = _validateFieldGroup(
      _genm1powerControllers,
      _minValues['pow']!,
      maxValues: _maxValues['pow'],
    );
    final tabValid = _validateFieldGroup(
      _genm1frequencyControllers,
      _minValues['tab']!,
      maxValues: _maxValues['tab'],
    );
    /*final tempValid = _validateFieldGroup(
      _genm1temperatureControllers,
      _minValues['temp']!,
      maxValues: _maxValues['temp'],
    );*/
    final powerKWHValid = _validateNumericFieldGroup(_powerControllers);
    final totalKVAHValid = _validateNumericFieldGroup(_genm1totalControllers);
    final tempValid=_validateNumericFieldGroup(_genm1temperatureControllers);

    setState(() {
      _isFormValid = voltValid &&
          currValid &&
          powValid &&
          tabValid &&
          powerKWHValid &&
          tempValid &&
          totalKVAHValid;
    });

    // Logging
    print('total  Valid: $totalKVAHValid');
    print('Volt Valid: $voltValid');
    print('Current Valid: $currValid');
    print('Power Valid: $powValid');
    print('power kwh Valid: $powerKWHValid');
    print('table Valid: $tabValid');
    print('Temp Valid: $tempValid');
    print('Form Valid: $_isFormValid');
  }

  Future<void> _handleSubmit() async {
    try {
      await MongoDatabase.connect();

      // Define headings for each measurement type
      final voltageHeadings = ['RY', 'YB', 'BR'];
      final currentHeadings = ['I1', 'I2', 'I3'];
      final powerHeadings = [
        'Real Power (p) - Total Watts',
        'Reactive Power (Q) - Total VA',
      ];
      final temperatureHeadings = [
        'Temp in Celsius',
        'Coolant temperature'
            'Engine Temperature',
      ];
      final totalHeadings = [
        'Total Hours Running',
        'Total Kwh Generated',
        'Diesel Consumption',
      ];
      final frequencyHeadings = [
        'Pressure(PSI)',
        'Speed(rpm)',
        'Battery Voltage',
        'Frequency'
      ];

      // Create measurement data with headings as keys
      final measurementData = {
        'generatorNumber': _GeneratorNumberController.text,
        'unit': _genm1unitController.text,
        'date': _genm1dateController.text,
        'time': _genm1timeController.text,
        'branch': _genm1branchController.text,
        'voltage': Map.fromIterables(
            voltageHeadings, _genm1voltageControllers.map((c) => c.text)),
        'current': Map.fromIterables(
            currentHeadings, _genm1currentControllers.map((c) => c.text)),
        'power': Map.fromIterables(
            powerHeadings, _genm1powerControllers.map((c) => c.text)),
        'temperature': Map.fromIterables(temperatureHeadings,
            _genm1temperatureControllers.map((c) => c.text)),
        'Table': Map.fromIterables(
            frequencyHeadings, _genm1frequencyControllers.map((c) => c.text)),
        'total': Map.fromIterables(
            totalHeadings, _genm1totalControllers.map((c) => c.text)),
      };

      await MongoDatabase.insert(measurementData, 'Generator 3 Measurement');

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Measurement submitted successfully!')));
      _resetForm();
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit measurement')));
    }
  }
  void _resetForm() {
    setState(() {
      for (var controller in [
        ..._genm1voltageControllers,
        ..._genm1currentControllers,
        ..._genm1powerControllers,
        ..._genm1temperatureControllers,
        ..._genm1frequencyControllers,
        ..._genm1totalControllers,
        ..._powerControllers,
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
              
              _buildTextField(_GeneratorNumberController, 'Generator Number',
                  readOnly: true),
              _buildTextField(_genm1unitController, 'Unit', readOnly: false),
              _buildTextField(_genm1dateController, 'Date and Day',
                  readOnly: true),
              _buildTextField(_genm1timeController, 'Time', readOnly: true),
              _buildTextField(_genm1branchController, 'Branch', readOnly: true),
              SizedBox(height: 20.0),
              _buildSectionHeader(''),
              _buildTotalTable(),
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
              _buildSectionHeader('TEMPERATURE'),
              _buildTemperatureTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader(''),
              _buildFrequencyTable(),
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
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTotalTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Total Hours Running'),
            _buildTableCell(_genm1totalControllers[0],0,'nl'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Total Kwh Generated'),
            _buildTableCell(_genm1totalControllers[1],1,'nl'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Diesel Consumption'),
            _buildTableCell(_genm1totalControllers[2],2,'nl'),
          ],
        ),
      ],
    );
  }

  Widget _buildVoltageTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('RY'),
            _buildTableCell(_genm1voltageControllers[0],0,'volt'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('YB'),
            _buildTableCell(_genm1voltageControllers[1],1,'volt'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('BR'),
            _buildTableCell(_genm1voltageControllers[2],2,'volt'),
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
            _buildTableHeaderCell('I1'),
            _buildTableCell(_genm1currentControllers[0],0,'curr'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('I2'),
            _buildTableCell(_genm1currentControllers[1],1,'curr'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('I3'),
            _buildTableCell(_genm1currentControllers[2],2,'curr'),
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
            _buildTableHeaderCell('Real Power(p) - Total Watts'),
            _buildTableCell(_genm1powerControllers[0],0,'pow'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Reactive Power (Q) - Total VA'),
            _buildTableCell(_genm1powerControllers[1],1,'pow'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Apparent Power (S) - Total VAR'),
            _buildTableCell(_powerControllers[0],0,'null'),
          ],
        ),
       /* Row(
          children: [
            _buildTableHeaderCell('KWH'),
            _buildTableCell(_powerControllers[1],1,'null'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('KVARH'),
            _buildTableCell(_powerControllers[2],2,'null'),
          ],
        ),*/
      ],
    );
  }
  Widget _buildTemperatureTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Coolant Temperature'),
            _buildTableCell(_genm1temperatureControllers[0],0,'temp'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Engine Temperature'),
            _buildTableCell(_genm1temperatureControllers[1],1,'temp'),
          ],
        ),
      ],
    );
  }

  Widget _buildFrequencyTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Pressure(PSI)'),
            _buildTableCell(_genm1frequencyControllers[0],0,'tab'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Speed(rpm)'),
            _buildTableCell(_genm1frequencyControllers[1],1,'tab'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Battery Voltage'),
            _buildTableCell(_genm1frequencyControllers[2],2,'tab'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Frequency'),
            _buildTableCell(_genm1frequencyControllers[3],3,'tab'),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String label) {
    return Expanded(
      child: Container(
        color: Colors.green[200],
        padding: EdgeInsets.all(8.0),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
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


