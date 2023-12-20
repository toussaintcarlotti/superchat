import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:superchat/models/message_model.dart';

import '../models/user_model.dart';

class DiscussionController extends GetxController {
  static DiscussionController get to => Get.find();

  Future<List<UserModel>> getAllDiscussionsUsers() async {
    var user = FirebaseAuth.instance.currentUser;
    // get all messages if current user is sender or receiver
    var messages = await FirebaseFirestore.instance
        .collection('messages')
        .where(Filter.or(Filter('from', isEqualTo: user!.uid),
            Filter('to', isEqualTo: user.uid)))
        .get();

    var userIdList = messages.docs.map((e) {
      var message = MessageModel.fromSnapshot(e);
      if (message.from == user.uid) {
        return message.to;
      } else {
        return message.from;
      }
    }).toList();

    // remove duplicates
    userIdList = userIdList.toSet().toList();

    var users = await FirebaseFirestore.instance
        .collection('users')
        .where('id', whereIn: userIdList)
        .get();

    final usersData = users.docs.map((e) {
      return UserModel.fromSnapshot(e);
    }).toList();
    return usersData;
  }

  Stream<List<MessageModel>> getDiscussion(UserModel user) {
    var currentUser = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('messages')
        .where(Filter.or(
            Filter.and(Filter('from', isEqualTo: currentUser!.uid),
                Filter('to', isEqualTo: user.id)),
            Filter.and(Filter('from', isEqualTo: user.id),
                Filter('to', isEqualTo: currentUser.uid))))
        .snapshots()
        .map((event) => event.docs.map((e) {
              var message = MessageModel.fromSnapshot(e);
              if (message.from != currentUser.uid) {
                message.authorName = user.name;
              }
              return message;
            }).toList());
  }
}
