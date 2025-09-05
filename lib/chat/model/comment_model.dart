import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String commentId = '';
  String threadId = '';
  String uuid = '';
  String? deviceName = '';
  String content = '';
  String os = '';

  Timestamp createTime = Timestamp(0, 0);
  Timestamp updateTime = Timestamp(0, 0);

  CommentModel({
    required this.threadId,
    required this.commentId,
    required this.uuid,
    required this.deviceName,
    required this.content,
    required this.createTime,
    required this.updateTime,
    required this.os,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    threadId    = json['threadId'];
    uuid        = json['uuid'];
    commentId   = json['commentId'];
    content     = json['content'];
    createTime  = json['createTime'];
    updateTime  = json['updateTime'];
    deviceName  = json['deviceName'];
    os          = json['os'];
  }
}