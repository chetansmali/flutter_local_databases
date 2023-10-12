import 'package:flutter/material.dart';
import 'package:hive_store/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
VoidCallback onSave;
VoidCallback onCancle;

   DialogBox({super.key,required this.controller,required this.onSave,required this.onCancle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      content: Container(
        height: 120,
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Add a new task'
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              MyButton(text: "Save", onPressed: onSave),
              const SizedBox(width: 8,),
              MyButton(text: "Cancle", onPressed:onCancle),
            ],)  
          ],
        ),
      ),
    );
  }
}