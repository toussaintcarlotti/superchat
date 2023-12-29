import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:superchat/models/user_model.dart';

class ProfileContoller extends GetxController {
  static ProfileContoller get to => Get.find();

  Stream<UserModel> getProfile() {
    var currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser!.uid);
    var profile = FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: currentUser!.uid)
        .snapshots()
        .map((event) => event.docs.map((e) {
              return UserModel.fromSnapshot(e);
            }).first);

    return profile;
  }

  Future<void> updateProfile(UserModel user) async {
    print(user.id);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update(user.toJson())
        .then((value) => print("Profile Updated"))
        .catchError((error) => print(error.toString()));
  }
}
