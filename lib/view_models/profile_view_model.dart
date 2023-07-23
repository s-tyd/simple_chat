import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/components/edit_page.dart';
import 'package:simple/model/user_data/user_data.dart';
import 'package:simple/repository/user_data_repository.dart';

final profileViewModelProvider = StateProvider.autoDispose<ProfileViewModel>(
  ProfileViewModel.new,
);

class ProfileViewModel {
  ProfileViewModel(this.ref);

  final Ref ref;

  UserData get user => ref.read(userDataProvider);

  void updateName(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => EditPage(
          title: 'Edit Profile Name',
          initialValue: user.name,
          updateCallback: (value) => _update('name', value),
        ),
      ),
    );
  }

  void updateId(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => EditPage(
          title: 'Edit Profile ID',
          initialValue: user.id,
          updateCallback: (value) => _update('id', value),
        ),
      ),
    );
  }

  Future<void> _update(String key, String name) async {
    final updates = {key: name};
    await ref.read(userDataProvider.notifier).updateUser(updates);
  }
}
