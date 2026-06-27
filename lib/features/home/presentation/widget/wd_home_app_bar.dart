import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/features/auth/presentation/controller/auth_controller.dart';

class HomeAppBarWidget extends HookConsumerWidget implements PreferredSizeWidget {
  final Function(String) onQueryChange;
  const HomeAppBarWidget({
    super.key,
    required this.onQueryChange
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = useTextEditingController();
    final user = ref.watch(authControllerProvider).value;

    debugPrint(user.toString());
    
    onClickCard() {
      context.go("/cart");
    }

    return Container(
      color: AppColors.baseWhite,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 20.h, right: 16.w, left: 16.w),
      child: Column(
        spacing: 24.h,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "San Francisco, CA",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "Good afternoon, ${user?.name.split(' ').first ?? 'User'} 👋",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: .all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_none,
                    color: AppColors.baseBlack,
                    size: 20.r,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              InkWell(
                onTap: onClickCard,
                child: Container(
                  padding: .all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.primaryColor,
                    size: 20.r,
                  ),
                ),
              ),
            ],
          ),
          TextField(
            controller: search,
            onChanged: onQueryChange,
            decoration: const InputDecoration(
              hintText: 'Search meals...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(160.h);
}
