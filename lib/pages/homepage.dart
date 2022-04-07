import 'package:databaselist/model/User.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class homePage extends StatefulWidget{
  final Future<Database> db;
  homePage(this.db);

  @override
  State<StatefulWidget> createState() => _homePage();
}

class _homePage extends State<homePage>{

  Future<List<Todo>>? Listreset;
  @override
  void initState() {
    super.initState();
    Listreset = getTodos();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:  Text('타이틀'),),

      body: Container(
        child: Center(
          child: FutureBuilder(
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:    return CircularProgressIndicator();
                case ConnectionState.waiting: return CircularProgressIndicator();
                case ConnectionState.active:  return CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {

                    return ListView.builder(
                      itemBuilder: (context, index) {
                        Todo todo = (snapshot.data as List<Todo>)[index];

                        return ListTile(
                          subtitle: Container(
                            child: Column(
                              children: <Widget>[
                                //출력@@@@@@@@@@@@@@@@@@@@@@@@@
                                Text('name : ${todo.name!}'),
                                Text('brand : ${todo.brand!}'),
                                Text('id : ${todo.id}'),
                                Text('layer : ${todo.layer}'),
                                Text('stackedcount : ${todo.stakedcount}'),
                                Text('targetcount : ${todo.targetcount}'),
                                Text('type : ${todo.type!}'),
                                Text('barcode : ${todo.barcode!}'),
                                Text('expiredate : ${todo.expiredate!}'),
                                Text('체크 : ${todo.active == 1 ? 'true' : 'false'}'),

                                Container(
                                  height: 1,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: (snapshot.data as List<Todo>).length,
                    );
                  } else {
                    return Text('No data');//error
                  }
              }
            },
            future: Listreset,
          ),
        ),
      ),

     floatingActionButton: FloatingActionButton(

       onPressed: ()async{
         final todo = await Navigator.of(context).pushNamed('/add');


         if(todo !=null) _insertTodo(todo as Todo);                               //database write for addpage
       },
       child: Icon(Icons.add),
     ), floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _insertTodo(Todo todo) async {
    final Database database = await widget.db;

    await database.insert('asset_table', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    setState((){ Listreset = getTodos();}); //reset

  }

  Future<List<Todo>> getTodos() async {
    final Database database = await widget.db;

    final List<Map<String, dynamic>> maps = await database.query('asset_table');

    return List<Todo>.generate(maps.length, (i){
      print('GET TODOS!@!!!!');
      print(maps[i]['id']);
      print(maps[i]['active']);

      //print(maps[i]['name']);
      //print(maps[i]['brand']);

      //print(maps[i]['stakedcount']);
      //print(maps[i]['targetcount']);
      return Todo(
        id            : maps[i]['id'],
        active        : maps[i]['active'],
        layer         : maps[i]['layer'],

        name          : maps[i]['name'].toString(),
        brand         : maps[i]['brand'].toString(),
        type          : maps[i]['type'].toString(),
        expiredate    : maps[i]['expiredate'].toString(),
        barcode       : maps[i]['barcode'].toString(),

        stakedcount   : maps[i]['stakedcount'],
        targetcount   : maps[i]['targetcount'],
      );
    });
  }//getTodos

}