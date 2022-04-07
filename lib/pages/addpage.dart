
import 'package:databaselist/model/User.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class addPage extends StatefulWidget {
  final Future<Database> db;
  addPage(this.db);

  @override
  State<StatefulWidget> createState() => _addPage();
}

class _addPage extends State<addPage> {
  //data receive
  TextEditingController? nameController        = new TextEditingController();
  TextEditingController? brandController       = new TextEditingController();
  TextEditingController? stakedcountController = new TextEditingController();
  TextEditingController? targetcountController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('리스트 넣기'),
      ),
      body: ListView(

        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
            //decoration: InputDecoration(labelText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: brandController,
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: stakedcountController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: targetcountController,
            ),
          ),



          ElevatedButton(
            onPressed: (){
              Todo todo = Todo(



                name: nameController!.value.text,
                brand: brandController!.value.text,
                stakedcount: int.parse(stakedcountController!.value.text),
                targetcount: int.parse(targetcountController!.value.text),


                active: 0,
              );
              //DEBUG
              //print(todo.name);print(todo.brand);print(todo.stakedcount);print(todo.targetcount);

              Navigator.of(context).pop(todo);
            },
            child: Text('저장하기'),
          )
        ],
      ),
    );
  }
}