import 'package:flutter/material.dart';
import 'package:driving_detection_app/services/upload.dart';
import 'package:driving_detection_app/services/loading.dart';

class UploadResource extends StatefulWidget {
  const UploadResource({Key? key}) : super(key: key);

  @override
  State<UploadResource> createState() => _UploadResourceState();
}

class _UploadResourceState extends State<UploadResource> {
  static bool loadingFinished = false;

  @override
  Widget build(BuildContext context) {
    return loadingFinished
        ? Column(
            children: const [
              UploadWidget(
                defaultMessage: '上传视频',
                uploadUrl: 'http://127.0.0.1:5000/upload/video',
              ),
              Divider(),
              UploadWidget(
                defaultMessage: '上传物体检测模型(yolov5s)',
                uploadUrl: 'http://127.0.0.1:5000/upload/od_model',
              ),
              Divider(),
              UploadWidget(
                defaultMessage: '上传车道监测模型(CLRNet)',
                uploadUrl: 'http://127.0.0.1:5000/upload/ld_model',
              ),
            ],
          )
        : Loading(
            onLoading: () async {
              await Future.delayed(const Duration(seconds: 2));
              setState(() {
                loadingFinished = true;
              });
            },
          );
  }
}
