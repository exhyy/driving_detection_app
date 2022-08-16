import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:driving_detection_app/services/task.dart';
import 'package:http/http.dart' as http;
import 'package:driving_detection_app/services/loading.dart';
import 'package:driving_detection_app/services/notification.dart';

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
                  videoName: taskInfo[i]['video_name'],
                  yolov5ModelName: taskInfo[i]['yolov5_model_name'],
                  clrnetModelName: taskInfo[i]['clrnet_model_name'],
                  clrnetBackbone: taskInfo[i]['clrnet_backbone'],
                  yolov5Period: taskInfo[i]['yolov5_period'],
                  clrnetPeriod: taskInfo[i]['clrnet_period'],
                ));
              }
              firstRequest = false;
            });
          } catch (e) {
            PageJumpNotification(page: 0).dispatch(context);
          }
        },
      );
    } else {
      Future.delayed(const Duration(milliseconds: 500), () async {
        try {
          try {
            await getData();
          } catch (e) {
            PageJumpNotification(page: 0).dispatch(context);
          }
          setState(() {});
        } catch (e) {}
      });
      // print('build!');
      taskList = [];
      for (int i = 0; i < taskInfo.length; i++) {
        taskList.add(TaskItem(
          taskName: taskInfo[i]['name'],
          taskId: i,
          taskStatus: taskInfo[i]['status'],
          progress: taskInfo[i]['progress'],
          videoName: taskInfo[i]['video_name'],
          yolov5ModelName: taskInfo[i]['yolov5_model_name'],
          clrnetModelName: taskInfo[i]['clrnet_model_name'],
          clrnetBackbone: taskInfo[i]['clrnet_backbone'],
          yolov5Period: taskInfo[i]['yolov5_period'],
          clrnetPeriod: taskInfo[i]['clrnet_period'],
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
