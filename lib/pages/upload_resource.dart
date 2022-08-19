import 'package:flutter/material.dart';
import 'package:driving_detection_app/services/upload.dart';
import 'package:driving_detection_app/pages/home.dart';

class UploadResource extends StatelessWidget {
  const UploadResource({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UploadWidget(
          defaultMessage: '上传视频',
          uploadUrl: '${Global.appConfig['server_url']}/upload/video',
        ),
        const Divider(),
        UploadWidget(
          defaultMessage: '上传物体检测模型(yolov5s)',
          uploadUrl: '${Global.appConfig['server_url']}/upload/od_model',
        ),
        const Divider(),
        UploadWidget(
          defaultMessage: '上传车道检测模型(CLRNet)',
          uploadUrl: '${Global.appConfig['server_url']}/upload/ld_model',
        ),
      ],
    );
  }
}
