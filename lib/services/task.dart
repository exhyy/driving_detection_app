import 'package:flutter/material.dart';
import 'package:progresso/progresso.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sprintf/sprintf.dart';
import 'package:driving_detection_app/services/moral.dart';

class TaskNotification extends Notification {
  final String type; // 'detail'或'delete'
  final int taskId;
  TaskNotification({required this.type, required this.taskId});
}

class TaskItem extends StatefulWidget {
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
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool showModal = false;

  @override
  Widget build(BuildContext context) {
    final Widget statusIcon;
    if (widget.taskStatus == 'waiting') {
      statusIcon = const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Icon(Iconsax.clock),
      );
    } else if (widget.taskStatus == 'running') {
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
                        child: Text(widget.taskName),
                      ),
                      Modal(
                        visible: showModal,
                        modal: const Dialog(
                          child: Text('some infomation'),
                        ),
                        onClose: () => setState(() => showModal = false),
                        child: IconButton(
                          icon: const Icon(Icons.info_outline_rounded),
                          splashRadius: 15,
                          onPressed: () => setState(() => showModal = true),
                          // onPressed: () => TaskNotification(
                          //         taskId: widget.taskId, type: 'detail')
                          //     .dispatch(context),
                        ),
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
                    progress: widget.progress,
                    progressColor: Colors.greenAccent,
                    backgroundColor: Colors.grey[700]!,
                    progressStrokeCap: StrokeCap.round,
                    backgroundStrokeCap: StrokeCap.round,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(sprintf('%2d %%', [
                    int.parse((widget.progress * 100).toString().split('.')[0])
                  ])),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          // icon: const Icon(Icons.delete, color: Colors.red,),
          icon: widget.taskStatus == 'running'
              ? Icon(
                  Icons.delete,
                  color: Colors.grey[400],
                )
              : const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
          splashRadius: 20,
          onPressed: widget.taskStatus == 'running'
              ? null
              : () => TaskNotification(type: 'delete', taskId: widget.taskId)
                  .dispatch(context),
        ),
      ],
    );
  }
}
