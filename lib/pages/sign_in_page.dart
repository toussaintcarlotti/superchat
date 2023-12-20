
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superchat/controller/auth_controller.dart';
import 'package:superchat/pages/sign_up_page.dart';
import '../constants.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                        'Connectez-vous à votre compte Superchat',
                        style: theme.textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Insets.extraLarge),
                      const Text(
                        'Email',
                        textAlign: TextAlign.center,
                      ),
                      RepaintBoundary(
                        child: TextFormField(
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
                      ),
                      const SizedBox(height: Insets.medium),
                      const Text(
                        'Mot de passe',
                        textAlign: TextAlign.center,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return RepaintBoundary(
                            child: TextFormField(
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
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: Insets.medium),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => controller.signIn(context, _formKey, _emailFieldController.text.trim(), _passwordFieldController.text.trim()),
                          child: const Text('Se connecter'),
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      const Text(
                        'Vous n\'avez pas de compte ?',
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const SignUpPage())),
                        child: const Text('S\'inscrire'),
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
