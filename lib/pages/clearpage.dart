
import 'package:databaselist/model/User.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class clearPage extends StatefulWidget{
  final Future<Database> db;
  clearPage(this.db);

  @override
  State<StatefulWidget> createState() => _clearPage();
}
class _clearPage extends State<clearPage>{
  Future<List<Todo>>? clearList;
  @override
  void initState(){
    super.initState();
    clearList = getClearList();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('휴지통'),),
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
                          subtitle: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: <Widget>[
                                    //Print@@@@@@@@@@@@@@@@@@@@@@@@@
                                    Text('name : ${todo.name!}'),
                                    Text('brand : ${todo.brand!}'),
                                    Text('layer : ${todo.layer}'),
                                    Text('stackedcount : ${todo.stakedcount}'),
                                    Text('targetcount : ${todo.targetcount}'),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: (snapshot.data as List<Todo>).length,
                      separatorBuilder: (context, index){
                        if (index == -1)return SizedBox.shrink();
                        else return const Divider();
                      },
                    );
                  } else return Text('No data');//error
              }
            },
            future: clearList,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final result = await showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(title: Text('모두 삭제'),
            content: Text('해당 페이지 자료를 모두 삭제 하시겠습니까?'),
            actions: <Widget>[
              TextButton(onPressed: (){
                Navigator.of(context).pop(true);
              }, child: Text('예')),
              TextButton(onPressed: (){
                Navigator.of(context).pop(false);
              }, child: Text('아니요')),
            ],);
          });
          if(result == true){_removeAllTodos();}
        },
        child: Icon(Icons.remove),
      ) ,
    );
  }
  void _removeAllTodos()async{
    final Database database = await widget.db;
    database.rawDelete('delete from asset_table where active=1');
    setState((){clearList = getClearList();});
  }
  Future<List<Todo>> getClearList() async{

    final Database database = await widget.db;
    List<Map<String, dynamic>> maps = await database.rawQuery('select name, brand, type, expiredate, stakedcount, targetcount, barcode, layer, id from asset_table where active=1');

    return List.generate(maps.length, (i) {
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