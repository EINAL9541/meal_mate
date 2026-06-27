import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

import '../../features/cart/presentation/controller/cart_controller.dart';

class AppShellWidget extends ConsumerWidget {
  const AppShellWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.baseWhite,
        shadowColor: AppColors.scanTextColor,
        selectedIndex: _selectedIndex(context),
        onDestinationSelected: (index) => context.go(_routes[index]),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.scanTextColor),
            selectedIcon: Icon(Icons.home, color: AppColors.primaryColor),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text(cartCount > 9 ? '9+' : '$cartCount'),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.scanTextColor,
              ),
            ),
            selectedIcon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text(cartCount > 9 ? '9+' : '$cartCount'),
              child: Icon(Icons.shopping_cart, color: AppColors.primaryColor),
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.receipt_long_outlined,
              color: AppColors.scanTextColor,
            ),
            selectedIcon: Icon(
              Icons.receipt_long,
              color: AppColors.primaryColor,
            ),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppColors.scanTextColor),
            selectedIcon: Icon(Icons.person, color: AppColors.primaryColor),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static const _routes = ['/home', '/cart', '/orders', '/profile'];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _routes.indexWhere(location.startsWith);
    return index == -1 ? 0 : index;
  }
}
