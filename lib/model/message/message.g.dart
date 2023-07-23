// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$$_MessageFromJson(Map<String, dynamic> json) => _$_Message(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      context: json['context'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      createdAt: const TimestampSerializer().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'context': instance.context,
      'icon': instance.icon,
      'createdAt': const TimestampSerializer().toJson(instance.createdAt),
    };
