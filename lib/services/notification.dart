import 'package:flutter/material.dart';

class PageJumpNotification extends Notification {
  final int page;
  PageJumpNotification({required this.page});
}

class TaskNotification extends Notification {
  final String type; // 'detail'或'delete'
  final int taskId;
  TaskNotification({required this.type, required this.taskId});
}
