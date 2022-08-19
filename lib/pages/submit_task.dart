import 'dart:convert';
import 'package:driving_detection_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:driving_detection_app/services/video_item.dart';
import 'package:driving_detection_app/services/loading.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:driving_detection_app/services/notification.dart';
import 'package:number_selector/number_selector.dart';

class SubmitTask extends StatefulWidget {
  const SubmitTask({
    Key? key,
  }) : super(key: key);

  @override
  State<SubmitTask> createState() => _SubmitTaskState();
}

class _SubmitTaskState extends State<SubmitTask> {
  var _titleTxt = TextEditingController();
  int _currentValueofyolo = 1;
  int _currentValueofCLR = 1;
  List<Widget> l_image = [];
  List<DropdownMenuItem<String>> l_yolo = [];
  List<DropdownMenuItem<String>> l_CLR = [];
  List<DropdownMenuItem<String>> l_backbone = [
    const DropdownMenuItem(
      child: Text('Resnet18'),
      value: '0',
    ),
    const DropdownMenuItem(
      child: Text('Resnet34'),
      value: '1',
    ),
    const DropdownMenuItem(
      child: Text('MobileNetV3 small'),
      value: '2',
    ),
    const DropdownMenuItem(
      child: Text('MobileNetV3 large'),
      value: '3',
    ),
  ];
  static List<String> videonames = [];
  static List<String> weightsofyolo = [];
  static List<String> weightsofCLR = [];
  static List<String> backbones = ['Resnet18', 'Resnet34', 'm3s', 'm3l'];
  bool loadingFinishedsubmit = false;
  int checkedIndex = -1;
  var _dropValue_yolo = null;
  var _dropValue_CLR = null;
  var _dropValue_backnone = null;
  @override
  Widget build(BuildContext context) {
    l_image = [];
    l_CLR = [];
    l_yolo = [];
    for (int i = 0; i < videonames.length; i++) {
      l_image.add(VideoItem(
          downloadUrl: "${Global.appConfig['server_url']}/download/",
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
          hint: const Text('请选择yolo的模型文件'),
          onChanged: (value) {
            setState(() {
              _dropValue_yolo = value.toString();
              Global.config["yolov5_model_name"] =
                  weightsofyolo[int.parse(value.toString())];
            });
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: DropdownButton(
              value: _dropValue_CLR,
              isExpanded: true,
              items: l_CLR,
              hint: const Text('请选择CLR的模型文件'),
              onChanged: (value) {
                setState(() {
                  _dropValue_CLR = value.toString();
                  Global.config["clrnet_model_name"] =
                      weightsofCLR[int.parse(value.toString())];
                });
              },
            ),
          ),
          Expanded(
            child: DropdownButton(
              value: _dropValue_backnone,
              isExpanded: true,
              items: l_backbone,
              hint: const Text('请选择CLR模型对应的backbone'),
              onChanged: (value) {
                setState(() {
                  _dropValue_backnone = value.toString();
                  Global.config["clrnet_backbone"] =
                      backbones[int.parse(value.toString())];
                });
              },
            ),
          ),
        ],
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
      SizedBox(
        width: double.infinity,
        child: Wrap(
          textDirection: TextDirection.ltr,
          alignment: WrapAlignment.spaceEvenly,
          // spacing: 100, //主轴上子控件的间距2
          runSpacing: 5, //交叉轴上子控件之间的间距
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // SizedBox(width: MediaQuery.of(context).size.width*1/6,),
            Column(
              children: [
                Text('For Yolo', style: Theme.of(context).textTheme.headline6),
                NumberSelector(
                  current: _currentValueofyolo,
                  min: 1,
                  max: 5,
                  showMinMax: false,
                  showSuffix: false,
                  hasDividers: false,
                  hasCenteredText: true,
                  incrementIcon: Icons.add,
                  decrementIcon: Icons.remove,
                  onUpdate: (number) {
                    setState(() {
                      _currentValueofyolo = number;
                      Global.config['yolov5_period'] = _currentValueofyolo;
                    });
                  },
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     IconButton(
                //       icon: const Icon(Icons.remove),
                //       onPressed: () => setState(() {
                //         final newValue = _currentValueofyolo - 1;
                //         _currentValueofyolo = newValue.clamp(1, 5);
                //         Global.config["clrnet_period"] = _currentValueofyolo;
                //       }),
                //     ),
                //     Text('Current int value: $_currentValueofyolo'),
                //     IconButton(
                //       icon: const Icon(Icons.add),
                //       onPressed: () => setState(() {
                //         final newValue = _currentValueofyolo + 1;
                //         _currentValueofyolo = newValue.clamp(1, 5);
                //         Global.config["clrnet_period"] = _currentValueofyolo;
                //       }),
                //     ),
                //   ],
                // ),
              ],
            ),
            // SizedBox(width: MediaQuery.of(context).size.width*1/3,),
            Column(
              children: [
                Text('For CLR', style: Theme.of(context).textTheme.headline6),
                NumberSelector(
                  current: _currentValueofCLR,
                  min: 1,
                  max: 5,
                  showMinMax: false,
                  showSuffix: false,
                  hasDividers: false,
                  hasCenteredText: true,
                  incrementIcon: Icons.add,
                  decrementIcon: Icons.remove,
                  onUpdate: (number) {
                    setState(() {
                      _currentValueofCLR = number;
                      Global.config['clrnet_period'] = _currentValueofCLR;
                    });
                  },
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     IconButton(
                //       icon: const Icon(Icons.remove),
                //       onPressed: () => setState(() {
                //         final newValue = _currentValueofCLR - 1;
                //         _currentValueofCLR = newValue.clamp(1, 5);
                //         Global.config["clrnet_period"] = _currentValueofCLR;
                //       }),
                //     ),
                //     Text('Current int value: $_currentValueofCLR'),
                //     IconButton(
                //       icon: const Icon(Icons.add),
                //       onPressed: () => setState(() {
                //         final newValue = _currentValueofCLR + 1;
                //         _currentValueofCLR = newValue.clamp(1, 5);
                //         Global.config["clrnet_period"] = _currentValueofCLR;
                //       }),
                //     ),
                //   ],
                // ),
              ],
            ),
          ],
        ),
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
                children: [
                  Column(
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
                      const Divider(),
                      ListTile(
                        title: TextField(
                          controller: _titleTxt,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: '任务名称',
                            hintText: '示例:MyTask',
                            helperText: '请输入任务名称',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        trailing: ElevatedButton(
                          child: const Text("提交"),
                          onPressed: () async {
                            print(Global.config);
                            setState(() {
                              Global.config['name'] = _titleTxt.text;
                            });
                            BaseOptions options = BaseOptions(
                              method: "post",
                              headers: {
                                "Content-Type": "application/json",
                              },
                            );
                            Dio dio = Dio(options);
                            Response res = await dio.post(
                                '${Global.appConfig['server_url']}/submit',
                                data: Global.config);
                          },
                        ),
                      ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 3 / 7,
                      // )
                    ],
                  ),
                ],
              ),
            )
          : Loading(
              onLoading: () async {
                try {
                  final client = http.Client();
                  final url =
                      Uri.parse("${Global.appConfig['server_url']}/videolist");
                  final response = await client.get(url);
                  if (response.statusCode != 0) {
                    setState(() {
                      videonames = jsonDecode(response.body)["namesofvideo"]
                          .cast<String>();
                      // global.config['video_name'] = videonames[0];
                      weightsofyolo =
                          jsonDecode(response.body)["weightsofyolov5"]
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
                } catch (e) {
                  if(!e.toString().contains('setState()')){
                    PageJumpNotification(page: 3).dispatch(context);
                  }
                }
              },
            );
    });
  }
}
