import 'package:flutter/material.dart';
import 'package:progresso/progresso.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sprintf/sprintf.dart';

class TaskNotification extends Notification {
  final String type; // 'detail'或'delete'
  final int taskId;
  TaskNotification({required this.type, required this.taskId});
}

class TaskItem extends StatelessWidget {
  const TaskItem(
      {Key? key,
      required this.taskName,
      required this.taskStatus,
      required this.progress,
      required this.taskId})
      : super(key: key);
  final String taskName;
  final String taskStatus;
  final double progress;
  final int taskId;

  @override
  Widget build(BuildContext context) {
    final Widget statusIcon;
    if (taskStatus == 'waiting') {
      statusIcon = const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Icon(Iconsax.clock),
      );
    } else if (taskStatus == 'running') {
      statusIcon = const Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: SpinKitThreeBounce(
          color: Colors.blue,
          size: 20,
        ),
      );
    } else {
      statusIcon = const Padding(
        padding: EdgeInsets.fromLTRB(28, 0, 0, 0),
        child: Icon(
          Icons.check,
          color: Colors.blue,
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Text(taskName),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline_rounded),
                        splashRadius: 15,
                        onPressed: () => TaskNotification(taskId: taskId, type: 'detail').dispatch(context),
                      )
                    ],
                  ),
                ),
                statusIcon,
              ],
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Progresso(
                    progress: progress,
                    progressColor: Colors.greenAccent,
                    backgroundColor: Colors.grey[700]!,
                    progressStrokeCap: StrokeCap.round,
                    backgroundStrokeCap: StrokeCap.round,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(sprintf('%2d %%',
                      [int.parse((progress * 100).toString().split('.')[0])])),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          // icon: const Icon(Icons.delete, color: Colors.red,),
          icon: taskStatus == 'running'
            ? Icon(Icons.delete, color: Colors.grey[400],)
            : const Icon(Icons.delete,color: Colors.red,),
          splashRadius: 20,
          onPressed: taskStatus == 'running'
            ? null
            : () => TaskNotification(type: 'delete', taskId: taskId).dispatch(context),
        ),
      ],
    );
  }
}
