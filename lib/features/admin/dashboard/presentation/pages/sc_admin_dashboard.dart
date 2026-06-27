import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/features/admin/dashboard/presentation/widget/wd_recent_orders.dart';

import '../../../../orders/domain/entity/order.dart';
import '../../../../orders/presentation/controller/orders_controller.dart';
import '../../../../../core/widgets/wd_admin_app_bar.dart';
import '../widget/wd_admin_stat_card.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersControllerProvider);
    final pending = orders
        .where((order) => order.status == OrderStatus.pending)
        .length;
    final completed = orders
        .where((order) => order.status == OrderStatus.completed)
        .length;
    final revenue = orders
        .where((order) => order.status != OrderStatus.cancelled)
        .fold<double>(0, (total, order) => total + order.total);

    return Scaffold(
      backgroundColor: AppColors.adminBackground,
      appBar: AdminAppBarWidget(
        title: 'Dashboard',
        onProfile: () => context.go('/admin/profile'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 96.h),
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.18,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            children: [
              AdminStatCardWidget(
                label: 'Total Orders',
                value: '${orders.length}',
                icon: Icons.shopping_bag_outlined,
                color: AppColors.adminBlue,
                trend: '+12% this week',
              ),
              AdminStatCardWidget(
                label: 'Pending Orders',
                value: '$pending',
                icon: Icons.access_time,
                color: const Color(0xffd97706),
              ),
              AdminStatCardWidget(
                label: 'Completed',
                value: '$completed',
                icon: Icons.check_circle_outline,
                color: const Color(0xff16a34a),
                trend: '+8% this week',
              ),
              AdminStatCardWidget(
                label: 'Revenue',
                value: '\$${revenue.toStringAsFixed(0)}',
                icon: Icons.attach_money,
                color: const Color(0xff7c3aed),
                trend: '+15% this month',
              ),
            ],
          ),
          SizedBox(height: 22.h),
          RecentOrdersWidget(orders: orders)
        ],
      ),
    );
  }
}
