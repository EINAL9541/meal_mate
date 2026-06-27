import 'package:flutter/material.dart';

import '../../features/orders/domain/entity/order.dart';

class StatusBadgeWidget extends StatelessWidget {
  const StatusBadgeWidget({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = switch (status) {
      OrderStatus.pending => (const Color(0xfffffbeb), const Color(0xffb45309)),
      OrderStatus.confirmed => (
        const Color(0xffeff6ff),
        const Color(0xff1d4ed8),
      ),
      OrderStatus.completed => (
        const Color(0xffecfdf5),
        const Color(0xff047857),
      ),
      OrderStatus.cancelled => (
        const Color(0xfffef2f2),
        const Color(0xffdc2626),
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 7, color: colors.$2),
            const SizedBox(width: 6),
            Text(
              status.label,
              style: TextStyle(
                color: colors.$2,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
