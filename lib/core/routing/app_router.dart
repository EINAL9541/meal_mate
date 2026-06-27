import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/features/admin/dashboard/presentation/pages/sc_admin_dashboard.dart';
import 'package:meal_mate/features/admin/auth/presentation/pages/sc_admin_login.dart';
import 'package:meal_mate/features/admin/orders/presentation/pages/sc_admin_order_detail.dart';
import 'package:meal_mate/features/admin/orders/presentation/pages/sc_admin_orders.dart';
import 'package:meal_mate/features/admin/profile/presentation/pages/sc_admin_profile.dart';
import 'package:meal_mate/core/widgets/wd_admin_shell.dart';
import 'package:meal_mate/features/home/presentation/pages/sc_home.dart';

import '../../features/auth/presentation/pages/sc_login.dart';
import '../../features/auth/presentation/pages/sc_register.dart';
import '../../features/auth/presentation/pages/sc_splash.dart';
import '../../features/cart/presentation/pages/sc_cart.dart';
import '../../features/cart/presentation/pages/sc_checkout.dart';
import '../../features/home/presentation/pages/sc_meal_detail.dart';
import '../../features/orders/presentation/pages/sc_order_history.dart';
import '../../features/profile/presentation/pages/sc_profile.dart';
import '../widgets/wd_app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final rootKey = GlobalKey<NavigatorState>();
  final shellKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(
        path: '/admin-login',
        builder: (_, _) => const AdminLoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/admin/orders/:id',
        builder: (_, state) =>
            AdminOrderDetailScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/meal/:id',
        builder: (_, state) =>
            MealDetailScreen(mealId: state.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/checkout',
        builder: (_, _) => const CheckoutScreen(),
      ),
      ShellRoute(
        navigatorKey: shellKey,
        builder: (_, _, child) => AppShellWidget(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          GoRoute(path: '/cart', builder: (_, _) => const CartScreen()),
          GoRoute(
            path: '/orders',
            builder: (_, _) => const OrderHistoryScreen(),
          ),
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
        ],
      ),
      ShellRoute(
        builder: (_, _, child) => AdminShellWidget(child: child),
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (_, _) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/orders',
            builder: (_, _) => const AdminOrdersScreen(),
          ),
          GoRoute(
            path: '/admin/profile',
            builder: (_, _) => const AdminProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
