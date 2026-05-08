import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../services/storage_service.dart';

class TransactionController extends GetxController {
  final _uuid = const Uuid();

  // ─── Observables ──────────────────────────────────────────────────────────

  final RxList<Transaction> transactions = <Transaction>[].obs;
  final RxList<Category> categories = <Category>[].obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    transactions.assignAll(StorageService.getAllTransactions());
    categories.assignAll(StorageService.getAllCategories());
  }

  // ─── Filtered Transactions ────────────────────────────────────────────────

  List<Transaction> get monthlyTransactions {
    return transactions.where((tx) {
      return tx.date.year == selectedMonth.value.year &&
          tx.date.month == selectedMonth.value.month;
    }).toList();
  }

  // ─── Summary Calculations ─────────────────────────────────────────────────

  double get totalIncome {
    return monthlyTransactions
        .where((tx) => tx.isIncome)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get totalExpenses {
    return monthlyTransactions
        .where((tx) => tx.isExpense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get balance => totalIncome - totalExpenses;

  // ─── Category Spending Map ─────────────────────────────────────────────────

  Map<String, double> get categorySpending {
    final Map<String, double> map = {};
    for (var tx in monthlyTransactions.where((t) => t.isExpense)) {
      map[tx.categoryId] = (map[tx.categoryId] ?? 0) + tx.amount;
    }
    return map;
  }

  // Add these to TransactionController
  Map<String, double> get incomeByCategory {
    final Map<String, double> map = {};
    for (var tx in monthlyTransactions.where((t) => t.isIncome)) {
      map[tx.categoryId] = (map[tx.categoryId] ?? 0) + tx.amount;
    }
    return map;
  }

  Map<String, double> get expenseByCategory {
    final Map<String, double> map = {};
    for (var tx in monthlyTransactions.where((t) => t.isExpense)) {
      map[tx.categoryId] = (map[tx.categoryId] ?? 0) + tx.amount;
    }
    return map;
  }

  // ─── CRUD Operations ─────────────────────────────────────────────────────

  Future<void> addTransaction({
    required double amount,
    required String categoryId,
    required DateTime date,
    required String note,
    required String type,
  }) async {
    final tx = Transaction(
      id: _uuid.v4(),
      amount: amount,
      categoryId: categoryId,
      date: date,
      note: note,
      type: type,
    );
    await StorageService.addTransaction(tx);
    loadData();
  }

  Future<void> updateTransaction(Transaction tx) async {
    await StorageService.updateTransaction(tx);
    loadData();
  }

  Future<void> deleteTransaction(String id) async {
    await StorageService.deleteTransaction(id);
    loadData();
  }

  Future<void> addCustomCategory(Category cat) async {
    await StorageService.addCategory(cat);
    categories.assignAll(StorageService.getAllCategories());
  }

  // ─── Month Navigation ─────────────────────────────────────────────────────

  void previousMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );
  }

  void nextMonth() {
    final now = DateTime.now();
    final next = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );
    if (!next.isAfter(now)) selectedMonth.value = next;
  }
// Inside TransactionController

  Future<void> updateCategory(Category cat) async {
    await StorageService.updateCategory(cat);
    categories.assignAll(StorageService.getAllCategories());
  }

  Future<void> deleteCategory(String id) async {
    await StorageService.deleteCategory(id);
    categories.assignAll(StorageService.getAllCategories());
  }
  // ─── Helpers ──────────────────────────────────────────────────────────────

  Category? getCategoryById(String id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
