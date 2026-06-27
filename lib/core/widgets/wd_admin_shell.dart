import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class AdminShellWidget extends StatelessWidget {
  const AdminShellWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.baseWhite,
        selectedIndex: _selectedIndex(context),
        indicatorColor: const Color(0xffeff6ff),
        onDestinationSelected: (index) => context.go(_routes[index]),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.adminBlue),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: AppColors.adminBlue),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings, color: AppColors.adminBlue),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static const _routes = [
    '/admin/dashboard',
    '/admin/orders',
    '/admin/profile',
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _routes.indexWhere(location.startsWith);
    return index == -1 ? 0 : index;
  }
}
