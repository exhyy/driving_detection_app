import 'package:flutter/material.dart';
import 'package:driving_detection_app/services/upload.dart';

class UploadResource extends StatelessWidget {
  const UploadResource({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
