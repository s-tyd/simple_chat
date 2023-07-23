import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/components/interactive_setting_tile.dart';
import 'package:simple/repository/user_data_repository.dart';
import 'package:simple/view_models/profile_view_model.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    final viewModel = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          InteractiveSettingTile(
            title: 'ID',
            currentValue: user.id,
            onTap: () => viewModel.updateId(context),
          ),
          InteractiveSettingTile(
            title: 'Name',
            currentValue: user.name,
            onTap: () => viewModel.updateName(context),
          ),
          InteractiveSettingTile(
            title: 'UID',
            currentValue: user.uid,
            enabled: false,
          ),
        ],
      ),
    );
  }
}
