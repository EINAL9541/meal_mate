import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

import '../../../../core/widgets/wd_food_image.dart';
import '../../../../core/widgets/button/primary_button.dart';
import '../../../cart/presentation/controller/cart_controller.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../domain/entities/meal.dart';

final mealDetailProvider = FutureProvider.family<Meal?, String>((ref, id) {
  return ref.watch(mealRepositoryProvider).getMeal(id);
});

class MealDetailScreen extends HookConsumerWidget {
  const MealDetailScreen({required this.mealId, super.key});

  final String mealId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealDetail = ref.watch(mealDetailProvider(mealId));
    final quantity = useState(1);
    final favorite = useState(false);

    return mealDetail.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Text(
              'Unable to load meal. $error',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
      data: (meal) {
        if (meal == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: const Center(child: Text('Meal not found')),
          );
        }

        return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              FoodImageWidget(
                imageId: meal.imageId,
                label: meal.name,
                height: 310.h,
                width: double.infinity,
              ),
              Positioned(
                top: 54.h,
                left: 16.w,
                child: InkWell(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: .all(15.r),
                    decoration: BoxDecoration(
                      color: AppColors.baseWhite,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.baseBlack,
                      size: 20.r,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 54.h,
                right: 16.w,
                child: InkWell(
                  onTap: () => favorite.value = !favorite.value,
                  child: Container(
                    padding: .all(15.r),
                    decoration: BoxDecoration(
                      color: AppColors.baseWhite,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      favorite.value ? Icons.favorite : Icons.favorite_border,
                      color: favorite.value
                          ? AppColors.error
                          : AppColors.baseBlack,
                      size: 20.r,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: .all(20.r),
              children: [
                Row(
                  crossAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: Text(
                        meal.name,
                        style: TextStyle(fontSize: 24.sp, fontWeight: .w900),
                      ),
                    ),
                    Text(
                      '\$${meal.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18.r),
                    SizedBox(width: 4.w),
                    Text(
                      '${meal.rating} (${meal.ratingCount} reviews)',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.schedule, size: 17.r),
                    SizedBox(width: 4.w),
                    Text(meal.prepTime),
                  ],
                ),
                SizedBox(height: 20.h),
                _InfoCard(
                  title: 'About this dish',
                  child: Text(
                    '${meal.description}. Crafted daily with fresh locally sourced ingredients and made to order.',
                  ),
                ),
                SizedBox(height: 12.h),
                const _InfoCard(
                  title: 'Nutritional Info',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Macro(label: 'Calories', value: '480'),
                      _Macro(label: 'Protein', value: '24g'),
                      _Macro(label: 'Carbs', value: '52g'),
                      _Macro(label: 'Fat', value: '18g'),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Spacer(),
                    IconButton.outlined(
                      onPressed: () =>
                          quantity.value = (quantity.value - 1).clamp(1, 99),
                      icon: Icon(Icons.remove),
                    ),
                    SizedBox(
                      width: 34.w,
                      child: Center(
                        child: Text(
                          '${quantity.value}',
                          style: const TextStyle(fontWeight: .w900),
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () => quantity.value++,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: .all(20.r),
        child: PrimaryButton(
          label:
              'Add to Cart · \$${(meal.price * quantity.value).toStringAsFixed(2)}',
          onPressed: () {
            ref
                .read(cartControllerProvider.notifier)
                .add(meal, quantity: quantity.value);
            context.pop();
          },
        ),
      ),
    );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: .all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _Macro extends StatelessWidget {
  const _Macro({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
