import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  // Danh sách giao dịch ban đầu (có thể để trống [])
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  // Tính tổng thu nhập
  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, item) => sum + item.amount);

  // Tính tổng chi tiêu
  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, item) => sum + item.amount);

  // Tính số dư còn lại
  double get totalBalance => totalIncome - totalExpense;

  // Hàm thêm giao dịch mới
  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction); // Thêm vào đầu danh sách
    notifyListeners(); // Thông báo cho UI cập nhật lại
  }
}
