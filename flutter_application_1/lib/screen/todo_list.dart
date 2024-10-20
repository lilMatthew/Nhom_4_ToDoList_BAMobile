import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/add_page.dart';
import 'package:flutter_application_1/services/todo_service.dart';
import 'package:flutter_application_1/untils/snackbar_help.dart';
import 'package:flutter_application_1/widget/todo_card.dart';



class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchToDo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child:Center(child: CircularProgressIndicator()),
         replacement: RefreshIndicator(
          onRefresh: fetchToDo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text('No task found')),
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index){
                final item = items[index] as Map;
                final id = item['_id'] as String;
              return ToDoCard(
                index: index, 
                item: item, 
                navigateEditPage: navigateEditPage,
                deleteByID: deleteByID);
            } ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:navigateToAddPage,
        label: Text('Add')),
    );
  }

  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(builder: (context) => AddToDoPage());
     await Navigator.push(context, route);
     setState(() {
        isLoading = true;
     });
     fetchToDo();
  }

  Future<void> navigateEditPage(Map item) async{
    final route = MaterialPageRoute(builder: (context) => AddToDoPage(todo: item));
    await Navigator.push(context, route);
     setState(() {
        isLoading = true;
     });
     fetchToDo();
  }

  Future<void> deleteByID(String id) async {
   
    final isSuccess = await TodoService.deleteByID(id);
    if(isSuccess){
      final filterd = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filterd;
      });
      successMessage(context, message: 'Delete success');
    } else{
      errorMessage(context, message: 'Some thing went wrong, we cant delete this item');
    }

  }

  Future<void> fetchToDo() async{
      setState(() {
              isLoading = true;
      });
      final response = await TodoService.fetchToDo();
    
    if(response != null){
      
      setState(() {
        items = response;
      });
      } else {
        errorMessage(context, message: 'Some thing went wrong, we cant fetch data');
      }

      setState(() {
        isLoading = false;
      });
  }

}