// ignore_for_file: await_only_futures, avoid_print

import 'package:gdwl/models/list_model.dart';
import 'package:gdwl/shared/constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static const dbName = 'gdwl';
  static const dbVersion = 1;

  static Database? _db;

   static Future<void> initDatabase() async {
    if(_db != null){
      print('not null db');
    }else {
      try{
        final docsPath = await getApplicationDocumentsDirectory();
        final dbPath = join(docsPath.path, dbName);
        _db =  await openDatabase(dbPath , version: dbVersion ,
          onCreate: (Database database , int version) async {
          // create lists table
            await database.execute(createListTable);
          },
        );
      }catch(e){
        print('Error while open db ${e.toString()}');
      }
    }
  }

  static Future<int> insertList (ListModel list) async {
     print('insert');
     return await _db!.insert(listTable, list.toJson());
  }



}