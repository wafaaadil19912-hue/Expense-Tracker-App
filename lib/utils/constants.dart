import 'package:flutter/material.dart';
import '../models/category.dart';

class AppConstants {
  static const String appName = 'Expense Tracker';

  static const Color incomeColor = Color(0xFF4CAF50);
  static const Color expenseColor = Color(0xFFE53935);
  static const Color primaryColor = Color(0xFF5C6BC0);

  static final List<Category> defaultCategories = [
    Category(
      id: 'food',
      name: 'Food',
      colorValue: 0xFFFF7043,
      iconCodePoint: Icons.fastfood.codePoint,
    ),
    Category(
      id: 'travel',
      name: 'Travel',
      colorValue: 0xFF42A5F5,
      iconCodePoint: Icons.flight.codePoint,
    ),
    Category(
      id: 'bills',
      name: 'Bills',
      colorValue: 0xFFAB47BC,
      iconCodePoint: Icons.receipt_long.codePoint,
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      colorValue: 0xFFFFCA28,
      iconCodePoint: Icons.shopping_bag.codePoint,
    ),
    Category(
      id: 'health',
      name: 'Health',
      colorValue: 0xFF66BB6A,
      iconCodePoint: Icons.local_hospital.codePoint,
    ),
    Category(
      id: 'income',
      name: 'Income',
      colorValue: 0xFF26A69A,
      iconCodePoint: Icons.account_balance_wallet.codePoint,
    ),
  ];
}
