import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/models/post.dart';
import 'package:flutter_tiktok/services/post_service.dart';
import 'package:flutter_tiktok/services/user_service.dart';
// import 'package:flutter_tiktok/view/screens/create_post.dart';
// import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_compress/video_compress.dart';

class PostsViewModel extends ChangeNotifier {
  BuildContext context;
  //Services
  UserService userService = UserService();
  PostService postService = PostService();

  // FlutterVideoCompress flutterVideoCompress = FlutterVideoCompress();

  //Keys
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Variables
  bool loading = false;
  String username;
  File mediaUrl;
  final picker = ImagePicker();
  String musicName;
  String bio;
  String description;
  String imgLink;
  String prevLink;
  File previewImage;
  bool edit = false;
  String id;

  //Setters
  setEdit(bool val) {
    edit = val;
    notifyListeners();
  }

  setPost(PostModel post) {
    if (post != null) {
      description = post.description;
      imgLink = post.mediaUrl;
      musicName = post.musicName;
      prevLink = post.previewImage;
      edit = true;
      edit = false;
      notifyListeners();
    } else {
      edit = false;
      notifyListeners();
    }
  }

  setUsername(String val) {
    print('SetName $val');
    username = val;
    notifyListeners();
  }

  setDescription(String val) {
    print('SetDescription $val');
    description = val;
    notifyListeners();
  }

  setBio(String val) {
    print('SetBio $val');
    bio = val;
    notifyListeners();
  }

  setMusicName(String val) {
    print('SetMusicName $val');
    musicName = val;
    notifyListeners();
  }

  //functions

  pickVideo({bool camera = false}) async {
    loading = true;
    notifyListeners();
    try {
      PickedFile pickedFile;
      pickedFile = await ImagePicker().getVideo(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );
      mediaUrl = File(pickedFile.path);
      // previewImage =
      //     await flutterVideoCompress.getThumbnailWithFile(pickedFile.path);
      // previewImage = await VideoThumbnail.thumbnailFile(
      //     video: pickedFile.path,
      //     imageFormat: ImageFormat.JPEG,
      //     maxWidth: 128,
      //     quality: 25);
      previewImage = await VideoCompress.getFileThumbnail(
        pickedFile.path,
      );
      loading = false;

      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  uploadPosts() async {
    try {
      loading = true;
      notifyListeners();
      await postService.uploadPost(
          mediaUrl, previewImage, description, musicName);
      loading = false;
      resetPost();
      notifyListeners();
    } catch (e) {
      print(e);
      loading = false;
      resetPost();
      showInSnackBar('Uploaded successfully!');
      notifyListeners();
    }
  }

  resetPost() {
    mediaUrl = null;
    description = null;
    musicName = null;
    previewImage = null;
    edit = null;
    notifyListeners();
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
