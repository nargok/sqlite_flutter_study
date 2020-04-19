import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'ClientModel.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db){
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id INTEGER PRIMARY KEY,"
          "first_name TEXT,"
          "last_name TEXT,"
          "blocked BTI"
          ");");
    });
  }

  newClient(Client newClient) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Client;");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into Client (id, first_name, last_name, blocked)"
        " VALUES (?, ?, ?, ?)",
        [id, newClient.firstName, newClient.lastName, newClient.blocked]);
    return raw;
  }


}

