import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tiktok/models/post.dart';
import 'package:flutter_tiktok/models/user.dart';
import 'package:flutter_tiktok/services/services.dart';
import 'package:flutter_tiktok/utils/firebase/firebase.dart';
import 'package:uuid/uuid.dart';

class PostService extends Service {
  UserModel user;
  String postId = Uuid().v4();

  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  uploadProfilePicture(File image, User user) async {
    String link = await uploadImage(profilePic, image);
    var ref = usersRef.doc(user.uid);
    ref.update({
      "photoUrl": link ?? 'https://images.app.goo.gl/NGh74PqviFBNwFV4A',
    });
  }

  uploadPost(File image, File previewImage, String description,
      String musicName) async {
    String link = await uploadImage(posts, image);
    String preview = await uploadImage(prevImage, previewImage);
    DocumentSnapshot doc =
        await usersRef.doc(firebaseAuth.currentUser.uid).get();
    user = UserModel.fromJson(doc.data());
    var ref = postRef.doc();
    ref.set({
      "id": ref.id,
      "postId": ref.id,
      "username": user.username,
      "ownerId": firebaseAuth.currentUser.uid,
      "mediaUrl": link,
      "musicName": musicName,
      "description": description ?? "",
      "previewImage": preview,
      "timestamp": Timestamp.now(),
    }).catchError((e) {
      print(e);
    });
  }

  addComments(PostModel video, String comment,
      Timestamp timestamp) async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    user = UserModel.fromJson(doc.data());
    commentRef.doc(video.postId).collection("comments").add({
      "username": user.username,
      "comment": comment,
      "timestamp": timestamp,
      "userDp": user.photoUrl,
      "userId": user.id,
    });
  }

  shareVideo(String videoUrl, String postId, String id) async {
    var request = await HttpClient().getUrl(Uri.parse(videoUrl));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file('FlutterTikTok', 'Video.mp4', bytes, 'video/mp4');
    shareRef.add({
      'userId': currentUserId(),
      'postId': postId,
      'dateCreated': Timestamp.now(),
    });
  }
}
