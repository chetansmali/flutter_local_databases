import 'package:flutter/material.dart';
import 'package:sqlite_store/sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Map<String,dynamic>> _journals = [];
  bool _isLoading = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _referenceJournal() async {
    final data = await SQLHelper.getItem();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _referenceJournal() ;
    print("...Number of items  ${_journals.length}");
  }

  void _showForm(int? id){
    if(id != null){
      final existingJournal = 
          _journals.firstWhere((element) => element['id'] == id);
          _titleController.text = existingJournal['title'];
          _descriptionController.text = existingJournal['description'];
    }

    //adding
    Future<void> _addItem() async {
      await SQLHelper.createItem(_titleController.text, _descriptionController.text);
      _referenceJournal();
    }

    //updating
    Future<void> _updateItem(int id) async {
      await SQLHelper.updateItem(id, _titleController.text, _descriptionController.text);
      _referenceJournal();
    }

    showModalBottomSheet(
        context: context,
        elevation:  10,
        isScrollControlled: true,
        builder:(_) => Container(
          padding: EdgeInsets.only(
            top: 15,left: 15,right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom +120
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: () async {
                    if(id == null){
                      await _addItem();
                    }
                    if(id != null){
                      await _updateItem(id);
                    }
                    _titleController.text = '';
                    _descriptionController.text = '';
                    Navigator.of(context).pop();
                  },
                  child: Text(id == null ? 'Create New' : 'Update')
              ),
            ],
          ),
        )
    );
  }

  //deleting
  Future<void> deleteitem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully deleted')));
    _referenceJournal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 15,
        title: Center(child: Text('SQLite')),
      ),
      body: ListView.builder(
          itemCount: _journals.length,
          itemBuilder:(context , index) => Card(
            color: Colors.orange[200],
            margin: EdgeInsets.all(15),
            child: ListTile(
              title: Text(_journals[index]['title']),
              subtitle: Text(_journals[index]['description']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(onPressed: () => _showForm(_journals[index]['id']), icon: Icon(Icons.edit)),
                    IconButton(onPressed: () => deleteitem(_journals[index]['id']), icon: Icon(Icons.delete)),
                  ],
                ),
              ),
            ),
          )
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150,vertical: 30),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _showForm(null),
        ),
      ),
    );
  }


}
