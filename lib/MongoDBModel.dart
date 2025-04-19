import 'package:mongo_dart/mongo_dart.dart';

class MongoDBModel {
  final ObjectId id;
  final String username;
  final String password;
  final String branch;

  MongoDBModel({
    required this.id,
    required this.username,
    required this.password,
    required this.branch,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'password': password,
      'branch': branch,
    };
  }
}



class TransformerMeasurementModel {
  final ObjectId id;
  final String transformerId;
  final DateTime date;
  final double voltage;
  final double current;
  final double temperature;
  final String remarks;

  TransformerMeasurementModel({
    required this.id,
    required this.transformerId,
    required this.date,
    required this.voltage,
    required this.current,
    required this.temperature,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'transformerId': transformerId,
      'date': date.toIso8601String(),
      'voltage': voltage,
      'current': current,
      'temperature': temperature,
      'remarks': remarks,
    };
  }

  factory TransformerMeasurementModel.fromJson(Map<String, dynamic> json) {
    return TransformerMeasurementModel(
      id: json['_id'] as ObjectId,
      transformerId: json['transformerId'] as String,
      date: DateTime.parse(json['date'] as String),
      voltage: json['voltage'] as double,
      current: json['current'] as double,
      temperature: json['temperature'] as double,
      remarks: json['remarks'] as String,
    );
  }
}





class TransformerChecklistModel {
  final ObjectId id;
  final String transformerId;
  final DateTime date;
  final bool isChecked;
  final String remarks;

  TransformerChecklistModel({
    required this.id,
    required this.transformerId,
    required this.date,
    required this.isChecked,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'transformerId': transformerId,
      'date': date.toIso8601String(),
      'isChecked': isChecked,
      'remarks': remarks,
    };
  }

  factory TransformerChecklistModel.fromJson(Map<String, dynamic> json) {
    return TransformerChecklistModel(
      id: json['_id'] as ObjectId,
      transformerId: json['transformerId'] as String,
      date: DateTime.parse(json['date'] as String),
      isChecked: json['isChecked'] as bool,
      remarks: json['remarks'] as String,
    );
  }
}


class Generator1Checklist {
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<ChecklistItem> checklist;

  Generator1Checklist({
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }
}

class ChecklistItem {
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  ChecklistItem({
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }
}


class Generator1Measurement {
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final String voltage;
  final List<String> current;
  final String totalHours;
  final String totalKwh;
  final String dieselConsumption;
  final List<String> power;
  final List<String> temperature;
  final List<String> frequency;
  final List<String> controller;

  Generator1Measurement({
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.voltage,
    required this.current,
    required this.totalHours,
    required this.totalKwh,
    required this.dieselConsumption,
    required this.power,
    required this.temperature,
    required this.frequency,
    required this.controller,
  });

  Map<String, dynamic> toMap() {
    return {
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'voltage': voltage,
      'current': current,
      'totalHours': totalHours,
      'totalKwh': totalKwh,
      'dieselConsumption': dieselConsumption,
      'power': power,
      'temperature': temperature,
      'frequency': frequency,
      'controller': controller,
    };
  }

  factory Generator1Measurement.fromMap(Map<String, dynamic> map) {
    return Generator1Measurement(
      transformerNumber: map['transformerNumber'] ?? '',
      unit: map['unit'] ?? '',
      referenceNumber: map['referenceNumber'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      branch: map['branch'] ?? '',
      voltage: map['voltage'] ?? '',
      current: List<String>.from(map['current'] ?? []),
      totalHours: map['totalHours'] ?? '',
      totalKwh: map['totalKwh'] ?? '',
      dieselConsumption: map['dieselConsumption'] ?? '',
      power: List<String>.from(map['power'] ?? []),
      temperature: List<String>.from(map['temperature'] ?? []),
      frequency: List<String>.from(map['frequency'] ?? []),
      controller: List<String>.from(map['controller'] ?? []),
    );
  }
}




class Generator2Checklist {
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<Map<String, dynamic>> checklist;

