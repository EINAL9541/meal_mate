// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Meal _$MealFromJson(Map<String, dynamic> json) => _Meal(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  rating: (json['rating'] as num).toDouble(),
  ratingCount: (json['ratingCount'] as num).toInt(),
  category: $enumDecode(_$MealCategoryEnumMap, json['category']),
  imageId: json['imageId'] as String,
  prepTime: json['prepTime'] as String,
);

Map<String, dynamic> _$MealToJson(_Meal instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'rating': instance.rating,
  'ratingCount': instance.ratingCount,
  'category': _$MealCategoryEnumMap[instance.category]!,
  'imageId': instance.imageId,
  'prepTime': instance.prepTime,
};

const _$MealCategoryEnumMap = {
  MealCategory.all: 'all',
  MealCategory.popular: 'popular',
  MealCategory.rice: 'rice',
  MealCategory.drinks: 'drinks',
  MealCategory.dessert: 'dessert',
};
