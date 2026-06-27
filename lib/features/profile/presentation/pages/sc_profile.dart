import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/features/profile/presentation/widget/wd_menu_title.dart';
import 'package:meal_mate/features/profile/presentation/widget/wd_profile_app_bar.dart';
import 'package:meal_mate/features/profile/presentation/widget/wd_stat_color.dart';
import 'package:meal_mate/features/auth/presentation/controller/auth_controller.dart';
import 'package:meal_mate/features/orders/presentation/controller/orders_controller.dart';
import '../../../cart/presentation/controller/cart_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(userOrdersProvider);

    return Scaffold(
      appBar: const ProfileAppBarWidget(),
      body: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCardWidget(
                        label: 'Orders',
                        value: '${orders.length}',
                        icon: Icons.inventory_2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCardWidget(
                        label: 'Favorites',
                        value: '8',
                        icon: Icons.favorite,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: StatCardWidget(
                        label: 'Reviews',
                        value: '12',
                        icon: Icons.star,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: .fromLTRB(20.w, 0, 20.h, 20.w),
                child: Card(
                  child: Column(
                    children: [
                      MenutitleWidget(
                        icon: Icons.location_on,
                        title: 'Saved Addresses',
                        subtitle: '123 Maple St, San Francisco',
                      ),
                      Divider(color: AppColors.gray50),
                      MenutitleWidget(
                        icon: Icons.credit_card,
                        title: 'Payment Methods',
                        subtitle: 'Visa •••• 4242',
                      ),
                      Divider(color: AppColors.gray50),
                      MenutitleWidget(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: 'Push & email enabled',
                      ),
                      Divider(color: AppColors.gray50),
                      MenutitleWidget(
                        icon: Icons.settings,
                        title: 'App Settings',
                        subtitle: 'Theme, language & privacy',
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    ref.read(cartControllerProvider.notifier).clear();
                    await ref.read(authControllerProvider.notifier).logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),

                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    shadowColor: AppColors.primaryColor,
                    backgroundColor: AppColors.primary50,
                    minimumSize: Size.fromHeight(52.h),
                    side: BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ],
      ),
    );
  }
}

