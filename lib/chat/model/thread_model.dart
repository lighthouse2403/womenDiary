import 'package:cloud_firestore/cloud_firestore.dart';

class ThreadModel {
  String threadId = '';
  String uuid = '';
  String? deviceName = '';
  String content = '';
  String os = '';
  int commentsCount = 0;

  Timestamp createTime = Timestamp(0, 0);
  Timestamp updateTime = Timestamp(0, 0);

  ThreadModel({
    required this.threadId,
    required this.uuid,
    required this.deviceName,
    required this.content,
    required this.createTime,
    required this.updateTime,
    required this.os,
  });

  ThreadModel.fromJson(Map<String, dynamic> json) {
    threadId = json['threadId'];
    uuid = json['uuid'];
    content = json['content'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    deviceName = json['deviceName'];
    commentsCount = json['commentsCount'];
    os = json['os'];
  }

  void updateCommentCount() {
    commentsCount = commentsCount + 1;
  }
}