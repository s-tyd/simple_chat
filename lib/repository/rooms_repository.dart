import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/hive/rooms_data.dart';
import 'package:simple/model/room/room.dart';

final roomsProvider = StateNotifierProvider<RoomsRepository, List<Room>>(
  RoomsRepository.new,
);

class RoomsRepository extends StateNotifier<List<Room>> {
  RoomsRepository(this.ref) : super([]) {
    _loadCachedData();
    _startListening();
  }

  final Ref ref;
  final _roomsData = RoomsData();
  StreamSubscription<QuerySnapshot>? _subscription;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  Future<void> _loadCachedData() async {
    state = _roomsData.box.values.toList();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  void _startListening() {
    if (_currentUser != null) {
      final stream = FirebaseFirestore.instance
          .collection('memberships')
          .where('userId', isEqualTo: _currentUser!.uid)
          .snapshots();
      _subscription = stream.listen(_onData, onError: _onError);
    }
  }

  Future<void> _onData(QuerySnapshot querySnapshot) async {
    final docs = querySnapshot.docs;
    if (docs.isNotEmpty) {
      final roomIds = docs.map((doc) => doc['roomId']).toList();
      for (final roomId in roomIds) {
        final roomDoc = await FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId as String)
            .get();
        if (roomDoc.exists) {
          final data = roomDoc.data();
          if (data != null) {
            await _roomsData.cache(Room.fromJson(data));
          }
        }
      }
      state = _roomsData.box.values.toList();
    }
  }

  void _onError(Object error) {
    print('An error occurred: $error');
  }
}
