import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/models/post.dart';
import 'package:flutter_tiktok/view/widgets/cached_image.dart';


class PostTile extends StatefulWidget {
  final PostModel videos;

  PostTile({this.videos});

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 200,
        width: 150,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          elevation: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(3.0),
            ),
            child: cachedNetworkImage(widget.videos.previewImage),
          ),
        ),
      ),
    );
  }
}
