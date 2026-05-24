import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/transaction_controller.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AppConstants.primaryColor,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(TransactionController());
      }),
      home: const HomeScreen(),

      // ✅ Add the SafeArea wrapper here using builder
      builder: (context, child) {
        return SafeArea(
          top: false, // No padding on top
          bottom: true, // Add padding at bottom to avoid navigation bar
          child: child!,
        );
      },
    );
  }
}
