// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, must_be_immutable, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdwl/models/subtask_model.dart';
import 'package:gdwl/models/task_model.dart';
import 'package:intl/intl.dart';
import 'package:gdwl/shared/cubit/cubit.dart';
import 'package:gdwl/shared/cubit/states.dart';

class SubTaskDetailsScreen extends StatelessWidget {
  String? subTaskName;
  String? subTaskDetails;
  String? subTaskDate;
  String? subTaskTime;
  int subTaskId;

  SubTaskDetailsScreen(
      {
        this.subTaskName,
        this.subTaskDetails,
        this.subTaskDate,
        this.subTaskTime,
        required this.subTaskId});

  var subTaskNameController = TextEditingController();
  var subTaskDetailsController = TextEditingController();
  var subTaskDateController = TextEditingController();
  var subTaskTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                  if(subTaskNameController.text.isEmpty){
                    subTaskNameController.text = subTaskName!;
                    cubit.updateSubTaskData(
                      subTaskNameController.text,
                      subTaskDetailsController.text,
                      subTaskDateController.text,
                      subTaskTimeController.text,
                      subTaskId,
                    );
                  }else{
                    cubit.updateSubTaskData(
                      subTaskNameController.text,
                      subTaskDetailsController.text,
                      subTaskDateController.text,
                      subTaskTimeController.text,
                      subTaskId,
                    );
                  }
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              color: Colors.blue,
              iconSize: 30.0,
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                    cubit.deleteSubTask(subTaskId);
                  },
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.redAccent,
                    size: 35.0,
                  )),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  controller: subTaskNameController..text = subTaskName!,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                ),
                subTaskDetails!.isEmpty
                    ? TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Add details',
                  ),
                  style: TextStyle(fontSize: 18.0),
                  controller: subTaskDetailsController,
                )
                    : TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  controller: subTaskDetailsController..text = subTaskDetails!,
                  style: TextStyle(fontSize: 20.0),
                ),
                subTaskDate!.isEmpty
                    ? TextFormField(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.parse('2022-03-16'),
                    ).then((value) {
                      subTaskDateController.text =
                          DateFormat.yMMMd().format(value!);
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.date_range,
                      color: Colors.grey,
                    ),
                    hintText: 'Add date',
                  ),
                  controller: subTaskDateController,
                  style: TextStyle(fontSize: 18.0),
                )
                    : TextFormField(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.parse('2022-03-16'),
                    ).then((value) {
                      subTaskDateController.text =
                          DateFormat.yMMMd().format(value!);
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.date_range,
                      color: Colors.grey,
                    ),
                  ),
                  controller: subTaskDateController..text = subTaskDate!,
                  style: TextStyle(fontSize: 20.0),
                ),
                subTaskTime!.isEmpty
                    ? TextFormField(
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      subTaskTimeController.text = value!.format(context);
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.watch_later_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Add time',
                  ),
                  controller: subTaskTimeController,
                  style: TextStyle(fontSize: 18.0),
                )
                    : TextFormField(
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      subTaskTime = value!.format(context);
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.watch_later_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  controller: subTaskTimeController..text = subTaskTime!,
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
