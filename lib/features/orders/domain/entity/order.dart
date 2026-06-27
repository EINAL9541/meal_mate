import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../cart/domain/entity/cart_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum OrderStatus { pending, confirmed, completed, cancelled }

extension OrderStatusLabel on OrderStatus {
  String get label => switch (this) {
    OrderStatus.pending => 'Pending',
    OrderStatus.confirmed => 'Confirmed',
    OrderStatus.completed => 'Completed',
    OrderStatus.cancelled => 'Cancelled',
  };
}

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String userId,
    required String date,
    required List<CartItem> items,
    required double total,
    required OrderStatus status,
    required String userName,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
