import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:coach_app/features/auth/presentation/providers/auth_state.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Listen for changes in the auth state
    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (state.error != null) {
        context.showSnackbar(state.error!);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.login)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                style: const TextStyle(color: AppColors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.pleaseEnterYourUsername;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: AppColors.black),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.pleaseEnterYourPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          ref.read(authNotifierProvider.notifier).login(
                                _usernameController.text,
                                _passwordController.text,
                              );
                        }
                      },
                child: authState.isLoading
                    ? const CircularProgressIndicator()
                    : Text(context.l10n.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
