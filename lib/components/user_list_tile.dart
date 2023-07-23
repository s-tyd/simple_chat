import 'package:flutter/material.dart';
import 'package:simple/model/user_data/user_data.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({required this.user, super.key});

  final UserData user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.icon.isEmpty ? null : NetworkImage(user.icon),
        child: user.icon.isEmpty ? Text(user.name[0]) : null,
      ),
      title: Text(user.name),
      subtitle: Text(user.id),
    );
  }
}
