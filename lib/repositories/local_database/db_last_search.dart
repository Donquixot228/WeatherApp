import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:weather/models/last_search_model.dart';


//FixME Я использую SQLite для сохранения истории поиска

class MastersDatabaseProvider {


  //static final MastersDatabaseProvider db = MastersDatabaseProvider._();
  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "history.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE History ("
          "id INTEGER primary key AUTOINCREMENT,"
          "lat DOUBLE,"
          "lon DOUBLE,"
          "name TEXT,"
          "temp TEXT,"
          "description TEXT,"
          "icon TEXT"
          ")");
    });
  }

  addItemToDatabaseHistory(History history) async {
    final db = await getDatabaseInstance();
    var raw = await db.insert(
      "History",
      history.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<List<History>> getAllHistory() async {
    final db = await getDatabaseInstance();
    var response = await db.query("History");
    List<History> list = response.map((c) => History.fromMap(c)).toList();
    return list;
  }

  deleteItemWithId(int id) async {
    final db = await getDatabaseInstance();
    return db.delete("History", where: "id = ?", whereArgs: [id]);
  }

  deleteAllHistory() async {
    final db = await getDatabaseInstance();
    db.delete("History");
  }
}
