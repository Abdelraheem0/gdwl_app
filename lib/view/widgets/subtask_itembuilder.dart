// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables
//Tasks and SubTasks item builder____________________________

import 'package:flutter/material.dart';
import 'package:gdwl/shared/cubit/cubit.dart';
import 'package:gdwl/view/screens/subtask_details_screen.dart';
import 'package:gdwl/view/screens/taskdetails_screen.dart';

class SubTaskItemBuilder extends StatelessWidget {
  List tasks;
  int taskId;

  SubTaskItemBuilder({required this.tasks , required this.taskId});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: tasks[index]['task_id'] ==  taskId
          ? ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SubTaskDetailsScreen(
                      subTaskId: tasks[index]['id'],
                      subTaskName: tasks[index]['name'],
                      subTaskDetails: tasks[index]['details'],
                      subTaskDate: tasks[index]['date'].toString(),
                      subTaskTime: tasks[index]['time'].toString(),
                    )),
              );
            },
            leading: IconButton(
                onPressed: () {
                  cubit.updateSubTaskStatus('done', tasks[index]['id']);
                },
                icon: Icon(Icons.circle_outlined)),
            title: Text('${tasks[index]['name']}'),
            subtitle: Text('${tasks[index]['details']}'),
            trailing: tasks[index]['date'].toString().isEmpty &&
                tasks[index]['time'].toString().isEmpty
                ? SizedBox.shrink()
                : GestureDetector(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width * 0.34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${tasks[index]['date']}',
                          style: TextStyle(fontSize: 10.0),
                        ),
                        SizedBox(
                          width: 1.0,
                        ),
                        tasks[index]['date'].toString().isNotEmpty &&
                            tasks[index]['time'].toString().isNotEmpty
                            ? Text(',')
                            : SizedBox.shrink(),
                        SizedBox(
                          width: 1.0,
                        ),
                        Text(
                          '${tasks[index]['time']}',
                          style: TextStyle(fontSize: 10.0),
                        ),
                      ],
                    )),
              ),
            ),
          )
              : SizedBox.shrink()
        ),
        itemCount: tasks.length,
      ),
    );
  }
}