  Generator2Checklist({
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toJson() {
    return {
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist,
    };
  }

  static Generator2Checklist fromJson(Map<String, dynamic> json) {
    return Generator2Checklist(
      transformerNumber: json['transformerNumber'] ?? '',
      unit: json['unit'] ?? '',
      referenceNumber: json['referenceNumber'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      branch: json['branch'] ?? '',
      checklist: List<Map<String, dynamic>>.from(json['checklist'] ?? []),
    );
  }
}



class Generator2Measurement {
  final ObjectId id;
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<String> voltage;
  final List<String> current;
  final List<String> power;
  final List<String> temperature;
  final List<String> frequency;

  Generator2Measurement({
    required this.id,
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.voltage,
    required this.current,
    required this.power,
    required this.temperature,
    required this.frequency,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'voltage': voltage,
      'current': current,
      'power': power,
      'temperature': temperature,
      'frequency': frequency,
    };
  }

  factory Generator2Measurement.fromMap(Map<String, dynamic> map) {
    return Generator2Measurement(
      id: map['_id'] as ObjectId,
      transformerNumber: map['transformerNumber'] as String,
      unit: map['unit'] as String,
      referenceNumber: map['referenceNumber'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      voltage: List<String>.from(map['voltage']),
      current: List<String>.from(map['current']),
      power: List<String>.from(map['power']),
      temperature: List<String>.from(map['temperature']),
      frequency: List<String>.from(map['frequency']),
    );
  }
}





class Generator3Measurement {
  final ObjectId id;
  final String generatorNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<Generator3ChecklistItem> checklist;

  Generator3Measurement({
    required this.id,
    required this.generatorNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  factory Generator3Measurement.fromMap(Map<String, dynamic> map) {
    return Generator3Measurement(
      id: map['_id'],
      generatorNumber: map['generatorNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<Generator3ChecklistItem>.from(map['checklist'].map((item) => Generator3ChecklistItem.fromMap(item))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'generatorNumber': generatorNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }
}

class Generator3ChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  Generator3ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  factory Generator3ChecklistItem.fromMap(Map<String, dynamic> map) {
    return Generator3ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }
}



class MVChecklistModel {
  final ObjectId id;
  final String mvNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<MVChecklistItem> checklist;

  MVChecklistModel({
    required this.id,
    required this.mvNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  factory MVChecklistModel.fromMap(Map<String, dynamic> map) {
    return MVChecklistModel(
      id: map['_id'] as ObjectId,
      mvNumber: map['MVNumber'] as String,
      unit: map['unit'] as String,
      referenceNumber: map['referenceNumber'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      checklist: List<MVChecklistItem>.from(map['checklist']?.map((item) => MVChecklistItem.fromMap(item))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'MVNumber': mvNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }
}

class MVChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  MVChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  factory MVChecklistItem.fromMap(Map<String, dynamic> map) {
    return MVChecklistItem(
      title: map['title'] as String,
      isYesChecked: map['isYesChecked'] as bool,
      isNoChecked: map['isNoChecked'] as bool,
      remarks: map['remarks'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }
}


class MVMeasurement {
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<String> voltage;
  final List<String> current;
  final List<String> present;
  final List<String> demand;

  MVMeasurement({
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.voltage,
    required this.current,
    required this.present,
    required this.demand,
  });

  Map<String, dynamic> toMap() {
    return {
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'voltage': voltage,
      'current': current,
      'present': present,
      'demand': demand,
    };
  }

  factory MVMeasurement.fromMap(Map<String, dynamic> map) {
    return MVMeasurement(
      transformerNumber: map['transformerNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      voltage: List<String>.from(map['voltage']),
      current: List<String>.from(map['current']),
      present: List<String>.from(map['present']),
      demand: List<String>.from(map['demand']),
    );
  }
}




// MongoDBModel.dart

class DGChecklistModel {
  final ObjectId id;
  final String dgNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<DGChecklistItem> checklist;

  DGChecklistModel({
    required this.id,
    required this.dgNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  factory DGChecklistModel.fromMap(Map<String, dynamic> map) {
    return DGChecklistModel(
      id: map['_id'] as ObjectId,
      dgNumber: map['DGNumber'] as String,
      unit: map['unit'] as String,
      referenceNumber: map['referenceNumber'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      checklist: List<DGChecklistItem>.from(map['checklist']?.map((item) => DGChecklistItem.fromMap(item))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'DGNumber': dgNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }
}

class DGChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  DGChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  factory DGChecklistItem.fromMap(Map<String, dynamic> map) {
    return DGChecklistItem(
      title: map['title'] as String,
      isYesChecked: map['isYesChecked'] as bool,
      isNoChecked: map['isNoChecked'] as bool,
      remarks: map['remarks'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }
}



// MongoDBModel.dart



class DGMeasurementModel {
  final ObjectId id;
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final String totalHours;
  final String totalKwh;
  final String dieselConsumption;
  final List<String> voltage;
  final List<String> current;
  final List<String> power;
  final List<String> temperature;
  final List<String> phaseAngle;
  final String powerFactor;

  DGMeasurementModel({
    required this.id,
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.totalHours,
    required this.totalKwh,
    required this.dieselConsumption,
    required this.voltage,
    required this.current,
    required this.power,
    required this.temperature,
    required this.phaseAngle,
    required this.powerFactor,
  });

  factory DGMeasurementModel.fromMap(Map<String, dynamic> map) {
    return DGMeasurementModel(
      id: map['_id'] as ObjectId,
      transformerNumber: map['transformerNumber'] as String,
      unit: map['unit'] as String,
      referenceNumber: map['referenceNumber'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      totalHours: map['totalHours'] as String,
      totalKwh: map['totalKwh'] as String,
      dieselConsumption: map['dieselConsumption'] as String,
      voltage: List<String>.from(map['voltage']),
      current: List<String>.from(map['current']),
      power: List<String>.from(map['power']),
      temperature: List<String>.from(map['temperature']),
      phaseAngle: List<String>.from(map['phaseAngle']),
      powerFactor: map['powerFactor'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'totalHours': totalHours,
      'totalKwh': totalKwh,
      'dieselConsumption': dieselConsumption,
      'voltage': voltage,
      'current': current,
      'power': power,
      'temperature': temperature,
      'phaseAngle': phaseAngle,
      'powerFactor': powerFactor,
    };
  }
}




class UPSU1ChecklistModel {
  final ObjectId id;
  final String upsU1Number;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<UPSU1ChecklistItem> checklist;

  UPSU1ChecklistModel({
    required this.id,
    required this.upsU1Number,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  factory UPSU1ChecklistModel.fromMap(Map<String, dynamic> map) {
    return UPSU1ChecklistModel(
      id: map['_id'] as ObjectId,
      upsU1Number: map['upsU1Number'] as String,
      unit: map['unit'] as String,
      referenceNumber: map['referenceNumber'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      checklist: List<UPSU1ChecklistItem>.from(map['checklist']?.map((item) => UPSU1ChecklistItem.fromMap(item))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'upsU1Number': upsU1Number,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }
}

class UPSU1ChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  UPSU1ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  factory UPSU1ChecklistItem.fromMap(Map<String, dynamic> map) {
    return UPSU1ChecklistItem(
      title: map['title'] as String,
      isYesChecked: map['isYesChecked'] as bool,
      isNoChecked: map['isNoChecked'] as bool,
      remarks: map['remarks'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }
}



class UPSU2ChecklistModel {
  final ObjectId id;
  final String upsU2Number;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<UPSU2ChecklistItem> checklist;

  UPSU2ChecklistModel({
    required this.id,
    required this.upsU2Number,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  factory UPSU2ChecklistModel.fromMap(Map<String, dynamic> map) {
    return UPSU2ChecklistModel(
      id: map['_id'] as ObjectId,
      upsU2Number: map['upsU2Number'] as String,
      unit: map['unit'] as String,
      referenceNumber: map['referenceNumber'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      checklist: List<UPSU2ChecklistItem>.from(map['checklist']?.map((item) => UPSU2ChecklistItem.fromMap(item))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'upsU2Number': upsU2Number,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }
}

class UPSU2ChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  UPSU2ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  factory UPSU2ChecklistItem.fromMap(Map<String, dynamic> map) {
    return UPSU2ChecklistItem(
      title: map['title'] as String,
      isYesChecked: map['isYesChecked'] as bool,
      isNoChecked: map['isNoChecked'] as bool,
      remarks: map['remarks'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }
}




class UPSU3ChecklistModel {
  final ObjectId id;
  final String upsU3Number;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<UPSU3ChecklistItem> checklist;

  UPSU3ChecklistModel({
    required this.id,
    required this.upsU3Number,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  factory UPSU3ChecklistModel.fromMap(Map<String, dynamic> map) {
    return UPSU3ChecklistModel(
      id: map['_id'] as ObjectId,
      upsU3Number: map['upsu3Number'] as String,
      unit: map['unit'] as String,
      referenceNumber: map['referenceNumber'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      checklist: List<UPSU3ChecklistItem>.from(map['checklist']?.map((item) => UPSU3ChecklistItem.fromMap(item))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'upsu3Number': upsU3Number,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }
}

class UPSU3ChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  UPSU3ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  factory UPSU3ChecklistItem.fromMap(Map<String, dynamic> map) {
    return UPSU3ChecklistItem(
      title: map['title'] as String,
      isYesChecked: map['isYesChecked'] as bool,
      isNoChecked: map['isNoChecked'] as bool,
      remarks: map['remarks'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }
}





class UPSU1MeasurementModel {
  String upsNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  String totalHours;
  String totalKwh;
  String dieselConsumption;
  List<String> output;
  List<String> current;
  List<String> power;
  List<String> temperature;
  List<String> phaseAngle;
  String frequency;
  String powerFactor;

  UPSU1MeasurementModel({
    required this.upsNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.totalHours,
    required this.totalKwh,
    required this.dieselConsumption,
    required this.output,
    required this.current,
    required this.power,
    required this.temperature,
    required this.phaseAngle,
    required this.frequency,
    required this.powerFactor,
  });

  // Convert a UPSU1MeasurementModel instance to a Map for MongoDB
  Map<String, dynamic> toMap() {
    return {
      'UPSNumber': upsNumber,
      'Unit': unit,
      'ReferenceNumber': referenceNumber,
      'Date': date,
      'Time': time,
      'Branch': branch,
      'TotalHours': totalHours,
      'TotalKwh': totalKwh,
      'DieselConsumption': dieselConsumption,
      'Output': output,
      'Current': current,
      'Power': power,
      'Temperature': temperature,
      'PhaseAngle': phaseAngle,
      'Frequency': frequency,
      'PowerFactor': powerFactor,
    };
  }

  // Convert a Map from MongoDB to a UPSU1MeasurementModel instance
  factory UPSU1MeasurementModel.fromMap(Map<String, dynamic> map) {
    return UPSU1MeasurementModel(
      upsNumber: map['UPSNumber'],
      unit: map['Unit'],
      referenceNumber: map['ReferenceNumber'],
      date: map['Date'],
      time: map['Time'],
      branch: map['Branch'],
      totalHours: map['TotalHours'],
      totalKwh: map['TotalKwh'],
      dieselConsumption: map['DieselConsumption'],
      output: List<String>.from(map['Output']),
      current: List<String>.from(map['Current']),
      power: List<String>.from(map['Power']),
      temperature: List<String>.from(map['Temperature']),
      phaseAngle: List<String>.from(map['PhaseAngle']),
      frequency: map['Frequency'],
      powerFactor: map['PowerFactor'],
    );
  }
}





// Model class for UPS2 Measurement
class UPS2Measurement {
  String transformerNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<String> voltage;
  List<String> current;
  List<String> present;
  String cumulativeKWH;
  String cumulativeKVAH;
  String demand;

  UPS2Measurement({
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.voltage,
    required this.current,
    required this.present,
    required this.cumulativeKWH,
    required this.cumulativeKVAH,
    required this.demand,
  });

  // Convert a UPS2Measurement instance to a Map for MongoDB insertion
  Map<String, dynamic> toMap() {
    return {
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'voltage': voltage,
      'current': current,
      'present': present,
      'cumulativeKWH': cumulativeKWH,
      'cumulativeKVAH': cumulativeKVAH,
      'demand': demand,
    };
  }

  // Create a UPS2Measurement instance from a Map
  factory UPS2Measurement.fromMap(Map<String, dynamic> map) {
    return UPS2Measurement(
      transformerNumber: map['transformerNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      voltage: List<String>.from(map['voltage']),
      current: List<String>.from(map['current']),
      present: List<String>.from(map['present']),
      cumulativeKWH: map['cumulativeKWH'],
      cumulativeKVAH: map['cumulativeKVAH'],
      demand: map['demand'],
    );
  }
}



class UPSU3MeasurementModel {
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<String> voltage;
  final List<String> current;
  final List<String> power;
  final List<String> temperature;
  final List<String> phaseAngle;
  final String frequency;
  final String powerFactor;

  UPSU3MeasurementModel({
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.voltage,
    required this.current,
    required this.power,
    required this.temperature,
    required this.phaseAngle,
    required this.frequency,
    required this.powerFactor,
  });

  // Method to convert the model to a Map for MongoDB
  Map<String, dynamic> toMap() {
    return {
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'voltage': voltage,
      'current': current,
      'power': power,
      'temperature': temperature,
      'phaseAngle': phaseAngle,
      'frequency': frequency,
      'powerFactor': powerFactor,
    };
  }

  // Factory method to create an instance from a Map
  factory UPSU3MeasurementModel.fromMap(Map<String, dynamic> map) {
    return UPSU3MeasurementModel(
      transformerNumber: map['transformerNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      voltage: List<String>.from(map['voltage']),
      current: List<String>.from(map['current']),
      power: List<String>.from(map['power']),
      temperature: List<String>.from(map['temperature']),
      phaseAngle: List<String>.from(map['phaseAngle']),
      frequency: map['frequency'],
      powerFactor: map['powerFactor'],
    );
  }
}


class UPSU4ChecklistModel {
  final String upsu4Number;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<UPSU4ChecklistItem> checklist;

  UPSU4ChecklistModel({
    required this.upsu4Number,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  // Method to convert the model to a Map for MongoDB
  Map<String, dynamic> toMap() {
    return {
      'upsu4Number': upsu4Number,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  // Factory method to create an instance from a Map
  factory UPSU4ChecklistModel.fromMap(Map<String, dynamic> map) {
    return UPSU4ChecklistModel(
      upsu4Number: map['upsu4Number'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<UPSU4ChecklistItem>.from(map['checklist'].map((item) => UPSU4ChecklistItem.fromMap(item))),
    );
  }
}

class UPSU4ChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  UPSU4ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  // Method to convert the checklist item to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  // Factory method to create a checklist item from a Map
  factory UPSU4ChecklistItem.fromMap(Map<String, dynamic> map) {
    return UPSU4ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}


class UPSU4MeasurementModel {
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<String> phaseAngle;
  final List<String> output;

  UPSU4MeasurementModel({
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.phaseAngle,
    required this.output,
  });

  // Method to convert the model to a Map for MongoDB
  Map<String, dynamic> toMap() {
    return {
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'phaseAngle': phaseAngle,
      'output': output,
    };
  }

  // Factory method to create an instance from a Map
  factory UPSU4MeasurementModel.fromMap(Map<String, dynamic> map) {
    return UPSU4MeasurementModel(
      transformerNumber: map['transformerNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      phaseAngle: List<String>.from(map['phaseAngle']),
      output: List<String>.from(map['output']),
    );
  }
}



class ACOMP1ChecklistModel {
  final ObjectId id;
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<ACOMP1ChecklistItem> checklist;

  ACOMP1ChecklistModel({
    required this.id,
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static ACOMP1ChecklistModel fromMap(Map<String, dynamic> map) {
    return ACOMP1ChecklistModel(
      id: map['_id'],
      transformerNumber: map['transformerNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<ACOMP1ChecklistItem>.from(
        map['checklist'].map((item) => ACOMP1ChecklistItem.fromMap(item)),
      ),
    );
  }
}

class ACOMP1ChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  ACOMP1ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static ACOMP1ChecklistItem fromMap(Map<String, dynamic> map) {
    return ACOMP1ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}




class Acomp2ChecklistModel {
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<Acomp2ChecklistItem> checklist;

  Acomp2ChecklistModel({
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  factory Acomp2ChecklistModel.fromMap(Map<String, dynamic> map) {
    return Acomp2ChecklistModel(
      transformerNumber: map['transformerNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<Acomp2ChecklistItem>.from(map['checklist']?.map((item) => Acomp2ChecklistItem.fromMap(item))),
    );
  }
}

class Acomp2ChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  Acomp2ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  factory Acomp2ChecklistItem.fromMap(Map<String, dynamic> map) {
    return Acomp2ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}





class ACOMP3ChecklistModel {
  final ObjectId id;
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<ACOMP3ChecklistItem> checklist;

  ACOMP3ChecklistModel({
    required this.id,
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  factory ACOMP3ChecklistModel.fromMap(Map<String, dynamic> map) {
    return ACOMP3ChecklistModel(
      id: map['_id'] as ObjectId,
      transformerNumber: map['transformerNumber'] as String,
      unit: map['unit'] as String,
      referenceNumber: map['referenceNumber'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      checklist: List<ACOMP3ChecklistItem>.from(
        map['checklist']?.map((item) => ACOMP3ChecklistItem.fromMap(item)) ?? [],
      ),
    );
  }
}

class ACOMP3ChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  ACOMP3ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  factory ACOMP3ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ACOMP3ChecklistItem(
      title: map['title'] as String,
      isYesChecked: map['isYesChecked'] as bool,
      isNoChecked: map['isNoChecked'] as bool,
      remarks: map['remarks'] as String,
    );
  }
}





class Acomp1MeasurementModel {
  final ObjectId id;
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<String> output;
  final List<String> phaseAngle;

  Acomp1MeasurementModel({
    required this.id,
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.output,
    required this.phaseAngle,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'output': output,
      'phaseAngle': phaseAngle,
    };
  }

  factory Acomp1MeasurementModel.fromMap(Map<String, dynamic> map) {
    return Acomp1MeasurementModel(
      id: map['_id'] as ObjectId,
      transformerNumber: map['transformerNumber'] as String,
      unit: map['unit'] as String,
      referenceNumber: map['referenceNumber'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      output: List<String>.from(map['output']),
      phaseAngle: List<String>.from(map['phaseAngle']),
    );
  }
}




class Acomp2MeasurementModel {
  final ObjectId id;
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<String> output;
  final List<String> current;
  final List<String> phaseAngle;

  Acomp2MeasurementModel({
    required this.id,
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.output,
    required this.current,
    required this.phaseAngle,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'output': output,
      'current': current,
      'phaseAngle': phaseAngle,
    };
  }

  factory Acomp2MeasurementModel.fromMap(Map<String, dynamic> map) {
    return Acomp2MeasurementModel(
      id: map['_id'] as ObjectId,
      transformerNumber: map['transformerNumber'] as String,
      unit: map['unit'] as String,
      referenceNumber: map['referenceNumber'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      output: List<String>.from(map['output']),
      current: List<String>.from(map['current']),
      phaseAngle: List<String>.from(map['phaseAngle']),
    );
  }
}


class Acomp3MeasurementModel {
  final String transformerNumber;
  final String unit;
  final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<String> voltage;
  final List<String> current;
  final List<String> present;
  final List<String> cumulativeKWH;
  final List<String> cumulativeKVAH;
  final List<String> demand;

  Acomp3MeasurementModel({
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.voltage,
    required this.current,
    required this.present,
    required this.cumulativeKWH,
    required this.cumulativeKVAH,
    required this.demand,
  });

  Map<String, dynamic> toMap() {
    return {
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'voltage': voltage,
      'current': current,
      'present': present,
      'cumulativeKWH': cumulativeKWH,
      'cumulativeKVAH': cumulativeKVAH,
      'demand': demand,
    };
  }
}

void main() {
  final measurement = Acomp3MeasurementModel(
    transformerNumber: '123',
    unit: 'Unit1',
    referenceNumber: 'Ref123',
    date: '2024-08-07',
    time: '12:00:00',
    branch: 'Branch1',
    voltage: ['230', '231', '232'],
    current: ['10', '11', '12'],
    present: ['1', '2', '3'],
    cumulativeKWH: ['100', '200', '300'],
    cumulativeKVAH: ['400', '500', '600'],
    demand: ['10', '20', '30'],
  );

  print(measurement.toMap());
}




class ACChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  ACChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static ACChecklistItem fromMap(Map<String, dynamic> map) {
    return ACChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}

class ACChecklistModel {
  ObjectId id;
  String transformerNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<ACChecklistItem> checklist;

  ACChecklistModel({
    required this.id,
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static ACChecklistModel fromMap(Map<String, dynamic> map) {
    return ACChecklistModel(
      id: map['_id'],
      transformerNumber: map['transformerNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<ACChecklistItem>.from(
        map['checklist'].map((item) => ACChecklistItem.fromMap(item)),
      ),
    );
  }
}




class ACMeasurementModel {
  ObjectId id;
  String transformerNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<String> voltage;
  List<String> current;
  List<String> present;
  List<String> cumulativeKWH;
  List<String> cumulativeKVAH;
  String demand;

  ACMeasurementModel({
    required this.id,
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.voltage,
    required this.current,
    required this.present,
    required this.cumulativeKWH,
    required this.cumulativeKVAH,
    required this.demand,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'voltage': voltage,
      'current': current,
      'present': present,
      'cumulativeKWH': cumulativeKWH,
      'cumulativeKVAH': cumulativeKVAH,
      'demand': demand,
    };
  }

  static ACMeasurementModel fromMap(Map<String, dynamic> map) {
    return ACMeasurementModel(
      id: map['_id'],
      transformerNumber: map['transformerNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      voltage: List<String>.from(map['voltage']),
      current: List<String>.from(map['current']),
      present: List<String>.from(map['present']),
      cumulativeKWH: List<String>.from(map['cumulativeKWH']),
      cumulativeKVAH: List<String>.from(map['cumulativeKVAH']),
      demand: map['demand'],
    );
  }
}




class WC11ChecklistModel {
  ObjectId id;
  String wcNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<WC11ChecklistItem> checklist;

  WC11ChecklistModel({
    required this.id,
    required this.wcNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'wcNumber': wcNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static WC11ChecklistModel fromMap(Map<String, dynamic> map) {
    return WC11ChecklistModel(
      id: map['_id'],
      wcNumber: map['wcNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<WC11ChecklistItem>.from(map['checklist'].map((item) => WC11ChecklistItem.fromMap(item))),
    );
  }
}

class WC11ChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  WC11ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static WC11ChecklistItem fromMap(Map<String, dynamic> map) {
    return WC11ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}






class WC12ChecklistModel {
  ObjectId id;
  String wcNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<WC12ChecklistItem> checklist;

  WC12ChecklistModel({
    required this.id,
    required this.wcNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'wcNumber': wcNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static WC12ChecklistModel fromMap(Map<String, dynamic> map) {
    return WC12ChecklistModel(
      id: map['_id'],
      wcNumber: map['wcNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<WC12ChecklistItem>.from(map['checklist'].map((item) => WC12ChecklistItem.fromMap(item))),
    );
  }
}

class WC12ChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  WC12ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static WC12ChecklistItem fromMap(Map<String, dynamic> map) {
    return WC12ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}




class WC21ChecklistModel {
  ObjectId id;
  String wcNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<WC21ChecklistItem> checklist;

  WC21ChecklistModel({
    required this.id,
    required this.wcNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'wcNumber': wcNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static WC21ChecklistModel fromMap(Map<String, dynamic> map) {
    return WC21ChecklistModel(
      id: map['_id'],
      wcNumber: map['wcNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<WC21ChecklistItem>.from(map['checklist'].map((item) => WC21ChecklistItem.fromMap(item))),
    );
  }
}

class WC21ChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  WC21ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static WC21ChecklistItem fromMap(Map<String, dynamic> map) {
    return WC21ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}




class WC22ChecklistModel {
  ObjectId id;
  String wcNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<WC22ChecklistItem> checklist;

  WC22ChecklistModel({
    required this.id,
    required this.wcNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'wcNumber': wcNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static WC22ChecklistModel fromMap(Map<String, dynamic> map) {
    return WC22ChecklistModel(
      id: map['_id'],
      wcNumber: map['wcNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<WC22ChecklistItem>.from(map['checklist'].map((item) => WC22ChecklistItem.fromMap(item))),
    );
  }
}

class WC22ChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  WC22ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static WC22ChecklistItem fromMap(Map<String, dynamic> map) {
    return WC22ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}




class WC31ChecklistModel {
  ObjectId id;
  String wcNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<WC31ChecklistItem> checklist;

  WC31ChecklistModel({
    required this.id,
    required this.wcNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'wcNumber': wcNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static WC31ChecklistModel fromMap(Map<String, dynamic> map) {
    return WC31ChecklistModel(
      id: map['_id'],
      wcNumber: map['wcNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<WC31ChecklistItem>.from(map['checklist'].map((item) => WC31ChecklistItem.fromMap(item))),
    );
  }
}

class WC31ChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  WC31ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static WC31ChecklistItem fromMap(Map<String, dynamic> map) {
    return WC31ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}





class WC32ChecklistModel {
  ObjectId id;
  String wcNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<WC32ChecklistItem> checklist;

  WC32ChecklistModel({
    required this.id,
    required this.wcNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'wcNumber': wcNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static WC32ChecklistModel fromMap(Map<String, dynamic> map) {
    return WC32ChecklistModel(
      id: map['_id'],
      wcNumber: map['wcNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<WC32ChecklistItem>.from(map['checklist'].map((item) => WC32ChecklistItem.fromMap(item))),
    );
  }
}

class WC32ChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  WC32ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static WC32ChecklistItem fromMap(Map<String, dynamic> map) {
    return WC32ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}


//THUSMA


class TransformerChecklistModelV2 {
  ObjectId id;
  String transformerNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<TransformerChecklistItemV2> checklist;

  TransformerChecklistModelV2({
    required this.id,
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static TransformerChecklistModelV2 fromMap(Map<String, dynamic> map) {
    return TransformerChecklistModelV2(
      id: map['_id'],
      transformerNumber: map['transformerNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<TransformerChecklistItemV2>.from(map['checklist'].map((item) => TransformerChecklistItemV2.fromMap(item))),
    );
  }
}

class TransformerChecklistItemV2 {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  TransformerChecklistItemV2({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static TransformerChecklistItemV2 fromMap(Map<String, dynamic> map) {
    return TransformerChecklistItemV2(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}




class TTransformerMeasurementModel {
  ObjectId id;
  String transformerNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<String> voltage;
  List<String> current;
  List<String> present;
  List<String> cumulativeKWH;
  List<String> cumulativeKVAH;
  List<String> demand;

  // Default constructor
  TTransformerMeasurementModel({
    required this.id,
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.voltage,
    required this.current,
    required this.present,
    required this.cumulativeKWH,
    required this.cumulativeKVAH,
    required this.demand,
  });

  // Named constructor for creating an instance from a map
  TTransformerMeasurementModel.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        transformerNumber = map['transformerNumber'],
        unit = map['unit'],
        referenceNumber = map['referenceNumber'],
        date = map['date'],
        time = map['time'],
        branch = map['branch'],
        voltage = List<String>.from(map['voltage']),
        current = List<String>.from(map['current']),
        present = List<String>.from(map['present']),
        cumulativeKWH = List<String>.from(map['cumulativeKWH']),
        cumulativeKVAH = List<String>.from(map['cumulativeKVAH']),
        demand = List<String>.from(map['demand']);

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'voltage': voltage,
      'current': current,
      'present': present,
      'cumulativeKWH': cumulativeKWH,
      'cumulativeKVAH': cumulativeKVAH,
      'demand': demand,
    };
  }
}





class TGeneratorChecklistModel {
  ObjectId id;
  String generatorNumber;
  String unit;
  String date;
  String time;
  String branch;
  List<TChecklistItem> checklist;

  TGeneratorChecklistModel({
    required this.id,
    required this.generatorNumber,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  factory TGeneratorChecklistModel.fromMap(Map<String, dynamic> map) {
    return TGeneratorChecklistModel(
      id: map['_id'],
      generatorNumber: map['generatorNumber'],
      unit: map['unit'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<TChecklistItem>.from(map['checklist'].map((item) => TChecklistItem.fromMap(item))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'generatorNumber': generatorNumber,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }
}

class TChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  TChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  factory TChecklistItem.fromMap(Map<String, dynamic> map) {
    return TChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }
}





class TGeneratorMeasurementModel {
  ObjectId id;
  String generatorNumber;
  String unit;
  String date;
  String time;
  String branch;
  String totalHours;
  String totalKwh;
  String dieselConsumption;
  List<String> voltage;
  List<String> current;
  List<String> power;
  List<String> temperature;
  String frequency;
  String powerFactor;
  String batteryVoltage;

  TGeneratorMeasurementModel({
    required this.id,
    required this.generatorNumber,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.totalHours,
    required this.totalKwh,
    required this.dieselConsumption,
    required this.voltage,
    required this.current,
    required this.power,
    required this.temperature,
    required this.frequency,
    required this.powerFactor,
    required this.batteryVoltage,
  });

  factory TGeneratorMeasurementModel.fromMap(Map<String, dynamic> map) {
    return TGeneratorMeasurementModel(
      id: map['_id'],
      generatorNumber: map['generatorNumber'],
      unit: map['unit'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      totalHours: map['totalHours'],
      totalKwh: map['totalKwh'],
      dieselConsumption: map['dieselConsumption'],
      voltage: List<String>.from(map['voltage']),
      current: List<String>.from(map['current']),
      power: List<String>.from(map['power']),
      temperature: List<String>.from(map['temperature']),
      frequency: map['frequency'],
      powerFactor: map['powerFactor'],
      batteryVoltage: map['batteryVoltage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'generatorNumber': generatorNumber,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'totalHours': totalHours,
      'totalKwh': totalKwh,
      'dieselConsumption': dieselConsumption,
      'voltage': voltage,
      'current': current,
      'power': power,
      'temperature': temperature,
      'frequency': frequency,
      'powerFactor': powerFactor,
      'batteryVoltage': batteryVoltage,
    };
  }
}



class TMVChecklistModel {
  ObjectId id;
  String transformerNumber;
  String date;
  String time;
  String branch;
  List<Map<String, dynamic>> checklist;

  TMVChecklistModel({
    required this.id,
    required this.transformerNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  factory TMVChecklistModel.fromMap(Map<String, dynamic> map) {
    return TMVChecklistModel(
      id: map['_id'],
      transformerNumber: map['transformerNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<Map<String, dynamic>>.from(map['checklist']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist,
    };
  }
}



class TMVMeasurementModel {
  String transformerNumber;
  String date;
  String time;
  String branch;
  String totalHoursRunning;
  String totalKwhGenerated;
  String dieselConsumption;
  List<String> voltage;
  List<String> current;
  List<String> power;
  List<String> temperature;
  List<String> phaseAngle;
  String frequency;
  String powerFactor;

  TMVMeasurementModel({
    required this.transformerNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.totalHoursRunning,
    required this.totalKwhGenerated,
    required this.dieselConsumption,
    required this.voltage,
    required this.current,
    required this.power,
    required this.temperature,
    required this.phaseAngle,
    required this.frequency,
    required this.powerFactor,
  });

  Map<String, dynamic> toMap() {
    return {
      'transformerNumber': transformerNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'totalHoursRunning': totalHoursRunning,
      'totalKwhGenerated': totalKwhGenerated,
      'dieselConsumption': dieselConsumption,
      'voltage': voltage,
      'current': current,
      'power': power,
      'temperature': temperature,
      'phaseAngle': phaseAngle,
      'frequency': frequency,
      'powerFactor': powerFactor,
    };
  }

  static TMVMeasurementModel fromMap(Map<String, dynamic> map) {
    return TMVMeasurementModel(
      transformerNumber: map['transformerNumber'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      totalHoursRunning: map['totalHoursRunning'] as String,
      totalKwhGenerated: map['totalKwhGenerated'] as String,
      dieselConsumption: map['dieselConsumption'] as String,
      voltage: List<String>.from(map['voltage'] as List),
      current: List<String>.from(map['current'] as List),
      power: List<String>.from(map['power'] as List),
      temperature: List<String>.from(map['temperature'] as List),
      phaseAngle: List<String>.from(map['phaseAngle'] as List),
      frequency: map['frequency'] as String,
      powerFactor: map['powerFactor'] as String,
    );
  }
}



class TUPSChecklistModel {
  final String upsNumber;
  final String unit;
  // final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<ChecklistEntry> checklist;

  TUPSChecklistModel({
    required this.upsNumber,
    required this.unit,
    // required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  // Convert a TUPSChecklistModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'UPSNumber': upsNumber,
      'unit': unit,
      // 'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  // Convert a Map to a TUPSChecklistModel instance
  factory TUPSChecklistModel.fromMap(Map<String, dynamic> map) {
    return TUPSChecklistModel(
      upsNumber: map['UPSNumber'],
      unit: map['unit'],
      // referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<ChecklistEntry>.from(
        map['checklist']?.map((item) => ChecklistEntry.fromMap(item)) ?? [],
      ),
    );
  }
}

class ChecklistEntry {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  ChecklistEntry({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  // Convert a ChecklistEntry instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  // Convert a Map to a ChecklistEntry instance
  factory ChecklistEntry.fromMap(Map<String, dynamic> map) {
    return ChecklistEntry(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}


class TUPSMeasurementModel {
  final String upsNumber;
  final String unit;
  // final String referenceNumber;
  final String date;
  final String time;
  final String branch;
  final List<String> voltage;
  final List<String> current;
  final List<String> present;
  final List<String> cumulativeKWH;
  final List<String> cumulativeKVAH;
  final List<String> demand;

  TUPSMeasurementModel({
    required this.upsNumber,
    required this.unit,
    // required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.voltage,
    required this.current,
    required this.present,
    required this.cumulativeKWH,
    required this.cumulativeKVAH,
    required this.demand,
  });

  // Convert a TUPSMeasurementModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'UPSNumber': upsNumber,
      'unit': unit,
      // 'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'voltage': voltage,
      'current': current,
      'present': present,
      'cumulativeKWH': cumulativeKWH,
      'cumulativeKVAH': cumulativeKVAH,
      'demand': demand,
    };
  }

  // Convert a Map to a TUPSMeasurementModel instance
  factory TUPSMeasurementModel.fromMap(Map<String, dynamic> map) {
    return TUPSMeasurementModel(
      upsNumber: map['UPSNumber'],
      unit: map['unit'],
      // referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      voltage: List<String>.from(map['voltage']),
      current: List<String>.from(map['current']),
      present: List<String>.from(map['present']),
      cumulativeKWH: List<String>.from(map['cumulativeKWH']),
      cumulativeKVAH: List<String>.from(map['cumulativeKVAH']),
      demand: List<String>.from(map['demand']),
    );
  }
}





class TacompChecklistModel {
  final String transformerNumber;
  final String unit;
  final String date;
  final String time;
  final String branch;
  final List<TacompChecklistItem> checklist;

  TacompChecklistModel({
    required this.transformerNumber,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  // Convert TacompChecklistModel to Map
  Map<String, dynamic> toMap() {
    return {
      'Air Compressor': transformerNumber,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }
}

class TacompChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  TacompChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  // Convert TacompChecklistItem to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }
}



class TacompMeasurementModel {
  final String transformerNumber;
  final String unit;
  final String date;
  final String time;
  final String branch;
  final List<String> voltage;
  final List<String> current;
  final List<String> present;
  final List<String> cumulativeKWH;
  final List<String> cumulativeKVAH;
  final List<String> demand;

  TacompMeasurementModel({
    required this.transformerNumber,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.voltage,
    required this.current,
    required this.present,
    required this.cumulativeKWH,
    required this.cumulativeKVAH,
    required this.demand,
  });

  // Convert TacompMeasurementModel to Map
  Map<String, dynamic> toMap() {
    return {
      'transformerNumber': transformerNumber,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'voltage': voltage,
      'current': current,
      'present': present,
      'cumulativeKWH': cumulativeKWH,
      'cumulativeKVAH': cumulativeKVAH,
      'demand': demand,
    };
  }
}




class TAC1ChecklistItem {
  final String title;
  final bool isYesChecked;
  final bool isNoChecked;
  final String remarks;

  TAC1ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static TAC1ChecklistItem fromMap(Map<String, dynamic> map) {
    return TAC1ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}

class TAC1ChecklistModel {
  final String acNumber;
  final String unit;
  final String date;
  final String time;
  final String branch;
  final List<TAC1ChecklistItem> checklist;

  TAC1ChecklistModel({
    required this.acNumber,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      'ACNumber': acNumber,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static TAC1ChecklistModel fromMap(Map<String, dynamic> map) {
    return TAC1ChecklistModel(
      acNumber: map['ACNumber'],
      unit: map['unit'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<TAC1ChecklistItem>.from(
        map['checklist']?.map((item) => TAC1ChecklistItem.fromMap(item)) ?? [],
      ),
    );
  }
}



class Tac2ChecklistModel {
  String acNumber;
  String unit;
  String date;
  String time;
  String branch;
  List<Tac2ChecklistItem> checklist;

  Tac2ChecklistModel({
    required this.acNumber,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      'acNumber': acNumber,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static Tac2ChecklistModel fromMap(Map<String, dynamic> map) {
    return Tac2ChecklistModel(
      acNumber: map['acNumber'],
      unit: map['unit'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<Tac2ChecklistItem>.from(map['checklist'].map((item) => Tac2ChecklistItem.fromMap(item))),
    );
  }
}

class Tac2ChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  Tac2ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static Tac2ChecklistItem fromMap(Map<String, dynamic> map) {
    return Tac2ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}


class Tac3ChecklistModel {
  String acNumber;
  String unit;
  String date;
  String time;
  String branch;
  List<Tac3ChecklistItem> checklist;

  Tac3ChecklistModel({
    required this.acNumber,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      'acNumber': acNumber,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  static Tac3ChecklistModel fromMap(Map<String, dynamic> map) {
    return Tac3ChecklistModel(
      acNumber: map['acNumber'],
      unit: map['unit'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<Tac3ChecklistItem>.from(
        map['checklist'].map((item) => Tac3ChecklistItem.fromMap(item)),
      ),
    );
  }
}

class Tac3ChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  Tac3ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  static Tac3ChecklistItem fromMap(Map<String, dynamic> map) {
    return Tac3ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}





class TAC4ChecklistModel {
  ObjectId id;
  String acNumber;
  String unit;
  String date;
  String time;
  String branch;
  List<TAC4ChecklistItem> checklist;

  TAC4ChecklistModel({
    required this.id,
    required this.acNumber,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  // Convert a TAC4ChecklistModel into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'ACNumber': acNumber,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  // Create a TAC4ChecklistModel from a Map.
  factory TAC4ChecklistModel.fromMap(Map<String, dynamic> map) {
    return TAC4ChecklistModel(
      id: map['_id'],
      acNumber: map['ACNumber'],
      unit: map['unit'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<TAC4ChecklistItem>.from(map['checklist']?.map((item) => TAC4ChecklistItem.fromMap(item))),
    );
  }
}

class TAC4ChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  TAC4ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  // Convert a TAC4ChecklistItem into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  // Create a TAC4ChecklistItem from a Map.
  factory TAC4ChecklistItem.fromMap(Map<String, dynamic> map) {
    return TAC4ChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}






class TAC5ChecklistModel {
  ObjectId id;
  String acNumber;
  String unit;
  String date;
  String time;
  String branch;
  List<TAC5ChecklistItem> checklist;

  TAC5ChecklistModel({
    required this.id,
    required this.acNumber,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  // Convert a TAC5ChecklistModel into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'ACNumber': acNumber,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  // Create a TAC5ChecklistModel from a Map.
  factory TAC5ChecklistModel.fromMap(Map<String, dynamic> map) {
    return TAC5ChecklistModel(
      id: map['_id'] as ObjectId,
      acNumber: map['ACNumber'] as String,
      unit: map['unit'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      branch: map['branch'] as String,
      checklist: List<TAC5ChecklistItem>.from(
        (map['checklist'] as List<dynamic>?)?.map((item) => TAC5ChecklistItem.fromMap(item as Map<String, dynamic>)) ?? []
      ),
    );
  }
}

class TAC5ChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  TAC5ChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  // Convert a TAC5ChecklistItem into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  // Create a TAC5ChecklistItem from a Map.
  factory TAC5ChecklistItem.fromMap(Map<String, dynamic> map) {
    return TAC5ChecklistItem(
      title: map['title'] as String,
      isYesChecked: map['isYesChecked'] as bool,
      isNoChecked: map['isNoChecked'] as bool,
      remarks: map['remarks'] as String,
    );
  }
}




class TconChecklistModel {
  ObjectId id;
  String transformerNumber;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<TconChecklistItem> checklist;

  TconChecklistModel({
    required this.id,
    required this.transformerNumber,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.checklist,
  });

  // Convert a TconChecklistModel into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'checklist': checklist.map((item) => item.toMap()).toList(),
    };
  }

  // Create a TconChecklistModel from a Map.
  factory TconChecklistModel.fromMap(Map<String, dynamic> map) {
    return TconChecklistModel(
      id: map['_id'] as ObjectId,
      transformerNumber: map['transformerNumber'],
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      checklist: List<TconChecklistItem>.from(
        map['checklist']?.map((item) => TconChecklistItem.fromMap(item)) ?? [],
      ),
    );
  }
}

class TconChecklistItem {
  String title;
  bool isYesChecked;
  bool isNoChecked;
  String remarks;

  TconChecklistItem({
    required this.title,
    required this.isYesChecked,
    required this.isNoChecked,
    required this.remarks,
  });

  // Convert a TconChecklistItem into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isYesChecked': isYesChecked,
      'isNoChecked': isNoChecked,
      'remarks': remarks,
    };
  }

  // Create a TconChecklistItem from a Map.
  factory TconChecklistItem.fromMap(Map<String, dynamic> map) {
    return TconChecklistItem(
      title: map['title'],
      isYesChecked: map['isYesChecked'],
      isNoChecked: map['isNoChecked'],
      remarks: map['remarks'],
    );
  }
}


class TconMeasurementModel {
  ObjectId id;
  String transformerNumber;
  String date;
  String time;
  String branch;
  List<String> voltage;
  List<String> current;
  List<String> present;
  List<String> cumulativeKWH;
  List<String> cumulativeKVAH;
  List<String> demand;

  TconMeasurementModel({
    required this.id,
    required this.transformerNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.voltage,
    required this.current,
    required this.present,
    required this.cumulativeKWH,
    required this.cumulativeKVAH,
    required this.demand,
  });

  // Convert a TconMeasurementModel into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'transformerNumber': transformerNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'voltage': voltage,
      'current': current,
      'present': present,
      'cumulativeKWH': cumulativeKWH,
      'cumulativeKVAH': cumulativeKVAH,
      'demand': demand,
    };
  }

  // Create a TconMeasurementModel from a Map.
  factory TconMeasurementModel.fromMap(Map<String, dynamic> map) {
    return TconMeasurementModel(
      id: map['_id'] as ObjectId,
      transformerNumber: map['transformerNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      voltage: List<String>.from(map['voltage'] ?? []),
      current: List<String>.from(map['current'] ?? []),
      present: List<String>.from(map['present'] ?? []),
      cumulativeKWH: List<String>.from(map['cumulativeKWH'] ?? []),
      cumulativeKVAH: List<String>.from(map['cumulativeKVAH'] ?? []),
      demand: List<String>.from(map['demand'] ?? []),
    );
  }
}


class Tac1MeasurementModel {
  ObjectId id;
  String unit;
  String referenceNumber;
  String date;
  String time;
  String branch;
  List<String> output;

  Tac1MeasurementModel({
    required this.id,
    required this.unit,
    required this.referenceNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.output,
  });

  // Convert a Tac1MeasurementModel into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'unit': unit,
      'referenceNumber': referenceNumber,
      'date': date,
      'time': time,
      'branch': branch,
      'output': output,
    };
  }

  // Create a Tac1MeasurementModel from a Map.
  factory Tac1MeasurementModel.fromMap(Map<String, dynamic> map) {
    return Tac1MeasurementModel(
      id: map['_id'] as ObjectId,
      unit: map['unit'],
      referenceNumber: map['referenceNumber'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      output: List<String>.from(map['output'] ?? []),
    );
  }
}


class Tac2MeasurementModel {
  ObjectId id;
  String unit;
  String date;
  String time;
  String branch;
  List<String> output;

  Tac2MeasurementModel({
    required this.id,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.output,
  });

  // Convert a Tac2MeasurementModel into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'output': output,
    };
  }

  // Create a Tac2MeasurementModel from a Map.
  factory Tac2MeasurementModel.fromMap(Map<String, dynamic> map) {
    return Tac2MeasurementModel(
      id: map['_id'] as ObjectId,
      unit: map['unit'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      output: List<String>.from(map['output'] ?? []),
    );
  }
}




class Tac3MeasurementModel {
  ObjectId id;
  String unit;
  String date;
  String time;
  String branch;
  List<String> output;

  Tac3MeasurementModel({
    required this.id,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.output,
  });

  // Convert a Tac3MeasurementModel into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'output': output,
    };
  }

  // Create a Tac3MeasurementModel from a Map.
  factory Tac3MeasurementModel.fromMap(Map<String, dynamic> map) {
    return Tac3MeasurementModel(
      id: map['_id'] as ObjectId,
      unit: map['unit'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      output: List<String>.from(map['output'] ?? []),
    );
  }
}


class Tac4MeasurementModel {
  ObjectId id;
  String unit;
  String date;
  String time;
  String branch;
  List<String> output;

  Tac4MeasurementModel({
    required this.id,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.output,
  });

  // Convert a Tac4MeasurementModel into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'output': output,
    };
  }

  // Create a Tac4MeasurementModel from a Map.
  factory Tac4MeasurementModel.fromMap(Map<String, dynamic> map) {
    return Tac4MeasurementModel(
      id: map['_id'] as ObjectId,
      unit: map['unit'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      output: List<String>.from(map['output'] ?? []),
    );
  }
}



class Tac5MeasurementModel {
  ObjectId id;
  String unit;
  String date;
  String time;
  String branch;
  List<String> output;

  Tac5MeasurementModel({
    required this.id,
    required this.unit,
    required this.date,
    required this.time,
    required this.branch,
    required this.output,
  });

  // Convert a Tac5MeasurementModel into a Map. The keys must correspond to the field names in MongoDB.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'unit': unit,
      'date': date,
      'time': time,
      'branch': branch,
      'output': output,
    };
  }

  // Create a Tac5MeasurementModel from a Map.
  factory Tac5MeasurementModel.fromMap(Map<String, dynamic> map) {
    return Tac5MeasurementModel(
      id: map['_id'] as ObjectId,
      unit: map['unit'],
      date: map['date'],
      time: map['time'],
      branch: map['branch'],
      output: List<String>.from(map['output'] ?? []),
    );
  }
}
