import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple/serializer/timestamp_serializer.dart';

part 'user_data.freezed.dart';

part 'user_data.g.dart';

@freezed
class UserData with _$UserData {
  @HiveType(typeId: 0)
  const factory UserData({
    @HiveField(0) @Default('') String id,
    @HiveField(1) @Default('') String uid,
    @HiveField(2) @Default('') String name,
    @HiveField(3) @Default('') String email,
    @HiveField(4) @Default('') String icon,
    @HiveField(5) @TimestampSerializer() DateTime? createdAt,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
