import 'package:hive/hive.dart';
import 'package:simple/model/room/room.dart';

class RoomsData {
  static const String boxName = 'rooms_data_caches';

  Future<void> clearCache() async {
    await Hive.box<Room>(boxName).clear();
  }

  Box<Room> get box {
    return Hive.box<Room>(boxName);
  }

  Future<void> cache(Room room) async {
    await box.put(room.id, room);
  }

  Room? getRoom(String roomId) {
    return box.get(roomId, defaultValue: null);
  }
}
