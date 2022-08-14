import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:driving_detection_app/services/VideoItem.dart';
import 'package:driving_detection_app/services/loading.dart';
import 'package:http/http.dart' as http;
import 'package:numberpicker/numberpicker.dart';

class SubmitTask extends StatefulWidget {
  const SubmitTask({
    Key? key,
  }) : super(key: key);

  @override
  State<SubmitTask> createState() => _SubmitTaskState();
}

class _SubmitTaskState extends State<SubmitTask> {
  int _currentValue=1;
  List <Widget> l_image =[];
  List <DropdownMenuItem<String>> l_yolo =[];
  List <DropdownMenuItem<String>> l_CLR =[];
  static List <String> videonames =[];
  static List <String> weightsofyolo =[];
  static List <String> weightsofCLR =[];
  static bool loadingFinishedsubmit = false;
  int checkedIndex = 0;
  var _dropValue_yolo = '0';
  var _dropValue_CLR = '0';
  @override
  Widget build(BuildContext context) {
    l_image = [];
    l_CLR =[];
    l_yolo=[];
    for (int i =0;i<videonames.length;i++){
      l_image.add(VideoItem(downloadUrl: "http://127.0.0.1:5000/download/",videoname: videonames[i],index: i, checked: checkedIndex == i));
    }
    for (int i =0;i<weightsofyolo.length;i++){
      l_yolo.add(DropdownMenuItem(child: Text(weightsofyolo[i]),value: i.toString(),));
      print(l_yolo[0]);
    }
        for (int i =0;i<weightsofCLR.length;i++){
      l_CLR.add(DropdownMenuItem(child: Text(weightsofCLR[i]),value: i.toString(),));
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
          const Center(
            child:Text("选择视频",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              fontFamily: "SimHei",
            ),),
          ),
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
                              children: l_image
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const Divider(),
          Column(
            children: [
              const Center(
                child:Text("选择YOLO模型",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  fontFamily: "SimHei",
                ),),
              ),
              Center(
                child:DropdownButton(
                value: _dropValue_yolo,
                isExpanded: true,
                items: l_yolo,
                onChanged: (value){
                  setState(() {
                    _dropValue_yolo = value.toString();
                  });
                },
              ),
              ),
              Center(
                child:DropdownButton(
                value: _dropValue_CLR,
                isExpanded: true,
                items: l_CLR,
                onChanged: (value){
                  setState(() {
                    _dropValue_CLR = value.toString();
                  });
                },
              ),
              ),
              const Divider(),
              Center(
                child:NumberPicker(
                  value: _currentValue ,
                  minValue: 0,
                  maxValue: 5,
                  haptics: true,
                  onChanged: (value) => setState(() => _currentValue = value),
                ),
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => setState(() {
                    final newValue = _currentValue - 1;
                    _currentValue = newValue.clamp(0, 5);
                  }),
                ),
                Text('Current int value: $_currentValue'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => setState(() {
                    final newValue = _currentValue + 1;
                    _currentValue = newValue.clamp(0, 5);
                  }),
                ),
              ],
            ),
            ],
          ),
          
          SizedBox(height: MediaQuery.of(context).size.height*1/2,)

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
                  setState(() {
                    videonames=jsonDecode(response.body)["namesofvideo"].cast<String>();
                    weightsofyolo=jsonDecode(response.body)["weightsofyolov5"].cast<String>();
                    weightsofCLR=jsonDecode(response.body)["weightsofCLR"].cast<String>();
                  });
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