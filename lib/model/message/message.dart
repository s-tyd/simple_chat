import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple/serializer/timestamp_serializer.dart';

part 'message.freezed.dart';

part 'message.g.dart';

@freezed
class Message with _$Message {
  const Message._();

  const factory Message({
    @Default('') String id,
    @Default('') String userId,
    @Default('') String context,
    @Default('') String icon,
    @TimestampSerializer() DateTime? createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
