import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  static const String _boxName = 'categories_box';
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  CategoryProvider() {
    _loadCategories();
  }

  // Lấy danh sách theo loại (thu hoặc chi) để hiển thị cho gọn
  List<Category> getCategoriesByType(String type) {
    return _categories.where((c) => c.type == type).toList();
  }

  void _loadCategories() async {
    var box = await Hive.openBox<Category>(_boxName);

    // NẾU DATABASE TRỐNG (Lần đầu cài app) -> TẠO DỮ LIỆU MẪU
    if (box.isEmpty) {
      await _seedDefaultCategories(box);
    }

    _categories = box.values.toList();
    notifyListeners();
  }

  Future<void> _seedDefaultCategories(Box<Category> box) async {
    final defaults = [
      // Chi tiêu
      Category(
        id: '1',
        name: 'Ăn uống',
        iconCode: Icons.fastfood_rounded.codePoint,
        colorValue: Colors.orange.value,
        type: 'expense',
      ),
      Category(
        id: '2',
        name: 'Di chuyển',
        iconCode: Icons.directions_car_rounded.codePoint,
        colorValue: Colors.blue.value,
        type: 'expense',
      ),
      Category(
        id: '3',
        name: 'Mua sắm',
        iconCode: Icons.shopping_bag_rounded.codePoint,
        colorValue: Colors.pink.value,
        type: 'expense',
      ),
      Category(
        id: '4',
        name: 'Giải trí',
        iconCode: Icons.movie_rounded.codePoint,
        colorValue: Colors.purple.value,
        type: 'expense',
      ),
      // Thu nhập
      Category(
        id: '5',
        name: 'Lương',
        iconCode: Icons.attach_money_rounded.codePoint,
        colorValue: Colors.green.value,
        type: 'income',
      ),
      Category(
        id: '6',
        name: 'Thưởng',
        iconCode: Icons.card_giftcard_rounded.codePoint,
        colorValue: Colors.amber.value,
        type: 'income',
      ),
    ];

    await box.addAll(defaults);
  }

  // Thêm danh mục mới
  void addCategory(Category category) {
    final box = Hive.box<Category>(_boxName);
    box.add(category);
    _loadCategories();
  }

  // Xóa danh mục
  void deleteCategory(Category category) {
    category.delete(); // Xóa khỏi Hive
    _loadCategories();
  }
}
