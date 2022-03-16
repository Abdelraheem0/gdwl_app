// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdwl/models/list_model.dart';
import 'package:gdwl/shared/cubit/cubit.dart';
import 'package:gdwl/shared/cubit/states.dart';

class CreateNewList extends StatefulWidget {

  @override
  State<CreateNewList> createState() => _CreateNewListState();
}

class _CreateNewListState extends State<CreateNewList> {
  var listNameController = TextEditingController();

  Color doneBtnColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Create New List'),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)),
            actions: [
              TextButton(
                  onPressed: () {
                    if(doneBtnColor == Colors.grey)
                      {
                        return ;
                      }else{
                      final list = ListModel(
                        name: listNameController.text,
                      );
                      cubit.insertList(list).then((value) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(color: doneBtnColor),
                  )),
            ],
            backgroundColor: Colors.blue,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value){
                setState(() {
                  if(value.isNotEmpty)
                  {
                      doneBtnColor = Colors.white;
                  }else{
                    doneBtnColor = Colors.grey;
                  }
                });

              },
              controller: listNameController,
              decoration: InputDecoration(
                hintText: 'Enter List Name',
              ),
            ),
          ),
        );
      },
    );
  }
}
