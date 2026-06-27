import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/network/dio_provider.dart';
import 'package:meal_mate/core/error/failures.dart';

import '../../domain/entities/meal.dart';
import '../../domain/repository/meal_repository.dart';

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepositoryImpl(
    FirebaseFirestore.instance,
    ref.watch(dioProvider),
  );
});

class MealRepositoryImpl implements MealRepository {
  MealRepositoryImpl(this._firestore, this._dio);

  final FirebaseFirestore _firestore;
  final Dio _dio;

  CollectionReference<Map<String, dynamic>> get _mealsCollection =>
      _firestore.collection('meals');

  @override
  Stream<List<Meal>> watchMeals() {
    return _mealsCollection.orderBy('name').snapshots().map((snapshot) {
      final meals = snapshot.docs
          .map((doc) => Meal.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      return meals.isEmpty ? defaultMeals : meals;
    }).handleError((error) {
      throw DatabaseFailure('Failed to sync meals database: ${error.toString()}');
    });
  }

  @override
  Future<Meal?> getMeal(String id) async {
    if (RegExp(r'^\d+$').hasMatch(id)) {
      try {
        final response = await _dio.get('/lookup.php', queryParameters: {'i': id});
        final data = response.data;
        if (data is Map<String, dynamic> && data['meals'] != null) {
          final list = data['meals'] as List;
          if (list.isNotEmpty) {
            return _mapToMeal(list.first as Map<String, dynamic>);
          }
        }
      } catch (e) {
        throw _handleDioError(e);
      }
    }

    try {
      final doc = await _mealsCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        return Meal.fromJson({...doc.data()!, 'id': doc.id});
      }
    } catch (e) {
      throw DatabaseFailure('Failed to load meal from database.');
    }

    return defaultMeals.where((meal) => meal.id == id).firstOrNull;
  }

