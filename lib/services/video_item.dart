import 'package:driving_detection_app/pages/home.dart';
import 'package:flutter/material.dart';

class VideoItemNotification extends Notification {
  final int checkedIndex;
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
  Color textcolor = const Color.fromARGB(0, 255, 255, 255);
  //    

  @override
  Widget build(BuildContext context) {

    groupValue = widget.checked
          ? 1
          : 0;
    textcolor = widget.checked
          ?const Color.fromARGB(120, 122, 118, 118)
          :const Color.fromARGB(0, 255, 255, 255);
    return TextButton(
      onPressed: () 
      {
        setState(() {
          Global.config["video_name"] = widget.videoname;
        });
        VideoItemNotification(checkedIndex: widget.index).dispatch(context);
      },
      //=> VideoItemNotification(checkedIndex: widget.index).dispatch(context),
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