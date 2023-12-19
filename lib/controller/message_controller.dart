import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:superchat/models/user_model.dart';

class MessageController extends GetxController {
  static MessageController get to => Get.find();

  Future<void> sendMessage(UserModel to, String content) async {
    var user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('messages').add({
      'from': user!.uid,
      'to': to.id,
      'content': content,
      'timestamp': Timestamp.now().toDate()
    }).then((value) => print("Message Added"))
    .catchError((error) => print("Failed to add message: $error"));
  }
}