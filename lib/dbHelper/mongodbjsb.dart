// ignore_for_file: unused_import

import 'dart:developer';
import 'package:JSBE3M/dbHelper/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:JSBE3M/MongoDBModel.dart';


class MongoDatabase {
  static late Db db;
  static late DbCollection userCollection;
  static late DbCollection checklistCollection;
  static late DbCollection measurementCollection;
  static late DbCollection g1measurementCollection;
  static late DbCollection g2measurementCollection;
  static late DbCollection g3measurementCollection;
  static late DbCollection g1checklistCollection;
  static late DbCollection g2checklistCollection;
  static late DbCollection g3checklistCollection;
  static late DbCollection mvgCollection;
  static late DbCollection mvmCollection;
  static late DbCollection dgcCollection;
  static late DbCollection dgmCollection;
  static late DbCollection ups1cCollection;
  static late DbCollection ups1mCollection;
  static late DbCollection ups2cCollection;
  static late DbCollection ups2mCollection;
  static late DbCollection ups3cCollection;
  static late DbCollection ups3mCollection;
  static late DbCollection ups4cCollection;
  static late DbCollection ups4mCollection;
  static late DbCollection accCollection;
  static late DbCollection acmCollection;
  static late DbCollection acomu1cCollection;
  static late DbCollection acomu1mCollection;
  static late DbCollection acomu2cCollection;
  static late DbCollection acomu2mCollection;
  static late DbCollection acomu3cCollection;
  static late DbCollection acomu3mCollection;
  static late DbCollection cpu1cCollection;
  static late DbCollection cpu1mCollection;
  static late DbCollection cpu2cCollection;
  static late DbCollection cpu2mCollection;
  static late DbCollection cpu3cCollection;
  static late DbCollection cpu3mCollection;
  static late DbCollection wc1u1cCollection;
  static late DbCollection wc1u1mCollection;
  static late DbCollection wc2u1cCollection;
  static late DbCollection wc2u1mCollection;
  static late DbCollection wc1u2cCollection;
  static late DbCollection wc1u2mCollection;
  static late DbCollection wc2u2cCollection;
  static late DbCollection wc2u2mCollection;
  static late DbCollection wc1u3cCollection;
  static late DbCollection wc1u3mCollection;
  static late DbCollection wc2u3cCollection;
  static late DbCollection wc2u3mCollection;
  static late DbCollection solarmesCollection;
  static late DbCollection solarcheckCollection;

  



  static Future<void> connect() async {
    try {
      db = await Db.create("mongodb+srv://harini:abcd@cluster0.rz92lj0.mongodb.net/JSB?retryWrites=true&w=majority&appName=Cluster0");
      await db.open();
      userCollection = db.collection("master_login");
      checklistCollection = db.collection("Transformer Checklist");
      measurementCollection = db.collection("Transformer Measurement");
      g1checklistCollection = db.collection("Generator 1 Checklist");
      g2checklistCollection = db.collection("Generator 2 Checklist");
      g3checklistCollection = db.collection("Generator 3 Checklist");
      g1measurementCollection = db.collection("Generator 1 Measurement");
      g2measurementCollection = db.collection("Generator 2 Measurement");
      g3measurementCollection = db.collection("Generator 3 Measurement");
      mvgCollection = db.collection("MV Checklist");
      mvmCollection = db.collection("MV Measurement");
      dgcCollection = db.collection("DG Checklist");
      dgmCollection = db.collection("DG Measurement");
      ups1cCollection = db.collection("UPS 1 Unit 1 Checklist");
      ups1mCollection = db.collection("UPS 1 Unit 1 Measurement");
      ups2cCollection = db.collection("UPS 1 Unit 2 Checklist");
      ups2mCollection = db.collection("UPS 1 Unit 2 Measurement");
      ups3cCollection = db.collection("UPS 2 Unit 2 Checklist");
      ups3mCollection = db.collection("UPS 2 Unit 2 Measurement");
      ups4cCollection = db.collection("UPS 1 Unit 3 Checklist");
      ups4mCollection = db.collection("UPS 1 Unit 3 Measurement");
      accCollection = db.collection("Air Chiller Checklist");
      acmCollection = db.collection("Air Chiller Measurements");
      acomu1cCollection = db.collection("Air Compresssor Unit 1 Checklist");
      acomu1mCollection = db.collection("Air Compressor Unit 1 Measurement");
      acomu2cCollection = db.collection("Air Compressor Unit 2 Checklist");
      acomu2mCollection = db.collection("Air Compressor Unit 2 Measurement");
      acomu3cCollection = db.collection("Air Compressor Unit 3 Checklist");
      acomu3mCollection = db.collection("Air Compressor Unit 3 Measurement");
      cpu1cCollection = db.collection("Control Panel Unit 1 Checklist");
      cpu1mCollection = db.collection("Control Panel Unit 1 Measurement");
      cpu2cCollection = db.collection("Control Panel Unit 2 Checklist");
      cpu2mCollection = db.collection("Control Panel Unit 2 Measurement");
      cpu3cCollection = db.collection("Control Panel Unit 3 Checklist");
      cpu3mCollection = db.collection("Control Panel Unit 3 Measurement");
      wc1u1cCollection = db.collection("Waterchiller 1 Unit 1 Checklist");
      wc1u1mCollection = db.collection("Waterchiller 1 Unit 1 Measurement");
      wc2u1cCollection = db.collection("Waterchiller 2 Unit 1 Checklist");
      wc2u1mCollection = db.collection("Waterchiller 2 Unit 1 Measurement");
      wc1u2cCollection = db.collection("Waterchiller 1 Unit 2 Checklist");
      wc1u2mCollection = db.collection("Waterchiller 1 Unit 2 Measurement");
      wc2u2cCollection = db.collection("Waterchiller 2 Unit 2 Checklist");
      wc2u2mCollection = db.collection("Waterchiller 2 Unit 2 Measurement");
      wc1u3cCollection = db.collection("Waterchiller 1 Unit 3 Checklist");
      wc1u3mCollection = db.collection("Waterchiller 1 Unit 3 Measurement");
      wc2u3cCollection = db.collection("Waterchiller 2 Unit 3 Checklist");
      wc2u3mCollection = db.collection("Waterchiller 2 Unit 3 Measurement");
      solarmesCollection = db.collection("Solar Panel Measurement");
      solarcheckCollection = db.collection("Solar Checklist");


      log('Connected to MongoDB');
    } catch (e) {
      log('Error connecting to MongoDB: $e');
    }
  }

  static Future<void> insert(Map<String, dynamic> data, String collectionName) async {
    try {
      final collection = db.collection(collectionName);
      await collection.insertOne(data);
      log('Data inserted into $collectionName');
    } catch (e) {
      log('Error inserting data into $collectionName: $e');
    }
  }


}