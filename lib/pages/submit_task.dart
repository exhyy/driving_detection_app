import 'package:flutter/material.dart';
import 'package:driving_detection_app/services/VideoItem.dart';

class SubmitTask extends StatefulWidget {
  const SubmitTask({
    Key? key,
  }) : super(key: key);

  @override
  State<SubmitTask> createState() => _SubmitTaskState();
}

class _SubmitTaskState extends State<SubmitTask> {
  List <Widget> l =[];
  _SubmitTaskState()
  {
    
    l.add(const VideoItem(downloadUrl: "http://127.0.0.1:5001/download/",videoname: "README.md"));
  }
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}