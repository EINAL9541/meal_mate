// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  userId: json['userId'] as String,
  date: json['date'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toDouble(),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  userName: json['userName'] as String,
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'date': instance.date,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'userName': instance.userName,
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};
