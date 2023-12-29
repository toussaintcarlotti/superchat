import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superchat/controller/profile_controller.dart';
import 'package:superchat/models/user_model.dart';
import 'package:superchat/pages/sign_in_page.dart';

import '../constants.dart';
import '../widgets/stream_listener.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final profileController = Get.put(ProfileContoller());

    final usernameFieldController = TextEditingController();
    final bioFieldController = TextEditingController();

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
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: profileController.getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final profile = snapshot.data as UserModel;
                      usernameFieldController.text = profile.name!;
                      bioFieldController.text = profile.bio ?? '';

                      return Padding(
                        padding: const EdgeInsets.all(Insets.medium),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Profil',
                                    style: theme.textTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: Insets.extraLarge),

                                  TextFormField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Nom d'utilisateur",
                                    ),
                                    controller: usernameFieldController,
                                  ),
                                  const SizedBox(height: Insets.extraLarge),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Bio",
                                    ),
                                    controller: bioFieldController,
                                    maxLines: null,
                                  ),
                                  const SizedBox(height: Insets.extraLarge),
                                  ElevatedButton(
                                    onPressed: () {
                                      profile.name = usernameFieldController.text;
                                      profile.bio = bioFieldController.text;
                                      profileController.updateProfile(profile);
                                    },
                                    child: const Text('Mettre à jour'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
