import 'package:pengingat_list/model/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pengingat_list/provider/sqliteprovider.dart';

class TaskDataAccess {
  final tableName = 'Task';
  Future<List<Task>> getAll() async {
    final db = await DatabaseProvider.db.database;
    var response = await db.query(tableName);
    List<Task> list = response.map((e) => Task.fromMap(e)).toList();
    return list;
  }

  Future<List<Task>> getAllByCategory(String category) async {
    final db = await DatabaseProvider.db.database;
    var response =
        await db.query("Task", where: "category = ?", whereArgs: [category]);
    List<Task> list = response.map((e) => Task.fromMap(e)).toList();
    return list;
  }

  Future<Task?> getById(int id) async {
    final db = await DatabaseProvider.db.database;
    var response = await db.query("TASK", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Task.fromMap(response.first) : null;
  }

  insert(Task task) async {
    final db = await DatabaseProvider.db.database;
    var response = await db.insert(tableName, task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return response;
  }

  update(Task task) async {
    final db = await DatabaseProvider.db.database;
    var response = await db
        .update(tableName, task.toMap(), where: "id = ?", whereArgs: [task.id]);
    return response;
  }

  delete(int id) async {
    final db = await DatabaseProvider.db.database;
    var response = await db.delete(tableName, where: "id = ?", whereArgs: [id]);
    return response;
  }

  deleteAll() async {
    final db = await DatabaseProvider.db.database;
    var response = await db.delete(tableName);
    return response;
  }
}