  @override
  Future<List<Meal>> searchMeals(String query) async {
    try {
      final response = await _dio.get('/search.php', queryParameters: {'s': query});
      final data = response.data;
      if (data is Map<String, dynamic> && data['meals'] != null) {
        final list = data['meals'] as List;
        return list.map((item) => _mapToMeal(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<Meal>> getMealsByLetter(String letter) async {
    try {
      final response = await _dio.get('/search.php', queryParameters: {'f': letter});
      final data = response.data;
      if (data is Map<String, dynamic> && data['meals'] != null) {
        final list = data['meals'] as List;
        return list.map((item) => _mapToMeal(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> createMeal(Meal meal) async {
    try {
      await _mealsCollection.doc(meal.id).set(meal.toJson());
    } catch (e) {
      throw DatabaseFailure('Failed to add meal to menu.');
    }
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    try {
      await _mealsCollection.doc(meal.id).set(meal.toJson());
    } catch (e) {
      throw DatabaseFailure('Failed to update meal details.');
    }
  }

  @override
  Future<void> deleteMeal(String id) async {
    try {
      await _mealsCollection.doc(id).delete();
    } catch (e) {
      throw DatabaseFailure('Failed to remove meal from menu.');
    }
  }

  Failure _handleDioError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const NetworkFailure('Connection timed out. Please check your internet connection and try again.');
        case DioExceptionType.connectionError:
          return const NetworkFailure('No internet connection. Please verify your connection.');
        case DioExceptionType.badResponse:
          final status = error.response?.statusCode;
          return ServerFailure('Server returned an error status ($status). Please try again later.');
        default:
          return const Failure('An error occurred while connecting to the server. Please try again.');
      }
    }
    return Failure('An unexpected error occurred: ${error.toString()}');
  }

  Meal _mapToMeal(Map<String, dynamic> json) {
    final id = json['idMeal'] as String? ?? '';
    final name = json['strMeal'] as String? ?? '';
    final instructions = json['strInstructions'] as String? ?? '';
    final categoryStr = json['strCategory'] as String? ?? '';
    final image = json['strMealThumb'] as String? ?? '';

    final category = _mapCategory(categoryStr, name, instructions);
    final price = _generatePrice(id);
    final rating = _generateRating(id);
    final ratingCount = _generateRatingCount(id);
    final prepTime = _generatePrepTime(id);

    return Meal(
      id: id,
      name: name,
      description: instructions,
      price: price,
      rating: rating,
      ratingCount: ratingCount,
      category: category,
      imageId: image,
      prepTime: prepTime,
    );
  }

  MealCategory _mapCategory(String strCategory, String strMeal, String strInstructions) {
    final catLower = strCategory.toLowerCase();
    final nameLower = strMeal.toLowerCase();
    final instrLower = strInstructions.toLowerCase();

    if (catLower == 'dessert') {
      return MealCategory.dessert;
    } else if (catLower == 'beverage' || catLower == 'drinks') {
      return MealCategory.drinks;
    } else if (nameLower.contains('rice') || instrLower.contains('rice')) {
      return MealCategory.rice;
    } else if (catLower == 'seafood' || catLower == 'pasta' || catLower == 'beef' || catLower == 'chicken') {
      return MealCategory.popular;
    } else {
      return MealCategory.popular;
    }
  }

  double _generatePrice(String id) {
    final code = id.hashCode.abs();
    return 4.99 + (code % 2000) / 100;
  }

  double _generateRating(String id) {
    final code = id.hashCode.abs();
    return 4.0 + (code % 11) / 10;
  }

  int _generateRatingCount(String id) {
    return id.hashCode.abs() % 400 + 10;
  }

  String _generatePrepTime(String id) {
    final minutes = 10 + (id.hashCode.abs() % 35);
    return '$minutes min';
  }
}

final mealsProvider = StreamProvider<List<Meal>>((ref) {
  return ref.watch(mealRepositoryProvider).watchMeals();
});

const defaultMeals = [
  Meal(
    id: '1',
    name: 'Margherita Pizza',
    description:
        'Classic tomato, fresh mozzarella & basil on hand-tossed dough',
    price: 14.99,
    rating: 4.8,
    ratingCount: 312,
    category: MealCategory.popular,
    imageId: '1565299624946-b28f40a0ae38',
    prepTime: '20 min',
  ),
  Meal(
    id: '2',
    name: 'Smash Burger',
    description: 'Double smashed patty, aged cheddar, pickles & house sauce',
    price: 13.50,
    rating: 4.7,
    ratingCount: 289,
    category: MealCategory.popular,
    imageId: '1568901346375-23c9450c58cd',
    prepTime: '15 min',
  ),
  Meal(
    id: '3',
    name: 'Teriyaki Rice Bowl',
    description: 'Glazed grilled chicken over steamed jasmine rice & sesame',
    price: 11.99,
    rating: 4.6,
    ratingCount: 178,
    category: MealCategory.rice,
    imageId: '1603133872878-684f208fb84b',
    prepTime: '18 min',
  ),
  Meal(
    id: '4',
    name: 'Caesar Salad',
    description: 'Crisp romaine, shaved parmesan, croutons & Caesar dressing',
    price: 9.99,
    rating: 4.5,
    ratingCount: 145,
    category: MealCategory.popular,
    imageId: '1512621776951-a57141f2eefd',
    prepTime: '10 min',
  ),
  Meal(
    id: '5',
    name: 'Mango Smoothie',
    description: 'Blended fresh mango, yogurt, honey & hint of ginger',
    price: 5.99,
    rating: 4.9,
    ratingCount: 201,
    category: MealCategory.drinks,
    imageId: '1525385444278-b7968e48ee7b',
    prepTime: '5 min',
  ),
  Meal(
    id: '6',
    name: 'Chocolate Lava Cake',
    description: 'Warm molten dark chocolate center, vanilla bean ice cream',
    price: 7.50,
    rating: 4.8,
    ratingCount: 167,
    category: MealCategory.dessert,
    imageId: '1558618666-fcd25c85cd64',
    prepTime: '12 min',
  ),
  Meal(
    id: '7',
    name: 'Street Tacos',
    description: 'Seasoned beef, pico de gallo, cotija cheese & lime crema',
    price: 10.99,
    rating: 4.6,
    ratingCount: 134,
    category: MealCategory.popular,
    imageId: '1565299507177-b0ac66763828',
    prepTime: '15 min',
  ),
  Meal(
    id: '8',
    name: 'Salmon Teriyaki',
    description: 'Pan-seared Atlantic salmon, jasmine rice & steamed greens',
    price: 17.99,
    rating: 4.9,
    ratingCount: 98,
    category: MealCategory.rice,
    imageId: '1519708227418-c8fd9a32b7a2',
    prepTime: '22 min',
  ),
  Meal(
    id: '9',
    name: 'Iced Matcha Latte',
    description: 'Ceremonial grade matcha, oat milk & pure honey over ice',
    price: 6.50,
    rating: 4.7,
    ratingCount: 223,
    category: MealCategory.drinks,
    imageId: '1536042202094-17c60b04e2af',
    prepTime: '5 min',
  ),
  Meal(
    id: '10',
    name: 'Strawberry Cheesecake',
    description: 'New York style cheesecake with fresh strawberry compote',
    price: 8.50,
    rating: 4.8,
    ratingCount: 189,
    category: MealCategory.dessert,
    imageId: '1565958011595-7f19f60df7d2',
    prepTime: '0 min',
  ),
];
