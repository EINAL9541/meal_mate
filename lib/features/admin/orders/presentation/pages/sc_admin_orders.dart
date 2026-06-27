import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

import '../../../../orders/domain/entity/order.dart';
import '../../../../orders/presentation/controller/orders_controller.dart';
import '../../../../../core/widgets/wd_admin_app_bar.dart';
import '../../../../../core/widgets/wd_admin_order_card.dart';

class AdminOrdersScreen extends HookConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = useState('');
    final filter = useState<OrderStatus?>(null);
    final orders = ref.watch(ordersControllerProvider);

    final filtered = orders.where((order) {
      final matchesFilter =
          filter.value == null || order.status == filter.value;
      final matchesSearch =
          order.id.toLowerCase().contains(search.value.toLowerCase()) ||
          order.userName.toLowerCase().contains(search.value.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff1f5f9),
      appBar: const AdminAppBarWidget(title: 'Orders'),
      body: Column(
        children: [
          Container(
            color: AppColors.baseWhite,
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => search.value = value,
                  decoration: const InputDecoration(
                    hintText: 'Search by order ID or customer...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 38.h,
                  child: ListView.separated(
                    scrollDirection: .horizontal,
                    itemBuilder: (context, index) {
                      final status = index == 0
                          ? null
                          : OrderStatus.values[index - 1];
                      final selected = filter.value == status;
                      final count = status == null
                          ? orders.length
                          : orders
                                .where((order) => order.status == status)
                                .length;
                      return ChoiceChip(
                        selected: selected,
                        showCheckmark: false,
                        selectedColor: AppColors.adminBlue,
                        backgroundColor: const Color(0xfff1f5f9),
                        side: BorderSide(
                                  color: AppColors.adminBlue,
                                  width: 1,
                                ),
                        label: Text(
                          '${status?.label ?? 'All'} $count',
                          style: TextStyle(
                            color: selected
                                ? AppColors.baseWhite
                                : const Color(0xff64748b),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onSelected: (_) => filter.value = status,
                      );
                    },
                    separatorBuilder: (_, _) => SizedBox(width: 8.w),
                    itemCount: OrderStatus.values.length + 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      search.value.isEmpty
                          ? 'No orders found'
                          : 'No results for "${search.value}"',
                      style: const TextStyle(fontWeight: .w800),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 96.h),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final order = filtered[index];
                      return AdminOrderCardWidget(
                        order: order,
                        onTap: () => context.push('/admin/orders/${order.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
