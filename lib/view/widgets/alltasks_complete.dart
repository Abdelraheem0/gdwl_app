// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AllTasksComplete extends StatelessWidget {
  const AllTasksComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 120.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.done_all,
            size: MediaQuery.of(context).size.width / 3,
          ),
          SizedBox(height: 10.0),
          Text(
            'All tasks completed',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
          SizedBox(height: 5.0),
          Text(
            'Nice work !',
            style: TextStyle(
                color: Colors.grey, fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
