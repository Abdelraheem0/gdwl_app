// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NoTasksYet extends StatelessWidget {
  const NoTasksYet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.snooze_outlined,
            size: MediaQuery.of(context).size.width / 3,
          ),
          SizedBox(height: 10.0),
          Text(
            'No tasks yet',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
