import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:driving_detection_app/pages/upload_resource.dart';
import 'package:driving_detection_app/pages/submit_task.dart';
import 'package:driving_detection_app/pages/task_list.dart';
import 'package:driving_detection_app/pages/error.dart';
import 'package:driving_detection_app/services/notification.dart';

class global {
  static Map config = {
    "name": "",
    "video_name": "",
    "yolov5_model_name": "",
    "clrnet_model_name": "",
    "clrnet_backbone": "",
    "yolov5_period": 1,
    "clrnet_period": 1,
  };
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController page = PageController(
    initialPage: 0,
  );
  late List<SideMenuItem> sideMenuItems;
  _HomeState() {
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
              child: NotificationListener<PageJumpNotification>(
                onNotification: (notification) {
                  page.jumpToPage(notification.page);
                  return true;
                },
                child: PageView(
                  controller: page,
                  children: [
                    SubmitTask(),
                    UploadResource(),
                    TaskList(),
                    ErrorPage(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
