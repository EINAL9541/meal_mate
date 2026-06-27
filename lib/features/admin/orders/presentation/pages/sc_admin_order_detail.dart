import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/features/admin/orders/presentation/widget/wd_order_items_card.dart';
import 'package:meal_mate/features/admin/orders/presentation/widget/wd_order_status_and_date_card.dart';
import 'package:meal_mate/features/admin/orders/presentation/widget/wd_update_status_card.dart';
import 'package:meal_mate/features/admin/orders/presentation/widget/wd_user_card.dart';

import '../../../../orders/domain/entity/order.dart';
import '../../../../orders/presentation/controller/orders_controller.dart';
import '../../../../../core/widgets/wd_admin_app_bar.dart';

class AdminOrderDetailScreen extends HookConsumerWidget {
  const AdminOrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersControllerProvider);
    final order = orders.where((value) => value.id == orderId).firstOrNull;

    if (order == null) {
      return Scaffold(
        appBar: AdminAppBarWidget(title: orderId, onBack: context.pop),
        body: const Center(child: Text('Order not found')),
      );
    }

    final selectedStatus = useState(order.status);

    onSelectedStatusChange(OrderStatus value) {
      selectedStatus.value = value;
    }

    updateStatus() {
      ref
          .read(ordersControllerProvider.notifier)
          .updateStatus(order.id, selectedStatus.value);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status updated successfully')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff1f5f9),
      appBar: AdminAppBarWidget(title: order.id, onBack: context.pop),
      body: ListView(
        padding: .fromLTRB(16.w, 16.h, 16.w, 24.h),
        children: [
          OrderStatusAndDateCardWidget(status: order.status, date: order.date),
          SizedBox(height: 12.h),
          UserCardWidget(userName: order.userName),
          SizedBox(height: 12.h),
          OrderItemsCardWidget(order: order),
          SizedBox(height: 12.h),
          UpdateStatusCardWidget(
            order: order,
            selectedStatus: selectedStatus.value,
            onSelectedStatuschange: onSelectedStatusChange,
            onPressed: updateStatus,
          ),
          SizedBox(height: 12.h),
          SafeArea(
            top: false,
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Order'),
                    content: const Text(
                      'Are you sure you want to delete this order? This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ref
                      .read(ordersControllerProvider.notifier)
                      .deleteOrder(order.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order deleted successfully'),
                      ),
                    );
                    context.pop();
                  }
                }
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete Order'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                minimumSize: Size.fromHeight(52.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
