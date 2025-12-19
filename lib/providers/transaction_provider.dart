import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Thêm import này
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  // Tên box phải trùng với tên đã mở trong main.dart
  static const String _boxName = 'transactions_box';

  // Danh sách giao dịch lấy trực tiếp từ Hive
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  // Constructor: Tự động tải dữ liệu khi khởi tạo Provider
  TransactionProvider() {
    _loadTransactions();
  }

  // Hàm tải dữ liệu từ Hive box
  void _loadTransactions() {
    final box = Hive.box<Transaction>(_boxName);
    // Chuyển dữ liệu từ Box thành List và đảo ngược để cái mới nhất lên đầu
    _transactions = box.values.toList().reversed.toList();
    notifyListeners();
  }

  // Hàm để đổi tháng lọc
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners(); // Thông báo để UI load lại dữ liệu theo tháng mới
  }

  List<Transaction> get filteredTransactions {
    return _transactions.where((t) {
      return t.date.month == _selectedDate.month &&
          t.date.year == _selectedDate.year;
    }).toList();
  }

  // Tính tổng thu nhập
  double get totalIncome => filteredTransactions
      .where(
        (t) => t.typeString == 'income',
      ) // Lưu ý: Dùng typeString vì Hive lưu String
      .fold(0, (sum, item) => sum + item.amount);

  // Tính tổng chi tiêu
  double get totalExpense => filteredTransactions
      .where((t) => t.typeString == 'expense')
      .fold(0, (sum, item) => sum + item.amount);

  // Tính số dư còn lại
  double get totalBalance => totalIncome - totalExpense;

  // Hàm tính toán dữ liệu cho biểu đồ tròn (gom nhóm theo category)
  Map<String, double> getCategoryData() {
    Map<String, double> data = {};
    for (var tx in filteredTransactions) {
      // Chỉ thống kê các khoản chi tiêu (expense)
      if (tx.typeString == 'expense') {
        data[tx.category] = (data[tx.category] ?? 0) + tx.amount;
      }
    }
    return data;
  }

  // Hàm thêm giao dịch mới và lưu vào Hive
  void addTransaction(Transaction transaction) {
    final box = Hive.box<Transaction>(_boxName);

    // 1. Lưu vào Hive (Dữ liệu sẽ được ghi xuống ổ cứng)
    box.add(transaction);

    // 2. Cập nhật lại danh sách hiển thị
    _loadTransactions();
  }

  // Bonus: Hàm xóa giao dịch (Ông có thể dùng sau này)
  void deleteTransaction(int index) {
    final box = Hive.box<Transaction>(_boxName);
    // Lưu ý: Vì mình đảo ngược list để hiển thị, nên index xóa cần tính toán lại
    // hoặc xóa trực tiếp bằng key của HiveObject
    _transactions[index].delete();
    _loadTransactions();
  }
}
