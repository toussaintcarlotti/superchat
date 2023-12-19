import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final _db = FirebaseFirestore.instance;

  createUsers(user) async {
    await _db.collection('users').add(user);
  }

  Future<List<UserModel>> getUsers() async {
    final snapshot = await _db.collection('users').get();
    final usersData = snapshot.docs.map((e) {
      return UserModel.fromSnapshot(e);
    }).toList();
    return usersData;
  }
}