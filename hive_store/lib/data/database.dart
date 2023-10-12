import 'package:hive/hive.dart';

class TodoDatabase{

  List item=[];

  final _myBox = Hive.box('myBox');

//run this method if this is first time ever opening this app
  void initaliData(){
    item = [["Learn Dart DSA",false],
      ["Flutter prctice",false],
    ];
  }

//load the data from database
void loadDatabase(){
  item = _myBox.get("TodoList");
}

//updater the database
void updateDatabase(){
   _myBox.put("TodoList", item);
}
}