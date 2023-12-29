import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/instance_manager.dart';
import 'package:superchat/controller/discussion_controller.dart';
import 'package:superchat/models/message_model.dart';
import 'package:superchat/models/user_model.dart';
import 'package:superchat/pages/sign_in_page.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../constants.dart';
import '../controller/message_controller.dart';
import '../widgets/stream_listener.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final discussionController = Get.put(DiscussionController());
    final messageController = Get.put(MessageController());

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
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: discussionController.getDiscussion(user),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final messages = snapshot.data as List<MessageModel>;
                      final currentUser = FirebaseAuth.instance.currentUser;

                      messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                      return Chat(
                        messages: messages.map((e) => e.toChatUiMessage()).toList(),
                        onSendPressed: (message) {
                          messageController.sendMessage(user, message.text);
                        },
                        theme: DefaultChatTheme(
                          primaryColor: theme.colorScheme.primary,
                          secondaryColor: Colors.black87,
                          userNameTextStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                          receivedMessageBodyTextStyle: const TextStyle(
                            color: Colors.white,
                            // bold
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        showUserNames: true,
                        user: types.User(
                          id: currentUser!.uid,
                          firstName: currentUser.displayName,
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
