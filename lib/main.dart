import 'package:databaselist/pages/addpage.dart';
import 'package:databaselist/pages/updatePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:databaselist/pages/homepage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:databaselist/pages/clearpage.dart';

void main() => runApp (MyApp()) ;

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    Future<Database> database = initDatabase();

    return MaterialApp(
      title: 'Database App',
      initialRoute: '/',
      routes: {
        '/': (context) => homePage(database),
        '/add': (context) => addPage(database),
        '/update':(context) => updatePage(database),
        '/clear':(context) => clearPage(database),
      },
    );
  }

  Future<Database> initDatabase() async {
    if (kDebugMode) print("openDatabase"); //DEBUG

    return openDatabase(

      join(await getDatabasesPath(), 'todo_database.db'), //GET DB PATH and NAMING

      onCreate: (db, version) async{
        return await db.execute(
          "CREATE TABLE asset_table(id INTEGER PRIMARY KEY, active INTEGER, layer INTEGER, name TEXT, expiredate TEXT, type TEXT, brand TEXT, barcode TEXT, stakedcount INTEGER, targetcount INTEGER)",
        );
      },
      version: 1,
    );


  }
}
