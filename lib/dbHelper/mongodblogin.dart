// ignore_for_file: unused_import

import 'dart:developer';
import 'constant.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:JSBE3M/MongoDBModel.dart';



class MongoDatabase {
  static late Db db;
  static late DbCollection userCollection;
  //static late DbCollection checklistCollection;
  //static late DbCollection measurementCollection;

  static Future<void> connect() async {
    try {
      db = await Db.create("mongodb+srv://harini:abcd@cluster0.rz92lj0.mongodb.net/LOGIN?retryWrites=true&w=majority&appName=Cluster0");
      await db.open();
      userCollection = db.collection("Admin Login");
      //checklistCollection = db.collection("transformer_checklist");
      //measurementCollection = db.collection("transformer_measurements");
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

