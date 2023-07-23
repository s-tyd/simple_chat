import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/model/user_data/user_data.dart';
import 'package:simple/providers/firebase.dart';

final userDataProvider = StateNotifierProvider<UserRepository, UserData>(
  UserRepository.new,
);

class UserRepository extends StateNotifier<UserData> {
  UserRepository(this.ref) : super(const UserData()) {
    _startListening();
  }

  final Ref ref;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  User? get _currentUser => ref.read(firebaseAuthProvider).currentUser;

  void _startListening() {
    if (_currentUser != null) {
      final stream = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .snapshots();
      _userSubscription = stream.listen(_onData, onError: _onError);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _userSubscription?.cancel();
  }

  void _onData(DocumentSnapshot doc) {
    final data = doc.data();
    if (data != null) {
      log('Listening to user data: $data');
      state = UserData.fromJson(data as Map<String, dynamic>);
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
