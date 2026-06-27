import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/features/admin/profile/presentation/widget/wd_admin_menu_title.dart';
import 'package:meal_mate/features/admin/profile/presentation/widget/wd_admin_profile_stat.dart';

import '../../../../orders/domain/entity/order.dart';
import '../../../../orders/presentation/controller/orders_controller.dart';
import '../../../../auth/presentation/controller/auth_controller.dart';

class AdminProfileScreen extends ConsumerWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final name = user?.name ?? 'Admin User';
    final email = user?.email ?? 'admin@mealmate.com';
    final initials = name
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();

    final orders = ref.watch(ordersControllerProvider);
    final revenue = orders
        .where((order) => order.status != OrderStatus.cancelled)
        .fold<double>(0, (total, order) => total + order.total);

    return Scaffold(
      backgroundColor: AppColors.adminBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: .only(
                top: MediaQuery.of(context).padding.top + 22.h,
                left: 20.w,
                right: 20.w,
                bottom: 26.h,
              ),
              color: AppColors.adminBlue,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Admin Profile',
                    style: TextStyle(
                      color: AppColors.baseWhite,
                      fontSize: 20.sp,
                      fontWeight: .w900,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32.r,
                        backgroundColor: AppColors.baseWhite.withValues(
                          alpha: .18,
                        ),
                        foregroundColor: AppColors.baseWhite,
                        child: Text(
                          initials.isEmpty ? 'AD' : initials,
                          style: const TextStyle(fontWeight: .w900),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: AppColors.baseWhite,
                              fontSize: 18.sp,
                              fontWeight: .w900,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              color: Color(0xffbfdbfe),
                              fontWeight: .w700,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.baseWhite.withValues(alpha: .18),
                              borderRadius: .circular(999),
                            ),
                            child: Text(
                              'SUPER ADMIN',
                              style: TextStyle(
                                color: AppColors.baseWhite,
                                fontSize: 10,
                                fontWeight: .w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: .fromLTRB(16.w, 16.h, 16.w, 96.h),
            sliver: SliverList.list(
              children: [
                Row(
                  children: [
                    AdminProfileStatWidget(
                      label: 'Total Orders',
                      value: '${orders.length}',
                    ),
                    SizedBox(width: 10.w),
                    const AdminProfileStatWidget(
                      label: 'Active Users',
                      value: '48',
                    ),
                    SizedBox(width: 10.w),
                    AdminProfileStatWidget(
                      label: 'Revenue',
                      value: '\$${revenue.toStringAsFixed(0)}',
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Card(
                  child: Column(
                    children: [
                      const AdminMenuTileWidget(
                        icon: Icons.settings,
                        title: 'System Settings',
                        subtitle: 'App config & preferences',
                      ),
                      const Divider(height: 1, color: AppColors.gray50),
                      const AdminMenuTileWidget(
                        icon: Icons.notifications,
                        title: 'Notification Rules',
                        subtitle: 'Alert thresholds & emails',
                      ),
                      const Divider(height: 1, color: AppColors.gray50),
                      AdminMenuTileWidget(
                        icon: Icons.inventory_2,
                        title: 'Menu Management',
                        subtitle: 'Add, edit or remove meals',
                        onTap: () => context.go('/admin/menu'),
                      ),
                      const Divider(height: 1, color: AppColors.gray50),
                      const AdminMenuTileWidget(
                        icon: Icons.person,
                        title: 'User Management',
                        subtitle: 'View and manage accounts',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out of Admin'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xffdc2626),
                    backgroundColor: const Color(0xfffef2f2),
                    side: const BorderSide(color: Color(0xfffecaca)),
                    minimumSize: Size.fromHeight(52.h),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
