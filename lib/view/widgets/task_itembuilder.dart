// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables
//Tasks and SubTasks item builder____________________________

import 'package:flutter/material.dart';
import 'package:gdwl/shared/cubit/cubit.dart';
import 'package:gdwl/view/screens/taskdetails_screen.dart';

import 'subtask_itembuilder.dart';

class TaskItemBuilder extends StatelessWidget {
  List tasks;
  int listId;

  TaskItemBuilder({required this.tasks, required this.listId});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0),
        child: tasks[index]['list_id'] == listId
            ? Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(20.0),
          ),
              child: Column(
                children: [
                  ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(
                          taskId: tasks[index]['id'],
                          taskName: tasks[index]['name'],
                          taskDetails: tasks[index]['details'],
                          taskDate: tasks[index]['date'].toString(),
                          taskTime: tasks[index]['time'].toString(),
                        )),
                  );
          },
          leading: IconButton(
                    onPressed: () {
                      cubit.updateTaskStatus('done', tasks[index]['id']);
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
        ),
                  AppCubit.get(context).newSubTasks.isNotEmpty
                      ? SubTaskItemBuilder(tasks: AppCubit.get(context).newSubTasks , taskId: tasks[index]['id'] ,)
                      : SizedBox.shrink()
                ],
              ),
            )
            : SizedBox.shrink(),
      ),
      itemCount: tasks.length,
    );
  }
}
