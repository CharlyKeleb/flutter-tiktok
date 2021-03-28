import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tiktok/view_model/post/create_post_view_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CreatePost extends StatefulWidget {
  final File vid;

  const CreatePost({Key key, this.vid}) : super(key: key);
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget?.vid);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(0.5);
    controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    PostsViewModel viewModel = Provider.of<PostsViewModel>(context);
    return ModalProgressHUD(
      inAsyncCall: viewModel.loading,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        key: viewModel.scaffoldKey,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              viewModel.resetPost();
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_backspace),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  viewModel.uploadPosts();
                  viewModel.resetPost();
                  Navigator.pop(context);
                  print('Uploaded successfully!!');
                },
                child: Text(
                  'Upload',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width,
                  child: VideoPlayer(controller),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Song Name'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextFormField(
                  initialValue: viewModel.description,
                  decoration: InputDecoration(
                    hintText: 'Eg. Eminem ft Lil Wayne - No Love',
                    focusedBorder: UnderlineInputBorder(),
                  ),
                  maxLines: null,
                  onChanged: (val) => viewModel.setMusicName(val),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Caption'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextFormField(
                  initialValue: viewModel.description,
                  decoration: InputDecoration(
                    hintText: 'Eg. Awesome Video!!',
                    focusedBorder: UnderlineInputBorder(),
                  ),
                  maxLines: null,
                  onChanged: (val) => viewModel.setDescription(val),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
