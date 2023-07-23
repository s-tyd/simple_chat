import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple/serializer/timestamp_serializer.dart';

part 'room.freezed.dart';

part 'room.g.dart';

@freezed
class Room with _$Room {
  @HiveType(typeId: 1)
  const factory Room({
    @HiveField(0) @Default('') String id,
    @HiveField(1) @Default('') String uid,
    @HiveField(2) @Default('') String name,
    @HiveField(3) @Default('') String icon,
    @HiveField(4) @Default([]) List<String> members,
    @HiveField(5) @TimestampSerializer() DateTime? createdAt,
    @HiveField(6) @TimestampSerializer() DateTime? updatedAt,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
