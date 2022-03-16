// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_is_empty, sized_box_for_whitespace, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdwl/shared/cubit/cubit.dart';
import 'package:gdwl/shared/cubit/states.dart';
import 'package:gdwl/view/widgets/alltasks_complete.dart';
import 'package:gdwl/view/widgets/donetasks_expanisoncard.dart';
import 'package:gdwl/view/widgets/notasks.dart';
import 'package:gdwl/view/widgets/subtask_itembuilder.dart';
import 'package:gdwl/view/widgets/task_itembuilder.dart';


class MyTasksScreen extends StatelessWidget {

  int listId;


  MyTasksScreen({required this.listId });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var newTasks = AppCubit
            .get(context)
            .newTasks;
        
        var doneTasks = AppCubit
            .get(context)
            .doneTasks;

        var doneSubTasks = AppCubit
            .get(context)
            .doneSubTasks;


        return doneTasks.isNotEmpty
            ? Column(
              children: [
                SingleChildScrollView(
                child: newTasks.isNotEmpty
                    ? TaskItemBuilder(tasks:newTasks , listId: listId)
                    : AllTasksComplete()),
                DoneTasksExpansion(tasks: doneTasks , listId: listId,),
              ],
            )
            : newTasks.isNotEmpty
            ? TaskItemBuilder(tasks: newTasks, listId: listId)
            : NoTasksYet();
      });
  }
}
