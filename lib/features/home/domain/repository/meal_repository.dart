import '../entities/meal.dart';

abstract class MealRepository {
  Stream<List<Meal>> watchMeals();
  Future<Meal?> getMeal(String id);
  Future<List<Meal>> searchMeals(String query);
  Future<List<Meal>> getMealsByLetter(String letter);
  Future<void> createMeal(Meal meal);
  Future<void> updateMeal(Meal meal);
  Future<void> deleteMeal(String id);
}
