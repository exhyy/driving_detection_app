import 'package:driving_detection_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:driving_detection_app/pages/upload_resource.dart';
import 'package:flutter/rendering.dart';


class VideoItem extends StatefulWidget {
  final String videoname;
  final String downloadUrl;
  const VideoItem({Key? key, required this.videoname, required this.downloadUrl}) : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItem();
}

class _VideoItem extends State<VideoItem> {
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: ()
      {
        setState(() {
          global.video_path = widget.videoname;
        });
      },
      child: Padding(
      padding:const EdgeInsets.symmetric(horizontal: 0.0),
      child: Image.network(widget.downloadUrl+widget.videoname,
      fit: BoxFit.fill,
      width: 200,
      height: 150,
      color: Colors.black,
      colorBlendMode:BlendMode.dst),
      ),
    );
  }
}