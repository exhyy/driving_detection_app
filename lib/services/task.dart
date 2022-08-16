import 'package:flutter/material.dart';
import 'package:progresso/progresso.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sprintf/sprintf.dart';
import 'package:driving_detection_app/services/modal.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:internet_file/internet_file.dart';
import 'package:internet_file/storage_io.dart';
import 'package:driving_detection_app/services/notification.dart';

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
      required this.clrnetPeriod,
      required this.errorMessage})
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
  final String errorMessage;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool showDetail = false;
  bool showOnlineVideo = false;
  String downloadStatus = 'waiting';
  double downloadProgress = 0.0;
  double _tempProgress = 0.0;
  final player = Player(id: 114514, registerTexture: false);

  void downloadOutput() async {
    final storageIO = InternetFileStorageIO();

    await InternetFile.get(
      'http://127.0.0.1:5000/downloadoutput/${widget.taskName}_${widget.videoName}',
      storage: storageIO,
      progress: (receivedLength, contentLength) {
        _tempProgress = receivedLength / contentLength;
        if (_tempProgress - downloadProgress > 0.01 || _tempProgress == 1.0) {
          downloadProgress = _tempProgress;
          // print('progress: $progress');
          setState(() {
            downloadProgress = _tempProgress;
          });
        }
      },
      storageAdditional: storageIO.additional(
        filename: '${widget.taskName}_${widget.videoName}',
        location: './download/',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget statusIcon;
    final media = Media.network(
        'http://127.0.0.1:5000/onlinevideo/${widget.taskName}_${widget.videoName}');
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
    } else if (widget.taskStatus == 'done') {
      statusIcon = const Padding(
        padding: EdgeInsets.fromLTRB(28, 0, 0, 0),
        child: Icon(
          Icons.check,
          color: Colors.blue,
        ),
      );
    } else {
      statusIcon = const Padding(
        padding: EdgeInsets.fromLTRB(28, 0, 0, 0),
        child: Icon(
          Icons.error_outline_rounded,
          color: Colors.red,
        ),
      );
    }

    late Widget downloadWidget;
    if (widget.taskStatus != 'done') {
      downloadWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.download_rounded,
          color: Colors.grey[400],
          size: 34,
        ),
      );
    } else {
      if (downloadStatus == 'waiting') {
        downloadWidget = IconButton(
          icon: Icon(
            Icons.download_rounded,
            color: Colors.blue[200],
          ),
          iconSize: 34,
          splashRadius: 15,
          onPressed: () {
            downloadOutput();
            setState(() {
              downloadStatus = 'running';
            });
          },
        );
      } else if (downloadStatus == 'running') {
        downloadWidget = Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircularPercentIndicator(
            radius: 15,
            lineWidth: 3,
            percent: downloadProgress,
            center: Text(
              sprintf('%2d', [
                int.parse((downloadProgress * 100).toString().split('.')[0])
              ]),
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            // footer: Text('100%'),
            progressColor: Colors.green[400],
          ),
        );
      }
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
                        child: Text(
                          widget.taskName,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
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
                              widget.taskStatus == 'fail'
                                  ? ListTile(
                                      leading: const Text(
                                        '错误信息',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      title: Text(
                                        widget.errorMessage,
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                        
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        )),
                        onClose: () => setState(() => showDetail = false),
                        child: IconButton(
                          icon: Icon(
                            Icons.info_outline_rounded,
                            color: Colors.blue[200],
                          ),
                          iconSize: 34,
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
                                iconSize: 34,
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
                                  size: 34,
                                ),
                              ),
                      ),
                      downloadWidget,
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
          iconSize: 34,
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
