import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE item(
    id INTEGER PRIMARY  KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    createdAt TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP
    ) 
    """);
  }

  static Future<sql.Database> db(){
    return sql.openDatabase(
      'dbAppname.db',
      version: 1,
      onCreate: (sql.Database database,int version) async {
        print('...creating table...');
        await createTable(database);
      },
    );
  }

  static Future<int> createItem(String title, String description) async {
    final db = await SQLHelper.db();

    final data = {'title' : title, 'description' : description};
    final id = await db.insert('item',data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String,dynamic>>> getItem() async {
    final db = await SQLHelper.db();
    return db.query('item',orderBy: "id");
  }

  static Future<List<Map<String,dynamic>>> getOne(int id) async {
    final db = await SQLHelper.db();
    return db.query('item',where: 'id = ?',whereArgs: [id],limit: 1);
  }

  static Future<int> updateItem(int id,String title,String description) async {
    final db = await SQLHelper.db();

    final data = {
      'title' : title,
      'description' : description,
      'createdAt' : DateTime.now().toString()
    };
    final result = await db.update('item', data,where: "id = ? ",whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db =await SQLHelper.db();
    try{
      await db.delete('item',where: 'id =? ',whereArgs: [id]);
    }catch(err){
      debugPrint("Something went wrong when delete an item : ${err}");
    }
  }
}