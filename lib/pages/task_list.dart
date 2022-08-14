import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:driving_detection_app/services/task.dart';
import 'package:http/http.dart' as http;
import 'package:driving_detection_app/services/loading.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Widget> taskList = [];
  List taskInfo = [];
  late http.Response response;
  bool firstRequest = true;

  Future<void> getData() async {
    response = await http.get(Uri.parse('http://127.0.0.1:5000/tasklist'));
    taskInfo = json.decode(response.body);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // await getData();
  //   print('init!');
  //   print(taskInfo);
  // }

  @override
  Widget build(BuildContext context) {
    if (firstRequest) {
      // getFirstData();
      return Loading(
        onLoading: () async {
          try {
            await getData();
            setState(() {
              for (int i = 0; i < taskInfo.length; i++) {
                taskList.add(TaskItem(
                  taskName: taskInfo[i]['name'],
                  taskId: i,
                  taskStatus: taskInfo[i]['status'],
                  progress: taskInfo[i]['progress'],
                ));
              }
              firstRequest = false;
            });
          } catch (e) {
            print(e);
          }
        },
      );
    } else {
      Future.delayed(const Duration(milliseconds: 500), () async {
        try {
          await getData();
          setState(() {});
        } catch (e) {
          print(e);
        }
      });
      // print('build!');
      taskList = [];
      for (int i = 0; i < taskInfo.length; i++) {
        taskList.add(TaskItem(
          taskName: taskInfo[i]['name'],
          taskId: i,
          taskStatus: taskInfo[i]['status'],
          progress: taskInfo[i]['progress'],
        ));
      }
      return NotificationListener<TaskNotification>(
        onNotification: (notification) {
          if (notification.type == 'delete') {
            http.get(Uri.parse(
                'http://127.0.0.1:5000/taskdelete/${notification.taskId}'));
          } else if (notification.type == 'detail') {}
          return true;
        },
        child: ListView(
          controller: ScrollController(),
          children: taskList,
        ),
      );
    }
  }
}
