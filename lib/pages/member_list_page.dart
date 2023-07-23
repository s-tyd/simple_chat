import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple/model/room/room.dart';
import 'package:simple/model/user_data/user_data.dart';

class MemberListPage extends StatelessWidget {
  const MemberListPage({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members of ${room.name}'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, whereIn: room.members)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final _userData = users[index].data();
              if (_userData == null) {
                return const Text('No user data');
              }
              final user = UserData.fromJson(_userData as Map<String, dynamic>);

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      user.icon.isEmpty ? null : NetworkImage(user.icon),
                  child: user.icon.isEmpty ? Text(user.name[0]) : null,
                ),
                title: Text(user.name),
                subtitle: Text(user.id),
              );
            },
          );
        },
      ),
    );
  }
}
