import 'package:databaselist/model/User.dart';
import 'package:flutter/material.dart';


class updatePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _updatePage();
}
class _updatePage extends State<updatePage>{

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

              TextField(controller: nameController),

              TextButton(onPressed: (){
                todo.name = nameController!.value.text;

                Navigator.of(context).pop(todo);
              },child: Text('빌드')),
            ],
          ),
        ),
      ),
    );
  }

}
