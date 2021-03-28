import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  final videURL;
  final double height;
  final double width;

  const VideoItem({this.videURL, this.height, this.width});
  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.network(widget.videURL)
      ..initialize().then((value) {
        controller.play();
        controller.setVolume(1);
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(6.5),
          bottomRight: Radius.circular(6.5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: VideoPlayer(controller),
      ),
    );
  }
}
