import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple/components/user_list_tile.dart';
import 'package:simple/model/user_data/user_data.dart';

class PotentialFriends extends HookWidget {
  const PotentialFriends({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;

    final friendRequestStream = useMemoized(
      () {
        return FirebaseFirestore.instance
            .collection('friendRequests')
            .where('received_uid', isEqualTo: _auth.currentUser!.uid)
            .where('status', isEqualTo: 'pending')
            .snapshots();
      },
      [],
    );

    return StreamBuilder<QuerySnapshot>(
      stream: friendRequestStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final friendRequests = snapshot.data!.docs
            .map((doc) {
              final docData = doc.data() as Map<String, dynamic>?;
              if (docData != null) {
                final senderId = docData['sender_uid'] as String;
                return FirebaseFirestore.instance
                    .collection('users')
                    .doc(senderId)
                    .snapshots();
              }
              return null;
            })
            .where((item) => item != null)
            .toList();

        if (friendRequests.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListView.builder(
          itemCount: friendRequests.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final senderStream = friendRequests[index];

            return StreamBuilder<DocumentSnapshot>(
              stream: senderStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;
                if (data != null) {
                  final sender = UserData.fromJson(data);
                  return UserListTile(user: sender);
                }
                return const SizedBox.shrink();
              },
            );
          },
        );
      },
    );
  }
}
