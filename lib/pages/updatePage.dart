import 'package:databaselist/model/User.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class updatePage extends StatefulWidget{
  final Future<Database> db;
  updatePage(this.db);

  @override
  State<StatefulWidget> createState() => _updatePage();
}
class _updatePage extends State<updatePage>{
  Future<List<Todo>>? Listreset;

  TextEditingController? nameController;
  TextEditingController? brandController;
  TextEditingController? stakedcountController;
  TextEditingController? targetcountController;
  TextEditingController? barcodeController;

  @override
  void initState() {
  super.initState();
  nameController                  = new TextEditingController();
  brandController                 = new TextEditingController();
  stakedcountController           = new TextEditingController();
  targetcountController           = new TextEditingController();
  barcodeController               = new TextEditingController();

  Listreset = getTodos();
  }

  @override
  Widget build(BuildContext context){

    final todo = ModalRoute.of(context)!.settings.arguments as Todo;
    return Scaffold(
      appBar: AppBar(title: Text('수정 하기'),),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text('name : ${todo.name}'),
              Text('brand : ${todo.brand}'),
              Text('layer : ${todo.layer}'),
              Text('active : ${todo.active}'),
              Text('expiredate : ${todo.expiredate}'),
              Text('barcode : ${todo.barcode}'),
              Text('stakedcount : ${todo.stakedcount}'),
              Text('targetcount : ${todo.targetcount}'),
              Text('type : ${todo.type}'),
              Text('id : ${todo.id}'),

              TextField(controller: nameController , textInputAction:  TextInputAction.done,),

              TextButton(onPressed: (){
                todo.name = nameController!.value.text;

                Navigator.of(context).pop(todo);
              },child: Text('빌드')),
              IconButton(//Delete
                  onPressed: ()async{
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
      ),
    );
  }
  void _deleteTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.delete('asset_table', where: 'id = ?', whereArgs: [todo.id]);

    setState(() {Listreset = getTodos();});
    Navigator.of(context).pop(todo);
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
    }
    );
  }
}
