import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/hive/friends_data.dart';
import 'package:simple/model/user_data/user_data.dart';
import 'package:simple/providers/firebase.dart';

final friendsProvider =
    StateNotifierProvider<FriendsRepository, List<UserData>>(
  FriendsRepository.new,
);

class FriendsRepository extends StateNotifier<List<UserData>> {
  FriendsRepository(this.ref) : super([]) {
    _loadCachedData();
    _startListening();
  }

  final Ref ref;
  final _friendsData = const FriendsData();
  StreamSubscription<QuerySnapshot>? _subscription;

  User? get _currentUser => ref.read(firebaseAuthProvider).currentUser;

  Future<void> _loadCachedData() async {
    final friends = <UserData>[];
    for (final key in _friendsData.box.keys) {
      final friend = _friendsData.getFriend(key as String);
      if (friend != null) {
        friends.add(friend);
      }
    }
    state = friends;
  }

  void _startListening() {
    if (_currentUser != null) {
      final stream = FirebaseFirestore.instance
          .collection('friendRequests')
          .where('senderId', isEqualTo: _currentUser!.uid)
          .where('status', isNotEqualTo: 'rejected')
          .snapshots();
      _subscription = stream.listen(_onData, onError: _onError);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  Future<void> _onData(QuerySnapshot querySnapshot) async {
    final docs = querySnapshot.docs;
    if (docs.isNotEmpty) {
      final friendsData = _friendsData;
      final friends = <UserData>[];
      for (final doc in docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          log('Listening to friends data: $data');
          final receivedId = data['receivedId'] as String;
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(receivedId)
              .get();
          final userData = userDoc.data();
          if (userData != null) {
            final friend = UserData.fromJson(userData);
            friends.add(friend);
            await friendsData.cache(friend);
          }
        }
      }
      state = friendsData.box.values.toList();
    }
  }

  void _onError(Object error) {
    // Handle the error. Here is a simple example.
    print('An error occurred: $error');
  }

  Future<void> updateUser(Map<String, dynamic> updates) async {
    if (_currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .update(updates);
    }
  }
}
