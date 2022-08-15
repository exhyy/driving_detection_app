import 'dart:convert';
import 'package:driving_detection_app/pages/home.dart';
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
  int _currentValueofyolo = 1;
  int _currentValueofCLR = 1;
  List<Widget> l_image = [];
  List<DropdownMenuItem<String>> l_yolo = [];
  List<DropdownMenuItem<String>> l_CLR = [];
  static List<String> videonames = [];
  static List<String> weightsofyolo = [];
  static List<String> weightsofCLR = [];
  static bool loadingFinishedsubmit = false;
  int checkedIndex = 0;
  var _dropValue_yolo = '0';
  var _dropValue_CLR = '0';
  @override
  Widget build(BuildContext context) {
    l_image = [];
    l_CLR = [];
    l_yolo = [];
    for (int i = 0; i < videonames.length; i++) {
      l_image.add(VideoItem(
          downloadUrl: "http://127.0.0.1:5000/download/",
          videoname: videonames[i],
          index: i,
          checked: checkedIndex == i));
    }
    for (int i = 0; i < weightsofyolo.length; i++) {
      l_yolo.add(DropdownMenuItem(
        child: Text(weightsofyolo[i]),
        value: i.toString(),
      ));
      print(l_yolo[0]);
    }
    for (int i = 0; i < weightsofCLR.length; i++) {
      l_CLR.add(DropdownMenuItem(
        child: Text(weightsofCLR[i]),
        value: i.toString(),
      ));
    }
    var children2 = [
      const Center(
        child: Text(
          "选择模型",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            fontFamily: "SimHei",
          ),
        ),
      ),
      Center(
        child: DropdownButton(
          value: _dropValue_yolo,
          isExpanded: true,
          items: l_yolo,
          onChanged: (value) {
            setState(() {
              _dropValue_yolo = value.toString();
              global.config["yolov5_model_name"] =
                  weightsofyolo[int.parse(value.toString())];
            });
          },
        ),
      ),
      Center(
        child: DropdownButton(
          value: _dropValue_CLR,
          isExpanded: true,
          items: l_CLR,
          onChanged: (value) {
            setState(() {
              _dropValue_CLR = value.toString();
              global.config["clrnet_model_name"] =
                  weightsofCLR[int.parse(value.toString())];
            });
          },
        ),
      ),
      const Divider(),
      const Text(
        '周期',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          fontFamily: "SimHei",
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // SizedBox(width: MediaQuery.of(context).size.width*1/6,),
          Column(
            children: [
              Text('For Yolo', style: Theme.of(context).textTheme.headline6),
              Center(
                child: NumberPicker(
                    value: _currentValueofyolo,
                    minValue: 1,
                    maxValue: 5,
                    haptics: true,
                    onChanged: (value) {
                      setState(() {
                        _currentValueofyolo = value;
                        global.config["yolov5_period"] = _currentValueofyolo;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => setState(() {
                      final newValue = _currentValueofyolo - 1;
                      _currentValueofyolo = newValue.clamp(1, 5);
                      global.config["clrnet_period"] = _currentValueofyolo;
                    }),
                  ),
                  Text('Current int value: $_currentValueofyolo'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => setState(() {
                      final newValue = _currentValueofyolo + 1;
                      _currentValueofyolo = newValue.clamp(1, 5);
                    }),
                  ),
                ],
              ),
            ],
          ),
          // SizedBox(width: MediaQuery.of(context).size.width*1/3,),
          Column(
            children: [
              Text('For CLR', style: Theme.of(context).textTheme.headline6),
              Center(
                child: NumberPicker(
                  value: _currentValueofCLR,
                  minValue: 1,
                  maxValue: 5,
                  haptics: true,
                  onChanged: (value) =>
                      setState(() => _currentValueofCLR = value),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => setState(() {
                      final newValue = _currentValueofCLR - 1;
                      _currentValueofCLR = newValue.clamp(1, 5);
                    }),
                  ),
                  Text('Current int value: $_currentValueofCLR'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => setState(() {
                      final newValue = _currentValueofCLR + 1;
                      _currentValueofCLR = newValue.clamp(1, 5);
                    }),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return loadingFinishedsubmit
          ? NotificationListener<VideoItemNotification>(
              onNotification: (notification) {
                setState(() {
                  checkedIndex = notification.checkedIndex;
                });
                return true;
              },
              child: ListView(
                controller: ScrollController(),
                children: 
                  [Column(
                    children: [
                      const Center(
                        child: Text(
                          "选择视频",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            fontFamily: "SimHei",
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: constraints.copyWith(
                            minHeight: constraints.maxHeight * 0.3,
                            maxHeight: constraints.maxHeight,
                            minWidth: 50),
                        child: RepaintBoundary(
                          child: SizedBox(
                            height: 50.0,
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                controller: ScrollController(),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                      textDirection: TextDirection.ltr,
                                      alignment: WrapAlignment.start,
                                      spacing: 5, //主轴上子控件的间距2
                                      runSpacing: 5, //交叉轴上子控件之间的间距
                                      children: l_image),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      Column(
                        children: children2,
                      ),
                      ListTile(
                        title: TextField(),
                        trailing: MaterialButton(
                          child: const Text("提交"),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 3 / 7,
                      )
                    ],
                  ),
                ],
              ),
            )
          : Loading(
              onLoading: () async {
                await Future.delayed(const Duration(seconds: 2));
                final client = http.Client();
                final url = Uri.parse("http://172.27.83.166:5000/videolist");
                final response = await client.get(url);
                if (response.statusCode != 0) {
                  setState(() {
                    videonames = jsonDecode(response.body)["namesofvideo"]
                        .cast<String>();
                    weightsofyolo = jsonDecode(response.body)["weightsofyolov5"]
                        .cast<String>();
                    weightsofCLR = jsonDecode(response.body)["weightsofCLR"]
                        .cast<String>();
                  });
                } else {
                  print(response.statusCode);
                }
                setState(() {
                  loadingFinishedsubmit = true;
                });
              },
            );
    });
  }
}
