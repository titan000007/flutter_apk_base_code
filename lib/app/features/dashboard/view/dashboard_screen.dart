import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_prompt.dart';
import '../../active_orders/view/active_order_screen.dart';
import '../../home/view/home_screen.dart';
import '../../order_history/view/order_history_screen.dart';
import '../../profile_section/view/profile_screen.dart';
import '../controller/dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = Get.put(DashboardController());

  int _selectedIndex = 0;
  DateTime? _lastPressedAt;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ActiveOrderScreen(),
    const OrderHistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disable system pop
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final now = DateTime.now();
          if (_lastPressedAt == null ||
              now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
            _lastPressedAt = now;

            // Reset tab index to Home (if needed)
            controller.selectedIndex.value = 0;
            // Show exit toast
            showAppToast(msg: "Press back again to exit");
          } else {
            // Allow actual app exit
            //SystemNavigator.pop(); // or use `Navigator.of(context).pop(context, true)` in some cases
            SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
          }
        }
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            height: 70,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(AppImages.icHome, "Home", 0),
                _buildNavItem(AppImages.icTrack, "Active", 1),
                _buildNavItem(AppImages.icHistory, "History", 2),
                _buildNavItem(AppImages.icProfile, "Profile", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            height: 26,
            width: 24,
            color: isSelected
                ? AppColor.gradientFirstColor
                : AppColor.hintTextColor,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? AppColor.gradientFirstColor
                  : AppColor.hintTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
