import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../utils/constants.dart';

class StorageService {
  static late Box<Transaction> _transactionBox;
  static late Box<Category> _categoryBox;

  // ─── Initialization ───────────────────────────────────────────────────────

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(CategoryAdapter());

    _transactionBox = await Hive.openBox<Transaction>('transactions');
    _categoryBox = await Hive.openBox<Category>('categories');

    // Seed predefined categories if empty
    if (_categoryBox.isEmpty) {
      _seedDefaultCategories();
    }
  }

  // ─── Transactions ─────────────────────────────────────────────────────────

  static List<Transaction> getAllTransactions() {
    return _transactionBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<void> addTransaction(Transaction tx) async {
    await _transactionBox.put(tx.id, tx);
  }

  static Future<void> updateTransaction(Transaction tx) async {
    await _transactionBox.put(tx.id, tx);
  }

  static Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  // ─── Categories ───────────────────────────────────────────────────────────

  static List<Category> getAllCategories() {
    return _categoryBox.values.toList();
  }

  static Future<void> addCategory(Category cat) async {
    await _categoryBox.put(cat.id, cat);
  }

  static Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }
// Inside StorageService

  static Future<void> updateCategory(Category cat) async {
    await _categoryBox.put(cat.id, cat);
  }

  static Category? getCategoryById(String id) {
    return _categoryBox.get(id);
  }

  // ─── Seed Data ────────────────────────────────────────────────────────────

  static void _seedDefaultCategories() {
    for (var cat in AppConstants.defaultCategories) {
      _categoryBox.put(cat.id, cat);
    }
  }
}
