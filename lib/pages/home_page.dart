import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:superchat/constants.dart';
import 'package:superchat/controller/discussion_controller.dart';
import 'package:superchat/pages/sign_in_page.dart';
import 'package:superchat/pages/users_page.dart';
import 'package:superchat/widgets/stream_listener.dart';

import '../widgets/users_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(DiscussionController());

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
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersPage()),
                );
              },
            ),
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
        body: UsersList(future: controller.getAllDiscussionsUsers()),
      ),
    );
  }
}
