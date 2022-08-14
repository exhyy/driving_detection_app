import 'package:driving_detection_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:driving_detection_app/pages/upload_resource.dart';
import 'package:flutter/rendering.dart';

class VideoItemNotification extends Notification {
  final checkedIndex;
  VideoItemNotification({required this.checkedIndex});
}

class VideoItem extends StatefulWidget {
  final String videoname;
  final String downloadUrl;
  final int index;
  final bool checked;
  const VideoItem({Key? key, required this.videoname, required this.downloadUrl,required this.index, required this.checked}) : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItem();
}

class _VideoItem extends State<VideoItem> {
  int groupValue = 0;
  Color textcolor = Color.fromARGB(0, 255, 255, 255);
  //    

  @override
  Widget build(BuildContext context) {

    groupValue = widget.checked
          ? 1
          : 0;
    textcolor = widget.checked
          ?Color.fromARGB(120, 255, 255, 255)
          :Color.fromARGB(0, 255, 255, 255);
    return TextButton(
      onPressed: () => VideoItemNotification(checkedIndex: widget.index).dispatch(context),
      // onPressed: ()
      // {

      //   setState(() {
      //     global.video_path = widget.videoname;
      //     // mycolor = Colors.grey;
      //     groupValue= groupValue==1
      //     ? 0
      //     : 1;
      //     textcolor = groupValue==1
      //     ?Color.fromARGB(120, 255, 255, 255)
      //     :Color.fromARGB(0, 255, 255, 255);
      //   });
      // },
      // style: ButtonStyle.,
      child: Container(
        foregroundDecoration: BoxDecoration(
        color: textcolor,
      ),
        // color: mycolor,
        child: Column(
          children: 
            [Padding(
            padding:const EdgeInsets.symmetric(horizontal: 0.0),
            child: Image.network(widget.downloadUrl+widget.videoname,
            fit: BoxFit.fill,
            width: 200,
            height: 150,
            // color: mycolor,
            colorBlendMode:BlendMode.color   ),
            ),
             Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Radio(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ///此单选框绑定的值 必选参数
                  value: 1,
                  ///当前组中这选定的值  必选参数
                  groupValue: groupValue,
                  ///点击状态改变时的回调 必选参数
                  onChanged: (value) => VideoItemNotification(checkedIndex: widget.index).dispatch(context),
            ),
            Text(widget.videoname,
            ),
               ],
             ),
          ],
        ),
      ),
    );
  }
}