import 'package:women_diary/chat/model/comment_model.dart';
import 'package:women_diary/chat/model/thread_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:women_diary/common/firebase/firebase_user.dart';

class FirebaseChat {
  FirebaseChat._();

  static final instance = FirebaseChat._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int threadLimit = 0;
  int commentLimit = 0;

  Future<List<ThreadModel>> loadThread() async {
    threadLimit += 50;

    QuerySnapshot chatSnapshot = await firestore.collection('chat').limit(threadLimit).orderBy('updateTime', descending: true).get();
    final allData = chatSnapshot.docs.map((doc) => ThreadModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

    return allData;
  }

  Future<ThreadModel> loadThreadDetail(String threadId) async {
    final doc = await firestore.collection("chat").doc(threadId);
    final docSnap = await doc.get();
    final threadDetail = docSnap.data();

    ThreadModel newThread = ThreadModel.fromJson(threadDetail as Map<String, dynamic>);
    return newThread;
  }

  Future<void> addNewThread(String title) async {
    CollectionReference chat = firestore.collection('chat');
    List<String> deviceInfo = await FirebaseUser.instance.getDeviceDetails();

    await chat.add({
        'createTime': FieldValue.serverTimestamp(),
        'threadId': FieldValue.serverTimestamp().toString(),
        'title': title,
        'updateTime': FieldValue.serverTimestamp(),
        'deviceId': deviceInfo[2],
        'deviceName': deviceInfo[1],
        'os': deviceInfo.firstOrNull,
        'commentsCount': 0,
    }).then((value) async {
      await editThreadId(value.id);
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> editThread(String threadId, String newTitle) async {
    CollectionReference chat = firestore.collection('chat');
    List<String> deviceInfo = await FirebaseUser.instance.getDeviceDetails();
    var docSnapshot = await chat.where('author', isEqualTo: deviceInfo[1]).get();
  }

  Future<void> editThreadId(String threadId) async {
    CollectionReference chat = firestore.collection('chat');
    await chat.doc(threadId).update({
      'threadId' : threadId
    });
  }

  Future<void> updateNumberOfComment(String threadId, int commentsCount) async {
    CollectionReference chat = firestore.collection('chat');
    await chat.doc(threadId).update({
      'commentsCount' : commentsCount
    });
  }

  Future<List<CommentModel>> loadComment(String threadId) async {
    commentLimit += 100;

    QuerySnapshot chatSnapshot = await firestore.collection('chat').doc(threadId).collection('comments').limit(commentLimit).orderBy('updateTime', descending: true).get();
    // Get data from docs and convert map to List
    final allData = chatSnapshot.docs.map((doc) => CommentModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    return allData;
  }

  Future<void> addNewComment(ThreadModel thread, String content) async {
    CollectionReference chat = firestore.collection('chat');
    List<String> deviceInfo = await FirebaseUser.instance.getDeviceDetails();
    var comment = await chat.doc(thread.threadId).collection('comments');
    await comment.add({
      'commentId': FieldValue.serverTimestamp().toString(),
      'threadId': thread.threadId,
      'os': deviceInfo.firstOrNull,
      'deviceName': deviceInfo[1],
      'deviceId': deviceInfo[2],
      'content': content,
      'updateTime': FieldValue.serverTimestamp(),
      'createTime': FieldValue.serverTimestamp()
    }).then((value) async {
      print('comment count: ${thread.commentsCount}');
      await updateComment(thread.threadId, value.id, content);
      await updateNumberOfComment(thread.threadId, (thread.commentsCount ?? 0) + 1);
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateComment(String threadId, String commentId, String newComment) async {
    var comment = firestore.collection('chat').doc(threadId).collection('comments').doc(commentId);
    comment.update({
      'updateTime': FieldValue.serverTimestamp(),
      'content': newComment,
      'commentId': commentId
    }).then((_) => print('Success')).catchError((error) => print('Failed: $error'));
  }
}