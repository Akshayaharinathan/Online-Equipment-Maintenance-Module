import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import './dbHelper/mongodbthusma.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Ensure this import is correct

class TMeasurementPage extends StatefulWidget {
  @override
  _TMeasurementPageState createState() => _TMeasurementPageState();
}

class _TMeasurementPageState extends State<TMeasurementPage> {
  final _transformerNumberController = TextEditingController(text: '800KVA');
  final _unitController = TextEditingController(text: '3 Phase');
  final _referenceNumberController = TextEditingController(text: '430V');
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _branchController = TextEditingController(text: 'THUSMA');
  final _voltControllers = List.generate(3, (index) => TextEditingController());
  final _currControllers = List.generate(3, (index) => TextEditingController());
  final _preControllers = List.generate(6, (index) => TextEditingController());
  final _cumulativeKWHControllers =
      List.generate(6, (index) => TextEditingController());
  final _cumulativeKVAHControllers =
      List.generate(6, (index) => TextEditingController());
  final _demandControllers =
      List.generate(6, (index) => TextEditingController());
  final _tempControllers = List.generate(1, (index) => TextEditingController());

  // Define min and max values for each field
  final _minValues = {
    'volt': [0.0, 0.0, 0.0],
    'curr': [0.0, 0.0, 0.0],
    'pre': [0.0, 0.0, 0.0, 0.50, 0.90, 48.0],
  };
  final _maxValues = {
    'volt': [70.0, 70.0, 70.0],
    'curr': [30.0, 30.0, 30.0],
    'pre': [0.900, 0.900, 0.35, 1.0, 1.0, 52.0],
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
      ..._voltControllers,
      ..._currControllers,
      ..._preControllers,
      ..._cumulativeKWHControllers,
      ..._tempControllers,
      ..._cumulativeKVAHControllers,
      ..._demandControllers,
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
    final voltValid = _validateFieldGroup(
      _voltControllers,
      _minValues['volt']!,
      maxValues: _maxValues['volt'],
    );
    final currValid = _validateFieldGroup(
      _currControllers,
      _minValues['curr']!,
      maxValues: _maxValues['curr'],
    );
    final preValid = _validateFieldGroup(
      _preControllers,
      _minValues['pre']!,
      maxValues: _maxValues['pre'],
    );
    final cumulativeKWHValid =
        _validateNumericFieldGroup(_cumulativeKWHControllers);
    final cumulativeKVAHValid =
        _validateNumericFieldGroup(_cumulativeKVAHControllers);
    final demandValid = _validateNumericFieldGroup(_demandControllers);
    final tempValid = _validateNumericFieldGroup(_tempControllers);

    setState(() {
      _isFormValid = voltValid &&
          currValid &&
          preValid &&
          cumulativeKWHValid &&
          cumulativeKVAHValid &&
          tempValid &&
          demandValid;
    });

    // Logging
    print('Volt Valid: $voltValid');
    print('Current Valid: $currValid');
    print('Present Valid: $preValid');
    print('Cumulative KWH Valid: $cumulativeKWHValid');
    print('Cumulative KVAH Valid: $cumulativeKVAHValid');
    print('Demand Valid: $demandValid');
    print('Temp Valid: $tempValid');
    print('Form Valid: $_isFormValid');
  }

  Future<void> _handleSubmit() async {
    try {
      await MongoDatabase.connect();

      // Define headings for each measurement type
      final voltageHeadings = ['V1', 'V2', 'V3'];
      final currentHeadings = ['I1', 'I2', 'I3'];
      final presentHeadings = [
        'Present KW',
        'Present KVA',
        'Present KVAR',
        'Present P.F',
        'Average P.F',
        'Average freq(HZ)'
      ];
      final cumulativeKWHHeadings = ['C', 'C1', 'C2', 'C3', 'C4', 'C5'];
      final cumulativeKVAHHeadings = ['C', 'C1', 'C2', 'C3', 'C4', 'C5'];
      final demandHeadings = ['C', 'r1', 'r2', 'r3', 'r4', 'r5'];
      final tempHeadings = ['Temperature'];

      // Create measurement data with headings as keys
      final measurementData = {
        'Transformer Rating': _transformerNumberController.text,
        'Phase': _unitController.text,
        'Spec': _referenceNumberController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'branch': _branchController.text,
        // Map values to their respective headings
        'voltage': Map.fromIterables(
            voltageHeadings, _voltControllers.map((c) => c.text)),
        'current': Map.fromIterables(
            currentHeadings, _currControllers.map((c) => c.text)),
        'present': Map.fromIterables(
            presentHeadings, _preControllers.map((c) => c.text)),
        'cumulativeKWH': Map.fromIterables(cumulativeKWHHeadings,
            _cumulativeKWHControllers.map((c) => c.text)),
        'cumulativeKVAH': Map.fromIterables(cumulativeKVAHHeadings,
            _cumulativeKVAHControllers.map((c) => c.text)),
        'demand': Map.fromIterables(
            demandHeadings, _demandControllers.map((c) => c.text)),
        'Temperature': Map.fromIterables(
            tempHeadings, _tempControllers.map((c) => c.text)),
      };

      await MongoDatabase.insert(measurementData, 'Transformer Measurement');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Measurement submitted successfully!')));
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit measurement')));
    }
  }

