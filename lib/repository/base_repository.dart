import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/providers/firebase.dart';

abstract class BaseRepository<T> extends StateNotifier<T> {
  BaseRepository(this.ref, T initialState) : super(initialState);

  final Ref ref;
  StreamSubscription<dynamic>? _subscription;

  User? get _currentUser => ref.read(firebaseAuthProvider).currentUser;

  void _startListening(Stream<dynamic> stream) {
    _subscription = stream.listen(onData, onError: _onError);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  Future<void> updateUser(Map<String, dynamic> updates) async {
    if (_currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .update(updates);
    }
  }

  void onData(dynamic event);

  void _onError(Object error) {
    // Handle the error. Here is a simple example.
    print('An error occurred: $error');
  }
}

// class FriendsRepository extends BaseRepository<List<UserData>> {
//   FriendsRepository(Ref ref) : super(ref, <UserData>[]) {
//     _loadCachedData();
//     _startListening(FirebaseFirestore.instance
//         .collection('friendRequests')
//         .where('senderId', isEqualTo: _currentUser!.uid)
//         .where('status', isNotEqualTo: 'rejected')
//         .snapshots());
//   }
//
//   final _friendsData = const FriendsData();
//
//   Future<void> _loadCachedData() async {
//     final friends = <UserData>[];
//     for (final key in _friendsData.box.keys) {
//       final friend = _friendsData.getFriend(key as String);
//       if (friend != null) {
//         friends.add(friend);
//       }
//     }
//     state = friends;
//   }
//
//   @override
//   Future<void> onData(QuerySnapshot querySnapshot) async {
//     final docs = querySnapshot.docs;
//     if (docs.isNotEmpty) {
//       final friendsData = _friendsData;
//       final friends = <UserData>[];
//       for (final doc in docs) {
//         final data = doc.data() as Map<String, dynamic>?;
//         if (data != null) {
//           log('Listening to friends data: $data');
//           final receivedId = data['receivedId'] as String;
//           final userDoc = await FirebaseFirestore.instance
//               .collection('users')
//               .doc(receivedId)
//               .get();
//           final userData = userDoc.data();
//           if (userData != null) {
//             final friend = UserData.fromJson(userData);
//             friends.add(friend);
//             await friendsData.cache(friend);
//           }
//         }
//       }
//       state = friendsData.box.values.toList();
//     }
//   }
// }
//
// class UserRepository extends BaseRepository<UserData> {
//   UserRepository(Ref ref) : super(ref, const UserData()) {
//     _startListening(FirebaseFirestore.instance
//         .collection('users')
//         .doc(_currentUser!.uid)
//         .snapshots());
//   }
//
//   @override
//   void onData(DocumentSnapshot doc) {
//     final data = doc.data();
//     if (data != null) {
//       log('Listening to user data: $data');
//       state = UserData.fromJson(data as Map<String, dynamic>);
//     }
//   }
// }
