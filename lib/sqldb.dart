import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Constants {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'aburaya.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreat, version: 12, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // await db.execute('ALTER TABLE notes ADD COLUMN title TEXT');
    print("database Upgraded ==================================");
  }


  _onCreat(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute(
        'CREATE TABLE notes (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, note TEXT NOT NULL ,title TEXT NOT NULL ,time TEXT NOT NULL )');
    await batch.commit();
    print("database Created ==================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  deleteMyDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'aburaya.db');
    await deleteDatabase(path);
  }

  read(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insert(String table, Map<String, Object?> values) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, values);
    return response;
  }

  update(String table, Map<String, Object?> values, String? myWhere) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, values, where: myWhere);
    return response;
  }

  delete(String table, String? myWhere) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: myWhere);
    return response;
  }
}
