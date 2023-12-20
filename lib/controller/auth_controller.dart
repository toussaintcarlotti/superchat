import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superchat/models/user_model.dart';

import '../pages/home_page.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  Future<void> signIn(context, _formKey, email, password) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_formKey.currentState?.validate() ?? false) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (credential.user != null) {
          navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()));
        }
      } on FirebaseAuthException catch (e, stackTrace) {
        final String errorMessage;

        if (e.code == 'user-not-found') {
          errorMessage = 'Aucun utilisateur trouvé pour cet email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Mot de passe incorrect.';
        } else {
          errorMessage = 'Une erreur s\'est produite';
        }

        log(
          'Error while signing in: ${e.code}',
          error: e,
          stackTrace: stackTrace,
          name: 'SignInPage',
        );
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  Future<void> signUp(context, _formKey, username, email, password) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_formKey.currentState?.validate() ?? false) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (credential.user != null) {
          final String displayName = username;
          final user = UserModel(id: credential.user!.uid, name: displayName,);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(credential.user!.uid)
              .set(user.toJson());

          navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()));
        }
      } on FirebaseAuthException catch (e, stackTrace) {
        final String errorMessage;

        if (e.code == 'weak-password') {
          errorMessage = 'Le mot de passe est trop faible.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'Cet email est déjà associé à un compte existant.';
        } else {
          errorMessage = 'Une erreur est survenue.';
        }

        log(
          'Error while signing in: ${e.code}',
          error: e,
          stackTrace: stackTrace,
          name: 'SignInPage',
        );
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }
}
