import 'package:flutter/material.dart';

class ToDoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEditPage;
  final Function(String) deleteByID;
  const ToDoCard(
    {
      super.key, 
      required this.index, 
      required this.item, 
      required this.navigateEditPage,
      required this.deleteByID
    });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
                child: ListTile
                (
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(item['title'] as String),
                  subtitle: Text(item['description'] as String),
                  trailing: PopupMenuButton(
                    onSelected: (value){
                      if(value == 'edit'){
                        navigateEditPage(item);
                      } else if (value == 'delete'){
                        deleteByID(id);
                      }
                    },
                    itemBuilder: (context){
                      return[
                        PopupMenuItem(child: Text('Edit'), value: 'edit'),
                        PopupMenuItem(child: Text('Delete'), value: 'delete'),
                      ];
                    },
                  ),
                ),
              );
  }
}