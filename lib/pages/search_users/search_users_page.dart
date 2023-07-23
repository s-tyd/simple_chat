import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/model/user_data/user_data.dart';
import 'package:simple/providers/firebase.dart';

import 'potential_frieds.dart';

class SearchUsersPage extends HookConsumerWidget {
  const SearchUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchResults = useState<Future<QuerySnapshot>?>(null);
    final auth = ref.read(firebaseAuthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by ID',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchResults.value = FirebaseFirestore.instance
                        .collection('users')
                        .where('id', isEqualTo: searchController.text)
                        .get();
                  },
                ),
              ),
              onSubmitted: (value) {
                searchResults.value = FirebaseFirestore.instance
                    .collection('users')
                    .where('id', isEqualTo: searchController.text)
                    .get();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: searchResults.value,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final users = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final _userData = users[index].data();
                      if (_userData == null) {
                        return const Text('No user data');
                      }
                      final user = UserData.fromJson(
                        _userData as Map<String, dynamic>,
                      );

                      final isMyself = user.uid == auth.currentUser!.uid;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user.icon.isEmpty
                              ? null
                              : NetworkImage(user.icon),
                          child: user.icon.isEmpty ? Text(user.name[0]) : null,
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.id),
                        trailing: isMyself
                            ? const Chip(label: Text('my self'))
                            : const Icon(Icons.add),
                        onTap: isMyself
                            ? null
                            : () async {
                                final friendRef = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(auth.currentUser!.uid)
                                    .collection('friends')
                                    .doc(user.uid);

                                final doc = await friendRef.get();

                                if (!doc.exists) {
                                  await friendRef.set(user.toJson());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${user.name} has been added to'
                                        ' your friends!',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('${user.name} is already in '
                                              'your friends!'),
                                    ),
                                  );
                                }
                              },
                      );
                    },
                  );
                } else {
                  return const Text('No users found');
                }
              },
            ),
          ),
          const Text('Potential friends: '),
          const Expanded(
            child: PotentialFriends(),
          ),
        ],
      ),
    );
  }
}
