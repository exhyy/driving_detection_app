import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:driving_detection_app/pages/upload_resource.dart';
import 'package:flutter/rendering.dart';
import 'package:driving_detection_app/services/VideoItem.dart';
class global
{
  static String video_path="";
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  PageController page = PageController();
  List <Widget> l =[];
  late List<SideMenuItem> sideMenuItems;
  _HomeState() {
    
    l.add(const VideoItem(downloadUrl: "http://127.0.0.1:5001/download/",videoname: "README.md"));

    sideMenuItems = [
      SideMenuItem(
        priority: 0,
        title: '提交任务',
        onTap: () => page.jumpToPage(0),
        icon: const Icon(Icons.add_task),
      ),
      SideMenuItem(
        priority: 1,
        title: '上传资源',
        onTap: () => page.jumpToPage(1),
        icon: const Icon(Icons.upload_file),
      ),
      SideMenuItem(
        priority: 2,
        title: '任务列表',
        onTap: () => page.jumpToPage(2),
        icon: const Icon(Icons.format_list_bulleted_rounded),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.lightBlue,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            title: const SizedBox(
              height: 6.0,
            ),
            footer: const Text('demo'),
            items: sideMenuItems,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              decoration: const BoxDecoration(),
              hoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue[100],
              selectedIconColor: Colors.grey[500],
              unselectedIconColor: Colors.grey[500],
              backgroundColor: Colors.grey[200],
              selectedTitleTextStyle: const TextStyle(color: Colors.black),
              unselectedTitleTextStyle: const TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: PageView(
                controller: page,
                children: [
                  Column(
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
                  const UploadResource(),
                  const Center(
                    child: Text(
                      '任务列表',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}