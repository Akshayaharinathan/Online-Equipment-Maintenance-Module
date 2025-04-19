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
  //static late DbCollection g2measurementCollection;
  //static late DbCollection g3measurementCollection;
  static late DbCollection g1checklistCollection;
  //static late DbCollection g2checklistCollection;
  //static late DbCollection g3checklistCollection;
  static late DbCollection mvgCollection;
  static late DbCollection mvmCollection;
  static late DbCollection upscCollection;
  static late DbCollection upsmCollection;
  //static late DbCollection ups2cCollection;
  //static late DbCollection ups2mCollection;
 // static late DbCollection ups3cCollection;
  //static late DbCollection ups3mCollection;
  //static late DbCollection ups4cCollection;
  //static late DbCollection ups4mCollection;
  static late DbCollection ac1cCollection;
  static late DbCollection ac1mCollection;
  static late DbCollection ac2cCollection;
  static late DbCollection ac2mCollection;
  static late DbCollection ac3cCollection;
  static late DbCollection ac3mCollection;
  static late DbCollection ac4cCollection;
  static late DbCollection ac4mCollection;
  static late DbCollection ac5cCollection;
  static late DbCollection ac5mCollection;
  static late DbCollection acompcCollection;
  static late DbCollection acompmCollection;
  static late DbCollection cpcCollection;
  static late DbCollection cpmCollection;
  static late DbCollection solarmesCollection;
  static late DbCollection solarcheckCollection;

  

  



  static Future<void> connect() async {
    try {
      db = await Db.create("mongodb+srv://harini:abcd@cluster0.rz92lj0.mongodb.net/THUSMA?retryWrites=true&w=majority&appName=Cluster0");
      await db.open();
      userCollection = db.collection("master_login");
      checklistCollection = db.collection("Transformer Checklist");
      measurementCollection = db.collection("Transformer Measurement");
      g1checklistCollection = db.collection("Generator Checklist");
      //g2checklistCollection = db.collection("generator 2 checklist");
      //g3checklistCollection = db.collection("generator 3 checklist");
      g1measurementCollection = db.collection("Generator Measurement");
      //g2measurementCollection = db.collection("generator 2 measurements");
      //g3measurementCollection = db.collection("generator 3 measurements");
      mvgCollection = db.collection("MV Checklist");
      mvmCollection = db.collection("MV Measurement");
      upscCollection = db.collection("UPS Checklist");
      upsmCollection = db.collection("UPS Measurement");
      //ups2cCollection = db.collection("UPS 2 checklist");
      //ups2mCollection = db.collection("UPS 2 measurements");
      //ups3cCollection = db.collection("UPS 3 checklist");
      //ups3mCollection = db.collection("UPS 3 measurements");
      //ups4cCollection = db.collection("UPS 4 checklist");
      //ups4mCollection = db.collection("UPS 4 measurements");
      ac1cCollection = db.collection("Air Chiller 1 Checklist");
      ac1mCollection = db.collection("Air Chiller 1 Measurement");
      ac2cCollection = db.collection("Air Chiller 2 Checklist");
      ac2mCollection = db.collection("Air Chiller 2 Measurement");
      ac3cCollection = db.collection("Air Chiller 3 Checklist");
      ac3mCollection = db.collection("Air Chiller 3 Measurement");
      ac4cCollection = db.collection("Air Chiller 4 Checklist");
      ac4mCollection = db.collection("Air Chiller 4 Measurement");
      ac5cCollection = db.collection("Air Chiller 5 Checklist");
      ac5mCollection = db.collection("Air Chiller 5 Measurement");
      acompcCollection = db.collection("Air Compresssor Checklist");
      acompmCollection = db.collection("Air Compressor Measurement");
      cpcCollection = db.collection("Control Panel Checklist");
      cpmCollection = db.collection("Control Panel Measurement");
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

