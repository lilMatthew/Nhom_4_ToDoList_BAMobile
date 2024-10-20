import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/todo_service.dart';
import 'package:flutter_application_1/untils/snackbar_help.dart';


class AddToDoPage extends StatefulWidget {
  final Map? todo;
  const AddToDoPage({super.key,this.todo});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'] as String;
      final description = todo['description'] as String;
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit?'Edit ToDo':'Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: titleController,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'What you want to do?',
            ),  
          ),
          TextField(
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            minLines: 5,
            maxLines: 8,  
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: isEdit ? updateData : sendData,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(isEdit?'Update Edit':'Send'),
            ),
          )
        ],
      ),
    );
  }

  Future<void> sendData() async{
    //get db from user
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
    "title": title,
    "description": description,
    "is_completed": false
    };
    //send data to sever
    final isSuccess = await TodoService.addToDo(body);
    //show success or fail
    if(isSuccess){
      titleController.text ='';
      descriptionController.text ='';
      print('Success');
      successMessage(context,message: 'Success');
    } else {
      print('Fail');
      errorMessage(context,message: 'Error');
    }
  }

  Future <void> updateData() async {
    final todo = widget.todo;
    if(todo == null){
      print('Nothing change');
      return;
    }
    final id = todo['_id'];
    

    final isSuccess = await TodoService.updateData(id, body);
    

    if(isSuccess){
      successMessage(context, message: 'Update Success');
    } else{
      errorMessage(context, message: 'Update Fail');
    }
  }

  Map get body{
    //get db from user
    final title = titleController.text;
    final description = descriptionController.text;
    return {
    "title": title,
    "description": description,
    "is_completed": false
    };
  }
}