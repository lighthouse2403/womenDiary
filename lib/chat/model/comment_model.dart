import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String commentId = '';
  String threadId = '';
  String deviceId = '';
  String? deviceName = '';
  String content = '';
  Timestamp createTime = Timestamp(0, 0);
  Timestamp updateTime = Timestamp(0, 0);


  CommentModel({
    required this.threadId,
    required this.commentId,
    required this.deviceId,
    required this.deviceName,
    required this.content,
    required this.createTime,
    required this.updateTime,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    threadId = json['threadId'];
    deviceId = json['deviceId'];
    commentId = json['commentId'];
    content = json['content'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    deviceName = json['deviceName'];
  }
}