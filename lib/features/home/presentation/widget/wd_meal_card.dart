import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/core/widgets/wd_food_image.dart';
import 'package:meal_mate/features/cart/presentation/controller/cart_controller.dart';
import 'package:meal_mate/features/home/domain/entities/meal.dart';

class MealCardWidget extends ConsumerWidget {
  const MealCardWidget({required this.meal, super.key});

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    onClickDetails() {
      context.push('/meal/${meal.id}');
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onClickDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                FoodImageWidget(
                  imageId: meal.imageId,
                  label: meal.name,
                  height: 132,
                  width: double.infinity,
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Chip(
                    label: Text(
                      '${meal.rating}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    avatar: Icon(Icons.star, color: Colors.amber, size: 14.sp),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 4.h),
              child: Text(
                meal.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: .w900, fontSize: 14.sp),
              ),
            ),
            Padding(
              padding: .symmetric(horizontal: 12.w),
              child: Text(
                meal.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 4.h, 10.w, 10.h),
              child: Row(
                children: [
                  Text(
                    '\$${meal.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: .w900,
                    ),
                  ),
                  const Spacer(),
                  IconButton.filled(
                    visualDensity: VisualDensity.compact,
                    onPressed: () =>
                        ref.read(cartControllerProvider.notifier).add(meal),
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
