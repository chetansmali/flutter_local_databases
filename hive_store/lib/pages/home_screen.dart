import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_store/data/database.dart';
import 'package:hive_store/util/ToDoList.dart';
import 'package:hive_store/util/dialog_box.dart';

class HomrPage extends StatefulWidget {
  const HomrPage({super.key});

  @override
  State<HomrPage> createState() => _HomrPageState();
}

class _HomrPageState extends State<HomrPage> {
  final _controllrt = TextEditingController();

  //reference the hive box
  final _mybox = Hive.box('myBox');
  TodoDatabase db=TodoDatabase();

  @override
  void initState() {
    //if this is the 1st time evere opening the app,then create the default data
    if(_mybox.get("TodoList") == null){
      db.initaliData();
    }else{
      db.loadDatabase();
    }
    super.initState();
  }

    void checkedMarke(bool? value,int index ){
      setState(() {
        db.item[index][1] = !db.item[index][1];
      });
      db.updateDatabase();
    }

    void saveNewTask(){
      setState(() {
           db.item.add([_controllrt.text,false]);
      });
      Navigator.of(context).pop();
      _controllrt.clear();
      db.updateDatabase();
    }

    void createNewTask(){
      showDialog(context: context, builder: (context){
        return DialogBox(
          controller: _controllrt,
          onSave: saveNewTask,
          onCancle:() => Navigator.of(context).pop(),
        ); 
      },
      );
    }

    void deleteTask(int index){
      setState(() {
        db.item.removeAt(index);
      db.updateDatabase();
      });
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Center(child:Text('TODo')),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          createNewTask();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.item.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.item[index][0],
            taskComplition: db.item[index][1], 
            onChanged:(value) => checkedMarke(value,index),
            deleteAction: (context) => deleteTask(index),
           );
        },
      ),
    );
  }
}