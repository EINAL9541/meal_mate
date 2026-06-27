import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/domain/entities/meal.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({required Meal meal, required int quantity}) =
      _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
