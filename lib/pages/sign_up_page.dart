import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superchat/pages/sign_in_page.dart';

import '../constants.dart';
import '../controller/auth_controller.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _usernameFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppTitle),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Insets.medium),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Créez votre compte Superchat',
                        style: theme.textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Insets.extraLarge),
                      const Text(
                        'Nom d\'utilisateur',
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        controller: _usernameFieldController,
                        autofillHints: const [AutofillHints.username],
                        decoration: const InputDecoration(
                          hintText: 'Nom d\'utilisateur',
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            value != null && value.isNotEmpty
                                ? null
                                : 'Nom d\'utilisateur invalide',
                      ),
                      const SizedBox(height: Insets.extraLarge),
                      const Text(
                        'Email',
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        controller: _emailFieldController,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            value != null && EmailValidator.validate(value)
                                ? null
                                : 'Email invalide',
                      ),
                      const SizedBox(height: Insets.medium),
                      const Text(
                        'Mot de passe',
                        textAlign: TextAlign.center,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return TextFormField(
                            controller: _passwordFieldController,
                            autofillHints: const [AutofillHints.password],
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              hintText: 'Mot de passe',
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                    () => _showPassword = !_showPassword),
                                icon: _showPassword
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                          );
                        },
                      ),
                      const SizedBox(height: Insets.medium),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => controller.signUp(
                              context,
                              _formKey,
                              _usernameFieldController.text.trim(),
                              _emailFieldController.text.trim(),
                              _passwordFieldController.text.trim()),
                          child: const Text('S\'inscrire'),
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      const Text(
                        'Vous avez déjà un compte ?',
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const SignInPage())),
                        child: const Text('Se connecter'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