  @override
  void dispose() {
    // Dispose all the TextEditingControllers
    _transformerNumberController.dispose();
    _unitController.dispose();
    _referenceNumberController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _branchController.dispose();

    // Dispose the lists of controllers
    for (var controller in [
      ..._voltControllers,
      ..._currControllers,
      ..._preControllers,
      ..._tempControllers,
      ..._cumulativeKWHControllers,
      ..._cumulativeKVAHControllers,
      ..._demandControllers,
    ]) {
      controller.dispose();
    }

    // Cancel the timer
    _timer?.cancel();

    super.dispose();
  }

  void _resetForm() {
    setState(() {
      for (var controller in [
        ..._voltControllers,
        ..._currControllers,
        ..._preControllers,
        ..._tempControllers,
        ..._cumulativeKWHControllers,
        ..._cumulativeKVAHControllers,
        ..._demandControllers
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
              _buildTextField(_transformerNumberController, 'Rating',
                  readOnly: true),
              _buildTextField(_unitController, 'Phase', readOnly: true),
              _buildTextField(_referenceNumberController, 'Spec',
                  readOnly: true),
              _buildTextField(_dateController, 'Date and Day', readOnly: true),
              _buildTextField(_timeController, 'Time', readOnly: true),
              _buildTextField(_branchController, 'Branch', readOnly: true),
              SizedBox(height: 20.0),
              _buildSectionHeader('VOLTAGE'),
              _buildVoltageTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('CURRENT'),
              _buildCurrentTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('PRESENT'),
              _buildPresentTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('CUMULATIVE KVAH'),
              _buildkvahTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('CUMULATIVE KWH'),
              _buildkwhTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('CUMULATIVE DEMAND KVA'),
              _buildkvaTable(),
              SizedBox(height: 20.0),
              _buildSectionHeader('TEMPERATURE'),
              _buildTTable(),
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
        keyboardType: TextInputType.text,
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

  Widget _buildVoltageTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('V1'),
            _buildTableCell(_voltControllers[0], 0, 'volt'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V2'),
            _buildTableCell(_voltControllers[1], 1, 'volt'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('V3'),
            _buildTableCell(_voltControllers[2], 2, 'volt'),
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
            _buildTableCell(_currControllers[0], 0, 'curr'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('I2'),
            _buildTableCell(_currControllers[1], 1, 'curr'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('I3'),
            _buildTableCell(_currControllers[2], 2, 'curr'),
          ],
        ),
      ],
    );
  }

  Widget _buildPresentTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Present KW'),
            _buildTableCell(_preControllers[0], 0, 'pre'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Present KVA'),
            _buildTableCell(_preControllers[1], 1, 'pre'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('PRESENT KVAR'),
            _buildTableCell(_preControllers[2], 2, 'pre'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Present P.F'),
            _buildTableCell(_preControllers[3], 3, 'pre'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Average P.F'),
            _buildTableCell(_preControllers[4], 4, 'pre'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('Average Freq(HZ)'),
            _buildTableCell(_preControllers[5], 5, 'pre'),
          ],
        ),
      ],
    );
  }

  Widget _buildkvahTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('C'),
            _buildTableCell(_cumulativeKWHControllers[0], 0, 'kvah'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('C1'),
            _buildTableCell(_cumulativeKWHControllers[1], 1, 'kvah'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('C2'),
            _buildTableCell(_cumulativeKWHControllers[2], 2, 'kvah'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('C3'),
            _buildTableCell(_cumulativeKWHControllers[3], 3, 'kvah'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('C4'),
            _buildTableCell(_cumulativeKWHControllers[4], 4, 'kvah'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('C5'),
            _buildTableCell(_cumulativeKWHControllers[5], 5, 'kvah'),
          ],
        ),
      ],
    );
  }

  Widget _buildkwhTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('C'),
            _buildTableCell(_cumulativeKVAHControllers[0], 0, 'kwh'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('C1'),
            _buildTableCell(_cumulativeKVAHControllers[1], 1, 'kwh'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('C2'),
            _buildTableCell(_cumulativeKVAHControllers[2], 2, 'kwh'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('C3'),
            _buildTableCell(_cumulativeKVAHControllers[3], 3, 'kwh'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('C4'),
            _buildTableCell(_cumulativeKVAHControllers[4], 4, 'kwh'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('C5'),
            _buildTableCell(_cumulativeKVAHControllers[5], 5, 'kwh'),
          ],
        ),
      ],
    );
  }

  Widget _buildkvaTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('C'),
            _buildTableCell(_demandControllers[0], 0, 'kva'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('R1'),
            _buildTableCell(_demandControllers[1], 1, 'kva'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('R2'),
            _buildTableCell(_demandControllers[2], 2, 'kva'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('R3'),
            _buildTableCell(_demandControllers[3], 3, 'kva'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('R4'),
            _buildTableCell(_demandControllers[4], 4, 'kva'),
          ],
        ),
        Row(
          children: [
            _buildTableHeaderCell('R5'),
            _buildTableCell(_demandControllers[5], 5, 'kva'),
          ],
        ),
      ],
    );
  }

  Widget _buildTTable() {
    return Column(
      children: [
        Row(
          children: [
            _buildTableHeaderCell('Temperature'),
            _buildTableCell(_tempControllers[0], 0, 'temp'),
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

