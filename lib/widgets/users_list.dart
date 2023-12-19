import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:superchat/models/user_model.dart';

import '../constants.dart';
import '../pages/chat_page.dart';

class UsersList<T> extends StatelessWidget {
  final Future<List<UserModel>> future;

  const UsersList({
    super.key,
    required this.future,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<UserModel> users = snapshot.data as List<UserModel>;
            return RefreshIndicator(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  padding: const EdgeInsets.all(Insets.medium),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(Insets.small),
                      margin: const EdgeInsets.only(bottom: Insets.small),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                                leading: Icon(Icons.person),
                                title: Text(users[index].name),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatPage(user: users[index])),
                                  );
                                }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  future;
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
