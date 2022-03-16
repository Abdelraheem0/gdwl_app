// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sized_box_for_whitespace, must_be_immutable

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:gdwl/shared/cubit/cubit.dart';
import 'package:gdwl/view/screens/subtask_details_screen.dart';
import 'package:gdwl/view/screens/taskdetails_screen.dart';

class DoneTasksExpansion extends StatelessWidget {
  List tasks;
  int listId;

  DoneTasksExpansion({required this.tasks, required this.listId});

  GlobalKey<ExpansionTileCardState> completeCard = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ExpansionTileCard(
      key: completeCard,
      title: Text('Completed'),
      children: [
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: tasks[index]['list_id'] == listId
                  ? ListTile(
                onTap: () {
                  tasks == AppCubit.get(context).doneTasks
                      ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(
                              taskId: tasks[index]['id'],
                              taskName: tasks[index]['name'],
                              taskDetails: tasks[index]['details'],
                              taskDate: tasks[index]['date'].toString(),
                              taskTime: tasks[index]['time'].toString(),
                            )),
                  )
                      : Navigator.push(
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
                    onPressed: () {},
                    icon: Icon(
                      Icons.check,
                    )),
                title: Text(
                  '${tasks[index]['name']}',
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
                subtitle: Text('${tasks[index]['details']}'),
              )
                  : SizedBox.shrink(),
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              width: double.infinity,
              height: 1.0,
            );
          },
          itemCount: tasks.length,
        ),
      ],
    );
  }
}
