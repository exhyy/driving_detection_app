import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController page = PageController();
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
        actions: [
          IconButton(
            icon: Icon(Icons.sunny),
            onPressed: null,
          ),
        ],
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
            child: PageView(
              controller: page,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        '提交任务',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '提交任务',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                const Center(
                  child: Text(
                    '上传资源',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
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
          )
        ],
      ),
    );
  }
}
