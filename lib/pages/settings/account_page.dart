import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/components/wide_rounded_button.dart';
import 'package:simple/providers/firebase.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final auth = ref.watch(firebaseAuthProvider);
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: user == null || user.isAnonymous
            ? _buildLoginForm(
                context,
                emailController,
                passwordController,
                auth,
              )
            : Text('Logged in as ${user.email}'),
      ),
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    FirebaseAuth auth,
  ) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        WideRoundedButton(
          title: 'Link with Email',
          onPressed: () =>
              _linkWithEmail(emailController, passwordController, auth),
        ),
        WideRoundedButton(
          title: 'SignOut',
          color: Colors.black38,
          onPressed: () => _signOut(context, auth),
        ),
      ],
    );
  }

  Future<void> _linkWithEmail(
    TextEditingController emailController,
    TextEditingController passwordController,
    FirebaseAuth auth,
  ) async {
    final user = auth.currentUser;
    if (user == null || !user.isAnonymous) {
      return;
    }

    final credential = EmailAuthProvider.credential(
      email: emailController.text,
      password: passwordController.text,
    );

    try {
      await user.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // todo: Handle error
    }
  }

  Future<void> _signOut(BuildContext context, FirebaseAuth auth) async {
    final user = auth.currentUser;
    final messenger = ScaffoldMessenger.of(context);
    if (user == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No one has signed in.')),
      );
      return;
    }

    if (user.isAnonymous) {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Account'),
            content:
                const Text('This account is not linked and will be deleted.\n'
                    'Are you sure you want to proceed?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );
      if (shouldDelete == true) {
        await user.delete();
        messenger.showSnackBar(
          const SnackBar(content: Text('User account deleted')),
        );
      }

      return;
    }

    await auth.signOut();
  }
}
