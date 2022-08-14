import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:driving_detection_app/services/VideoItem.dart';
import 'package:driving_detection_app/services/loading.dart';
import 'package:http/http.dart' as http;
class SubmitTask extends StatefulWidget {
  const SubmitTask({
    Key? key,
  }) : super(key: key);

  @override
  State<SubmitTask> createState() => _SubmitTaskState();
}

class _SubmitTaskState extends State<SubmitTask> {
  List <Widget> l =[];
  List <String> videonames =[];
  static bool loadingFinishedsubmit = false;
  int checkedIndex = 0;

  @override
  Widget build(BuildContext context) {
    l = [];
    for (int i =0;i<videonames.length;i++){
      l.add(VideoItem(downloadUrl: "http://127.0.0.1:5000/download/",videoname: videonames[i],index: i, checked: checkedIndex == i));
    }
    return loadingFinishedsubmit
    ?NotificationListener<VideoItemNotification>(
      onNotification: (notification) {
        setState(() {
          checkedIndex = notification.checkedIndex;
        });
        return true;
      },
      child: Column(
        children: [
          Expanded(
            child: RepaintBoundary (
                    child: SizedBox(
                      height: 50.0,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: SizedBox(
                            width: double.infinity,
                            child: Wrap
                            (
                              textDirection: TextDirection.ltr,
                              alignment: WrapAlignment.start,
                              spacing: 5, //主轴上子控件的间距2
                              runSpacing: 5, //交叉轴上子控件之间的间距
                              children: l
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height/2,)
        ],
      ),
    )
    : Loading(
            onLoading: () async {
              await Future.delayed(const Duration(seconds: 2));
              final client = http.Client();
              final url = Uri.parse("http://127.0.0.1:5000/videolist");
              final response = await client.get(url);
              if (response.statusCode!=0) 
                {
                  videonames=jsonDecode(response.body).cast<String>();
                } else {
                  print(response.statusCode);
                }
              setState(() {
                loadingFinishedsubmit = true;
              });
            },
          );
  }
}