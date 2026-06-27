import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/features/home/domain/entities/meal.dart';
import 'package:meal_mate/features/home/presentation/widget/wd_discount_card.dart';
import 'package:meal_mate/features/home/presentation/widget/wd_home_app_bar.dart';
import 'package:meal_mate/features/home/presentation/widget/wd_meal_card.dart';

import 'package:meal_mate/features/home/presentation/controller/meals_list_controller.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(mealsListNotifierProvider);
    final meals = ref.watch(filteredMealsProvider);
    final scrollController = useScrollController();

    useEffect(() {
      void scrollListener() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          ref.read(mealsListNotifierProvider.notifier).loadMore();
        }
      }
      scrollController.addListener(scrollListener);
      return () => scrollController.removeListener(scrollListener);
    }, [scrollController]);

    void onQueryChange(String value) {
      ref.read(mealsListNotifierProvider.notifier).updateSearchQuery(value);
    }

    return Scaffold(
      appBar: HomeAppBarWidget(onQueryChange: onQueryChange),
      body: Column(
        children: [
          Expanded(
            child: () {
              if (listState.isLoading && meals.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (listState.error != null && meals.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Text(
                      'Unable to load meals. ${listState.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () =>
                    ref.read(mealsListNotifierProvider.notifier).refresh(),
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: .all(16.r),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 62.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: MealCategory.values.length,
                            separatorBuilder: (_, _) => SizedBox(width: 8.w),
                            itemBuilder: (context, index) {
                              final value = MealCategory.values[index];
                              return ChoiceChip(
                                label: Text(
                                  value.label,
                                  style: TextStyle(
                                    color: listState.selectedCategory == value
                                        ? AppColors.baseWhite
                                        : AppColors.primaryColor,
                                  ),
                                ),
                                side: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 1,
                                ),
                                selectedColor: AppColors.primaryColor,
                                backgroundColor: AppColors.baseWhite,
                                showCheckmark: false,
                                selected: listState.selectedCategory == value,
                                onSelected: (selected) {
                                  if (selected) {
                                    ref
                                        .read(mealsListNotifierProvider.notifier)
                                        .updateCategory(value);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        if (listState.selectedCategory == MealCategory.all &&
                            listState.searchQuery.isEmpty)
                          DiscountCardWidget(),
                        SizedBox(height: 10.h),
                        if (meals.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 48.h),
                            child: const Text(
                              'No meals found',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: .zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: .68,
                                ),
                            itemCount: meals.length,
                            itemBuilder: (context, index) =>
                                MealCardWidget(meal: meals[index]),
                          ),
                        if (listState.isLoadingMore)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }(),
          ),
        ],
      ),
    );
  }
}
