import 'package:hive/hive.dart';
import 'package:simple/model/user_data/user_data.dart';

class FriendsData {
  const FriendsData();

  static const String boxName = 'friends_data_caches';

  static Future<void> clearCache() async {
    await Hive.box<UserData>(boxName).clear();
  }

  Box<UserData> get box {
    return Hive.box<UserData>(boxName);
  }

  Future<void> cache(UserData friend) async {
    await box.put(friend.uid, friend);
  }

  UserData? getFriend(String uid) {
    return box.get(uid, defaultValue: null);
  }
}
