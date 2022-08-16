import 'package:flutter/material.dart';

class NetworkErrorNotification extends Notification {
  NetworkErrorNotification();
}

class TaskNotification extends Notification {
  final String type; // 'detail'或'delete'
  final int taskId;
  TaskNotification({required this.type, required this.taskId});
}
