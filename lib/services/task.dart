import 'package:flutter/material.dart';
import 'package:progresso/progresso.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sprintf/sprintf.dart';
import 'package:driving_detection_app/services/modal.dart';
import 'package:dart_vlc/dart_vlc.dart';

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
      required this.taskId,
      required this.videoName,
      required this.yolov5ModelName,
      required this.clrnetModelName,
      required this.clrnetBackbone,
      required this.yolov5Period,
      required this.clrnetPeriod})
      : super(key: key);
  final String taskName;
  final String taskStatus;
  final double progress;
  final int taskId;
  final String videoName;
  final String yolov5ModelName;
  final String clrnetModelName;
  final String clrnetBackbone;
  final int yolov5Period;
  final int clrnetPeriod;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool showDetail = false;
  bool showOnlineVideo = false;
  final player = Player(id: 114514, registerTexture: false);

  @override
  Widget build(BuildContext context) {
    final Widget statusIcon;
    final media =
        Media.network('http://127.0.0.1:5000/onlinevideo/${widget.videoName}');
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
                        visible: showDetail,
                        modal: Dialog(
                            child: SizedBox(
                          width: 400,
                          height: 500,
                          child: ListView(
                            controller: ScrollController(),
                            children: [
                              ListTile(
                                leading: const Text('任务名称'),
                                title: Text(widget.taskName),
                              ),
                              ListTile(
                                leading: const Text('视频名称'),
                                title: Text(widget.videoName),
                              ),
                              ListTile(
                                leading: const Text('yolov5模型'),
                                title: Text(widget.yolov5ModelName),
                              ),
                              ListTile(
                                leading: const Text('CLRNet模型'),
                                title: Text(widget.clrnetModelName),
                              ),
                              ListTile(
                                leading: const Text('CLENet backbone'),
                                title: Text(widget.clrnetBackbone),
                              ),
                              ListTile(
                                leading: const Text('yolov5处理周期'),
                                title: Text(widget.yolov5Period.toString()),
                              ),
                              ListTile(
                                leading: const Text('CLRNet处理周期'),
                                title: Text(widget.clrnetPeriod.toString()),
                              ),
                            ],
                          ),
                        )),
                        onClose: () => setState(() => showDetail = false),
                        child: IconButton(
                          icon: Icon(Icons.info_outline_rounded, color: Colors.blue[200],),
                          splashRadius: 15,
                          onPressed: () => setState(() => showDetail = true),
                        ),
                      ),
                      Modal(
                        visible: showOnlineVideo,
                        onClose: () => setState(() => showOnlineVideo = false),
                        modal: Dialog(
                          child: SizedBox(
                            width: 1920 / 2,
                            height: 1080 / 2,
                            child: NativeVideo(
                              player: player,
                              showControls: false,
                            ),
                          ),
                        ),
                        child: widget.taskStatus == 'done'
                            ? IconButton(
                                icon: Icon(
                                  Icons.play_circle_outline_rounded,
                                  color: Colors.blue[200],
                                ),
                                splashRadius: 15,
                                onPressed: () {
                                  setState(() {
                                    showOnlineVideo = true;
                                    player.open(media);
                                  });
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.play_circle_outline_rounded,
                                  color: Colors.grey[400],
                                ),
                              ),
                      ),
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
