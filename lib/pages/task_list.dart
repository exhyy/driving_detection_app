import 'package:flutter/material.dart';
import 'package:driving_detection_app/services/task.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: ScrollController(),
      children: [
        TaskItem(
            taskName: 'adsjnfakjsdfkjasdfshad',
            taskStatus: 'running',
            progress: 0.55,
            taskId: 0,),
        TaskItem(taskName: 'Task 007', taskStatus: 'done', progress: 1, taskId: 1,),
        TaskItem(taskName: '10086', taskStatus: 'waiting', progress: 0, taskId: 2,),
      ],
    );
  }
}
