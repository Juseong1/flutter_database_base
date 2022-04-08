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

                    return ListView.separated(
                      itemBuilder: (context, index) {
                        Todo todo = (snapshot.data as List<Todo>)[index];

                        return ListTile(
                          onTap: (){
                            setState((){ todo.active == 1 ? todo.active = 0 : todo.active = 1;});
                            //_updateTodo(todo);
                            },
                          onLongPress: ()async{
                            final result = await Navigator.of(context).pushNamed('/update', arguments: todo);

                            _updateTodo(result as Todo);
                          },
                          subtitle: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Checkbox(value: todo.active == 1 ? true : false
                                ,onChanged: (value){setState((){todo.active == 1 ? todo.active = 0 : todo.active = 1;});},),
                                Column(
                                  children: <Widget>[
                                    //Print@@@@@@@@@@@@@@@@@@@@@@@@@
                                    Text('name : ${todo.name!}'),
                                    Text('brand : ${todo.brand!}'),
                                    //Text('id : ${todo.id}'),
                                    Text('layer : ${todo.layer}'),
                                    Text('stackedcount : ${todo.stakedcount}'),
                                    Text('targetcount : ${todo.targetcount}'),
                                    //Text('type : ${todo.type!}'),
                                    //Text('barcode : ${todo.barcode!}'),
                                    //Text('expiredate : ${todo.expiredate!}'),

                                  ],
                                ),
                                IconButton(onPressed: ()async{
                                  Todo result = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('삭제하기'),
                                          content:

                                          Text('삭제하시겠습니까?'),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(todo);
                                                },
                                                child: Text('예')),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('아니요')),
                                          ],
                                        );
                                      });
                                  _deleteTodo(result as Todo);
                                }, icon: Icon(Icons.delete_rounded))

                              ],
                            ),
                          ),
                            tileColor: todo.active == 1 ?  Colors.lightBlueAccent :   Colors.white,
                        );
                      },
                      itemCount: (snapshot.data as List<Todo>).length,
                      separatorBuilder: (context, index){
                        if (index == 0)return SizedBox.shrink();
                        else return const Divider();
                      },
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


         if(todo !=null) _insertTodo(todo as Todo);                              //database write for addpage
       },
       child: Icon(Icons.add),
     ), floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _deleteTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.delete('asset_table', where: 'id = ?', whereArgs: [todo.id]);
    setState(() {Listreset = getTodos();});
  }

  void _updateTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.update(
      'asset_table',
      todo.toMap(),
      where: 'id = ? ',
      whereArgs: [todo.id],
    );
    setState(() {Listreset = getTodos();});
  }
  void _insertTodo(Todo todo) async {
    final Database database = await widget.db;

    await database.insert('asset_table', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    setState((){ Listreset = getTodos();}); //List reset

  }

  Future<List<Todo>> getTodos() async {
    final Database database = await widget.db;

    final List<Map<String, dynamic>> maps = await database.query('asset_table');

    return List<Todo>.generate(maps.length, (i){
      print('GET TODOS!@!!!!');
      print(maps[i]['id']);

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