import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../domain/entities/meal.dart';

const _letters = [
  'c', 's', 'b', 'm', 'p', 't', 'a', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',
  'n', 'o', 'q', 'r', 'u', 'v', 'w', 'x', 'y', 'z'
];

class MealsListState {
  final List<Meal> meals;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentLetterIndex;
  final bool hasMore;
  final String searchQuery;
  final MealCategory selectedCategory;

  const MealsListState({
    required this.meals,
    required this.isLoading,
    required this.isLoadingMore,
    this.error,
    required this.currentLetterIndex,
    required this.hasMore,
    required this.searchQuery,
    required this.selectedCategory,
  });

  MealsListState copyWith({
    List<Meal>? meals,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentLetterIndex,
    bool? hasMore,
    String? searchQuery,
    MealCategory? selectedCategory,
  }) {
    return MealsListState(
      meals: meals ?? this.meals,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentLetterIndex: currentLetterIndex ?? this.currentLetterIndex,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class MealsListNotifier extends Notifier<MealsListState> {
  @override
  MealsListState build() {
    Future.microtask(() => _fetchInitialMeals());

    return const MealsListState(
      meals: [],
      isLoading: true,
      isLoadingMore: false,
      currentLetterIndex: 0,
      hasMore: true,
      searchQuery: '',
      selectedCategory: MealCategory.all,
    );
  }

  Future<void> _fetchInitialMeals() async {
    state = state.copyWith(isLoading: true, meals: []);
    try {
      List<Meal> fetched;
      int nextIndex = 0;
      bool hasMore = true;

      if (state.searchQuery.isNotEmpty) {
        fetched = await ref.read(mealRepositoryProvider).searchMeals(state.searchQuery);
        hasMore = false;
      } else {
        final letter = _letters[0];
        fetched = await ref.read(mealRepositoryProvider).getMealsByLetter(letter);
        nextIndex = 1;
        hasMore = nextIndex < _letters.length;
      }

      state = state.copyWith(
        isLoading: false,
        meals: fetched,
        currentLetterIndex: nextIndex,
        hasMore: hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore || state.searchQuery.isNotEmpty) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final letter = _letters[state.currentLetterIndex];
      final fetched = await ref.read(mealRepositoryProvider).getMealsByLetter(letter);
      final nextIndex = state.currentLetterIndex + 1;

      final currentIds = state.meals.map((m) => m.id).toSet();
      final uniqueNewMeals = fetched.where((m) => !currentIds.contains(m.id)).toList();

      state = state.copyWith(
        isLoadingMore: false,
        meals: [...state.meals, ...uniqueNewMeals],
        currentLetterIndex: nextIndex,
        hasMore: nextIndex < _letters.length,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(
      currentLetterIndex: 0,
      hasMore: true,
    );
    await _fetchInitialMeals();
  }

  void updateSearchQuery(String query) {
    if (state.searchQuery == query) return;
    state = state.copyWith(searchQuery: query);
    _fetchInitialMeals();
  }

  void updateCategory(MealCategory category) {
    if (state.selectedCategory == category) return;
    state = state.copyWith(selectedCategory: category);
  }
}

final mealsListNotifierProvider = NotifierProvider<MealsListNotifier, MealsListState>(
  MealsListNotifier.new,
);

final filteredMealsProvider = Provider<List<Meal>>((ref) {
  final listState = ref.watch(mealsListNotifierProvider);
  return listState.meals.where((meal) {
    final matchesCategory = listState.selectedCategory == MealCategory.all ||
        meal.category == listState.selectedCategory;
    return matchesCategory;
  }).toList();
});
