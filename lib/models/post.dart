import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String postId;
  String ownerId;
  String username;
  String description;
  String mediaUrl;
  String musicName;
  String previewImage;

  Timestamp timestamp;

  PostModel({
    this.id,
    this.postId,
    this.ownerId,
    this.description,
    this.mediaUrl,
    this.musicName,
    this.username,
    this.timestamp,
    this.previewImage,
  });
  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    ownerId = json['ownerId'];
    username = json['username'];
    description = json['description'];
    mediaUrl = json['mediaUrl'];
    musicName = json['musicName'];
    timestamp = json['timestamp'];
    previewImage = json['previewImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['postId'] = this.postId;
    data['ownerId'] = this.ownerId;
    data['musicName'] = this.musicName;
    data['description'] = this.description;
    data['mediaUrl'] = this.mediaUrl;
    data['timestamp'] = this.timestamp;
    data['username'] = this.username;
    data['previewImage'] = this.previewImage;
    return data;
  }
}
