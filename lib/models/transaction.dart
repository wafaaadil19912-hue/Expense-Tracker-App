import 'package:hive/hive.dart';

part 'transaction.g.dart';

enum TransactionType { income, expense }

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String categoryId;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String note;

  @HiveField(5)
  String type; // 'income' or 'expense'

  Transaction({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.note,
    required this.type,
  });

  bool get isExpense => type == 'expense';
  bool get isIncome => type == 'income';
}
