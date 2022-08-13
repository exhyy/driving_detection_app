import 'dart:convert';
import 'dart:developer';

import 'package:driving_detection_app/services/multipart_request.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:progresso/progresso.dart';
import 'package:sprintf/sprintf.dart';
import 'package:http/http.dart' as http;

class ProgressBar extends StatelessWidget {
  final int? currentStep;
  const ProgressBar({Key? key, this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LinearProgressBar(
          maxSteps: 100,
          progressType: LinearProgressBar.progressTypeLinear,
          currentStep: currentStep,
          progressColor: Colors.red,
          backgroundColor: Colors.grey,
        ),
      ],
    );
  }
}

class UploadWidget extends StatefulWidget {
  final String defaultMessage;
  final String uploadUrl;
  const UploadWidget({Key? key, required this.defaultMessage, required this.uploadUrl}) : super(key: key);

  @override
  State<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  String _filePath = '';
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 35.0,
                ),
                child: TextField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                      text:
                          _filePath == '' ? widget.defaultMessage : _filePath),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ElevatedButton(
                child: const Text('选择文件'),
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      _filePath = result.files.single.path!;
                    });
                  }
                },
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 6.0,
            ),
            Expanded(
              child: Progresso(
                progress: _progress,
                progressColor: Colors.greenAccent,
                backgroundColor: Colors.grey[700]!,
                progressStrokeCap: StrokeCap.round,
                backgroundStrokeCap: StrokeCap.round,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(sprintf('%2d %%', [int.parse((_progress*100).toString().split('.')[0])])),
            ),
          ],
        ),
        TextButton(
          child: const Text('上传'),
          onPressed: () async {
            var request = MultipartRequest(
              'POST',
              Uri.parse(widget.uploadUrl),
              onProgress: (bytes, total) {
                setState(() {
                  _progress = bytes / total;
                });
                log('progress: $_progress ($bytes/$total)');
              },
            );
            request.files
                .add(await http.MultipartFile.fromPath('file', _filePath));
            var res = await request.send();
            res.stream.transform(utf8.decoder).listen((event) {
              log(event);
            });
          },
        ),
      ],
    );
  }
}
