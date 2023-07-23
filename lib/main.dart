import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/hive/rooms_data.dart';
import 'package:simple/model/room/room.dart';

import 'firebase_options.dart';
import 'hive/friends_data.dart';
import 'model/user_data/user_data.dart';
import 'my_app.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(UserDataAdapter())
    ..registerAdapter(RoomAdapter());
  await Hive.openBox<UserData>(FriendsData.boxName);
  await Hive.openBox<Room>(RoomsData.boxName);
}

void main() async {
  await initHive();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}
