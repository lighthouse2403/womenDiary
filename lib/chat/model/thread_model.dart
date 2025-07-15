import 'package:cloud_firestore/cloud_firestore.dart';

class ThreadModel {
  String threadId = '';
  String deviceId = '';
  String? deviceName = '';
  String title = '';
  int? commentsCount = 0;

  Timestamp createTime = Timestamp(0, 0);
  Timestamp updateTime = Timestamp(0, 0);


  ThreadModel({
    required this.threadId,
    required this.deviceId,
    required this.deviceName,
    required this.title,
    required this.createTime,
    required this.updateTime,
  });

  ThreadModel.fromJson(Map<String, dynamic> json) {
    threadId = json['threadId'];
    deviceId = json['deviceId'];
    title = json['title'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    deviceName = json['deviceName'];
    commentsCount = json['commentsCount'];
  }

  void updateCommentCount() {
    commentsCount = (commentsCount ?? 0) + 1;
  }
}