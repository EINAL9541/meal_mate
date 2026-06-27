import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal.freezed.dart';
part 'meal.g.dart';

enum MealCategory { all, popular, rice, drinks, dessert }

extension MealCategoryLabel on MealCategory {
  String get label => switch (this) {
    MealCategory.all => 'All',
    MealCategory.popular => 'Popular',
    MealCategory.rice => 'Rice',
    MealCategory.drinks => 'Drinks',
    MealCategory.dessert => 'Dessert',
  };
}

@freezed
abstract class Meal with _$Meal {
  const factory Meal({
    required String id,
    required String name,
    required String description,
    required double price,
    required double rating,
    required int ratingCount,
    required MealCategory category,
    required String imageId,
    required String prepTime,
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}
