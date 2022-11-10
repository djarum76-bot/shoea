import 'package:path/path.dart';
import 'package:shoea/models/history_model.dart';
import 'package:shoea/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class HistoryRepository{
  Future<Database> initializeDB()async{
    try{
      String path = await getDatabasesPath();

      return openDatabase(
        join(path, '${Constants.dbName}.db'),
        onCreate: (db, version)async{
          await db.execute(
            "CREATE TABLE IF NOT EXISTS ${Constants.dbName}(uuid TEXT PRIMARY KEY, name TEXT NOT NULL, access_at TEXT NOT NULL)"
          );
        },
        version: 1
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> insertHistory(HistoryModel history)async{
    try{
      final db = await initializeDB();
      await db.insert(
        Constants.dbName,
        history.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> updateHistory(HistoryModel history)async{
    try{
      final db = await initializeDB();
      await db.update(
        Constants.dbName,
        history.toMap(),
        where: "${Constants.uuid} = ?",
        whereArgs: [history.uuid]
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> deleteHistory(String uuid)async{
    try{
      final db = await initializeDB();
      await db.delete(
        Constants.dbName,
        where: "${Constants.uuid} = ?",
        whereArgs: [uuid]
      );
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> deleteAllHistory()async{
    try{
      final db = await initializeDB();
      await db.delete(Constants.dbName);
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<HistoryModel>> getHistories()async{
    try{
      final db = await initializeDB();
      final List<Map<String, dynamic>> histories = await db.query(Constants.dbName, orderBy: "${Constants.accessAt} DESC");
      return histories.map((history) => HistoryModel.fromMap(history)).toList();
    }catch(e){
      throw Exception(e);
    }
  }
}