import 'dart:io';
import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();
  Database? _database;

  Future<Database> get database async {
    _database ??= await getDatabaseInstance();
    return _database!;
  }

  Future<Database> getDatabaseInstance() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = join(directory.path, "tasks_activity.db");
      final result = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        db.execute("CREATE TABLE Task("
            "id integer primary key AUTOINCREMENT,"
            "title TEXT,"
            "category TEXT,"
            "done INT,"
            "taskDate TEXT,"
            "image TEXT"
            ")");
      });
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
