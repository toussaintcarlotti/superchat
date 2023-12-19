import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:superchat/models/user_model.dart';
import 'package:superchat/pages/sign_in_page.dart';
import 'package:superchat/widgets/users_list.dart';

import '../constants.dart';
import '../controller/user_controller.dart';
import '../widgets/stream_listener.dart';
import 'chat_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final theme = Theme.of(context);
    return StreamListener<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        listener: (user) {
          if (user == null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SignInPage()),
                (route) => false);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text(kAppTitle),
              backgroundColor: theme.colorScheme.primary,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
            /*body: const Center(
          child: Text('Welcome to SuperChat!'),
        ),*/
            body: UsersList(future: controller.getUsers())));
  }
}
