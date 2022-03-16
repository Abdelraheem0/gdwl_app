// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdwl/shared/cubit/cubit.dart';
import 'package:gdwl/shared/cubit/states.dart';

class EditList extends StatelessWidget {
  int listId;
  String listName;

  EditList({required this.listId , required this.listName});

  var listNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Rename List'),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)),
            actions: [
              TextButton(
                  onPressed: () {
//                    print(listNameController.text);
//                    print(listId);
                  if(listNameController.text.isEmpty){
                    listNameController.text = listName;
                    cubit.updateList(
                      listNameController.text,
                      listId,
                    );
                  }else{
                    cubit.updateList(
                      listNameController.text,
                      listId,
                    );
                  }
                   Navigator.pop(context);
                   Navigator.pop(context);
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
            backgroundColor: Colors.blue,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: listNameController..text = listName,
            ),
          ),
        );
      },
    );
  }

//  void createListDB() async {
//    database = await openDatabase(
//        'list.db',
//        version: 1,
//        onCreate: (database , version){
//          print('Database Created');
//          database.execute('CREATE TABLE lists (id INTEGER PRIMARY KEY , name TEXT)').then((value){
//            print('Table Created');
//          }).catchError((error){
//            print('Error while creating table ${error.toString()}');
//          });
//        },
//        onOpen: (database){
//
//          print('Database Opened');
//        }
//    );
//  }

//  Future insertToDB(String name) async {
//    return await database.transaction((txn){
//      return txn.rawInsert('INSERT INTO lists(name) VALUES("$name")').then((value){
//        print('$value inserted successfully!!');
//      }).catchError((error){
//        print('Error while insert data ${error.toString()}');
//      });
//    });
//  }

//  Future<List<Map>> getFromlistDB(database) async{
//     return await database.rawQuery('SELECT * FROM lists');
//
//  }
}
