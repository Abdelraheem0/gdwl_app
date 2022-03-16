// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, must_be_immutable, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdwl/models/subtask_model.dart';
import 'package:gdwl/models/task_model.dart';
import 'package:intl/intl.dart';
import 'package:gdwl/shared/cubit/cubit.dart';
import 'package:gdwl/shared/cubit/states.dart';

class TaskDetailsScreen extends StatelessWidget {
  String? taskName;
  String? taskDetails;
  String? taskDate;
  String? taskTime;
  int taskId;
  TaskDetailsScreen(
      {
      this.taskName,
      this.taskDetails,
      this.taskDate,
      this.taskTime,
     required this.taskId});

  var taskNameController = TextEditingController();
  var taskDetailsController = TextEditingController();
  var taskDateController = TextEditingController();
  var taskTimeController = TextEditingController();
//  var subTaskNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInsertSubTasksToDatabase) {
          AppCubit.get(context).subTaskNameController.text = '';
//          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if(cubit.subTaskNameController.text.isNotEmpty)
                  {
                    final subTask = SubTaskModel(
                      name: cubit.subTaskNameController.text,
                      details: cubit.subTaskDetailsController.text,
                      date: cubit.subTaskDateController.text,
                      time: cubit.subTaskTimeController.text,
                      status: 'new',
                      taskId: taskId,
                    );
                    cubit.insertSubTask(subTask);

                    if(taskNameController.text.isEmpty){
                      taskNameController.text = taskName!;
                      cubit.updateTaskData(
                        taskNameController.text,
                        taskDetailsController.text,
                        taskDateController.text,
                        taskTimeController.text,
                        taskId,
                      );
                    }else{
                      cubit.updateTaskData(
                        taskNameController.text,
                        taskDetailsController.text,
                        taskDateController.text,
                        taskTimeController.text,
                        taskId,
                      );
                    }
                  }else{
                  cubit.updateTaskData(
                    taskNameController.text,
                    taskDetailsController.text,
                    taskDateController.text,
                    taskTimeController.text,
                    taskId,
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
                    cubit.deleteTask(taskId);
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
                  controller: taskNameController..text = taskName!,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                ),
                taskDetails!.isEmpty
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
                        controller: taskDetailsController,
                      )
                    : TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.description_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        controller: taskDetailsController..text = taskDetails!,
                        style: TextStyle(fontSize: 20.0),
                      ),
                taskDate!.isEmpty
                    ? TextFormField(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2022-03-16'),
                          ).then((value) {
                            taskDateController.text =
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
                        controller: taskDateController,
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
                            taskDateController.text =
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
                        controller: taskDateController..text = taskDate!,
                        style: TextStyle(fontSize: 20.0),
                      ),
                taskTime!.isEmpty
                    ? TextFormField(
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            taskTimeController.text = value!.format(context);
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
                        controller: taskTimeController,
                        style: TextStyle(fontSize: 18.0),
                      )
                    : TextFormField(
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            taskTime = value!.format(context);
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.watch_later_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        controller: taskTimeController..text = taskTime!,
                        style: TextStyle(fontSize: 20.0),
                      ),

                TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add subtask',
                    prefixIcon: Icon(
                      Icons.subdirectory_arrow_right,
                      color: Colors.grey,
                    ),
                  ),
                  controller: cubit.subTaskNameController,
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


//Padding(
//                  padding: const EdgeInsets.symmetric(
//                      vertical: 8.0, horizontal: 15.0),
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      Icon(
//                        Icons.subdirectory_arrow_right,
//                        color: Colors.grey[500],
//                      ),
//                      SizedBox(
//                        width: 8.0,
//                      ),
//                      cubit.subTasksCounter == 0
//                          ? GestureDetector(
//                              onTap: () {
//                                cubit.increaseSubTasks();
//                              },
//                              child: Text(
//                                'Add subtasks',
//                                style: TextStyle(
//                                    color: Colors.grey[600], fontSize: 18.0),
//                              ),
//                            )
//                          : Expanded(
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: [
//                                  ListView.builder(
//                                    scrollDirection: Axis.vertical,
//                                    shrinkWrap: true,
//                                    itemBuilder: (context, index) => Container(
//                                      width: MediaQuery.of(context).size.width /
//                                          1.25,
//                                      child: TextFormField(
//                                        decoration: InputDecoration(
//                                          border: InputBorder.none,
//                                          prefixIcon: IconButton(
//                                            icon: Icon(
//                                              Icons.circle_outlined,
//                                              color: Colors.grey,
//                                            ),
//                                            onPressed: () {
//
//                                            },
//                                          ),
//                                          suffixIcon: IconButton(
//                                            icon: Icon(
//                                              Icons.close,
//                                              color: Colors.grey,
//                                            ),
//                                            onPressed: () {
//                                              cubit.decreaseSubTasks();
//                                            },
//                                          ),
//                                          hintText: 'Enter title',
//                                        ),
//                                        controller: subTaskNameController,
//                                        style: TextStyle(fontSize: 18.0),
//                                      ),
//                                    ),
//                                    itemCount: cubit.subTasksCounter,
//                                  ),
//                                  Center(
//                                    child: GestureDetector(
//                                      onTap: () {
//                                        cubit.increaseSubTasks();
//                                      },
//                                      child: Text(
//                                        'Add subtasks',
//                                        style: TextStyle(
//                                            color: Colors.grey[600],
//                                            fontSize: 18.0),
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                    ],
//                  ),
//                ),