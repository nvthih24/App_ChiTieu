import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime selectedDate = DateTime.now();
  String amount = "0";
  String note = "";
  String selectedCategory = "Ăn uống";

  // Hàm xử lý khi nhấn vào một phím số
  void _onKeyTap(String val) {
    setState(() {
      if (amount == "0") {
        amount = val; // Thay thế số 0 ban đầu
      } else {
        amount += val; // Cộng dồn chuỗi
      }
    });
  }

  // Hàm xử lý khi nhấn nút xóa (Backspread)
  void _onDeleteTap() {
    setState(() {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
      } else {
        amount = "0"; // Nếu xóa hết thì quay về số 0
      }
    });
  }

  // Danh sách icon mẫu
  final List<Map<String, dynamic>> categories = [
    {"name": "Ăn uống", "icon": Icons.fastfood_rounded, "color": Colors.orange},
    {
      "name": "Di chuyển",
      "icon": Icons.directions_car_rounded,
      "color": Colors.blue,
    },
    {
      "name": "Mua sắm",
      "icon": Icons.shopping_bag_rounded,
      "color": Colors.pink,
    },
    {"name": "Giải trí", "icon": Icons.movie_rounded, "color": Colors.purple},
    {
      "name": "Y tế",
      "icon": Icons.medical_services_rounded,
      "color": Colors.red,
    },
    {"name": "Lương", "icon": Icons.payments_rounded, "color": Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Nền xanh cho đồng bộ header
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Thêm giao dịch",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Hiển thị số tiền to
          _buildAmountDisplay(),

          // 2. Phần trắng chứa các input khác
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Ghi chú"),
                    _buildTextField(),
                    const SizedBox(height: 24),
                    _buildLabel("Danh mục"),
                    _buildCategoryGrid(),
                    const SizedBox(height: 24),
                    _buildLabel("Ngày tháng"),
                    _buildDatePicker(),
                    const SizedBox(height: 32),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountDisplay() {
    return GestureDetector(
      onTap: _showNumPad, // Nhấn vào để hiện bàn phím
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              const Text(
                "Nhấn để nhập số tiền",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "$amount đ",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textGrey,
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      onChanged: (value) => note = value,
      decoration: InputDecoration(
        hintText: "Nhập lý do chi tiêu...",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == categories.length) {
            return GestureDetector(
              onTap: _showAddCategoryDialog, // Hàm hiển thị popup thêm mới
              child: Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.grey, size: 30),
                    SizedBox(height: 4),
                    Text(
                      "Thêm",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          final cat = categories[index];
          bool isSelected = selectedCategory == cat.name;

          return GestureDetector(
            onTap: () => setState(() => selectedCategory = cat.name),
            onLongPress: () {
              _showDeleteCategoryDialog(cat);
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    IconData(
                      cat.iconCode,
                      fontFamily: 'MaterialIcons',
                    ), // Đọc mã Icon
                    color: isSelected
                        ? Colors.white
                        : Color(cat.colorValue), // Đọc mã màu
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) setState(() => selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (amount == "0") return; // Không cho lưu nếu chưa nhập tiền

          final newTx = Transaction(
            id: DateTime.now().toString(),
            title: note.isEmpty ? selectedCategory : note,
            amount: double.parse(amount),
            date: selectedDate,
            category: selectedCategory,
            typeString: selectedCategory == "Lương" ? "income" : "expense",
          );

          // Đẩy dữ liệu lên Provider
          Provider.of<TransactionProvider>(
            context,
            listen: false,
          ).addTransaction(newTx);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "LƯU GIAO DỊCH",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showNumPad() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        FocusScope.of(context).unfocus();
        return StatefulBuilder(
          // Dùng StatefulBuilder để cập nhật UI ngay trong BottomSheet
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: [
                  // Thanh gạch ngang nhỏ trên đầu BottomSheet
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.8,
                          ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        List<String> keys = [
                          "1",
                          "2",
                          "3",
                          "4",
                          "5",
                          "6",
                          "7",
                          "8",
                          "9",
                          ".",
                          "0",
                          "delete",
                        ];
                        String key = keys[index];

                        return TextButton(
                          onPressed: () {
                            if (key == "delete") {
                              _onDeleteTap();
                            } else {
                              _onKeyTap(key);
                            }
                            setModalState(
                              () {},
                            ); // Cập nhật giao diện bên trong modal
                          },
                          child: key == "delete"
                              ? const Icon(
                                  Icons.backspace_outlined,
                                  color: AppColors.textDark,
                                )
                              : Text(
                                  key,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Hàm hiển thị Popup nhập tên danh mục mới
  void _showAddCategoryDialog() {
    String newCategoryName = "";
    // Mặc định chọn icon đầu tiên và màu đầu tiên
    int selectedIconCode = Icons.local_cafe.codePoint;
    int selectedColorValue = Colors.orange.value;

    // Danh sách các Icon phổ biến để chọn
    final List<IconData> availableIcons = [
      Icons.local_cafe,
      Icons.restaurant,
      Icons.shopping_cart,
      Icons.directions_car,
      Icons.flight,
      Icons.movie,
      Icons.fitness_center,
      Icons.school,
      Icons.work,
      Icons.pets,
      Icons.home,
      Icons.local_hospital,
    ];

    // Danh sách màu sắc đẹp
    final List<Color> availableColors = [
      Colors.orange,
      Colors.blue,
      Colors.pink,
      Colors.purple,
      Colors.red,
      Colors.green,
      Colors.teal,
      Colors.brown,
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        // Dùng StatefulBuilder để cập nhật UI trong Dialog khi chọn Icon/Màu
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text(
              "Tạo danh mục mới",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Nhập tên
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Tên danh mục (VD: Gym, Trà sữa...)",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) => newCategoryName = val,
                    ),
                    const SizedBox(height: 20),

                    // 2. Chọn Icon
                    const Text(
                      "Chọn biểu tượng:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: availableIcons.map((icon) {
                        bool isSelected = selectedIconCode == icon.codePoint;
                        return GestureDetector(
                          onTap: () {
                            setStateDialog(
                              () => selectedIconCode = icon.codePoint,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(selectedColorValue).withOpacity(0.2)
                                  : Colors.grey[100],
                              border: isSelected
                                  ? Border.all(
                                      color: Color(selectedColorValue),
                                      width: 2,
                                    )
                                  : null,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: isSelected
                                  ? Color(selectedColorValue)
                                  : Colors.grey,
                              size: 24,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // 3. Chọn Màu
                    const Text(
                      "Chọn màu sắc:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: availableColors.map((color) {
                        bool isSelected = selectedColorValue == color.value;
                        return GestureDetector(
                          onTap: () {
                            setStateDialog(
                              () => selectedColorValue = color.value,
                            );
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.black, width: 3)
                                  : null,
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: color.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                              ],
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (newCategoryName.isEmpty) return;

                  final newCat = Category(
                    id: DateTime.now().toString(),
                    name: newCategoryName,
                    iconCode: selectedIconCode, // Lưu icon đã chọn
                    colorValue: selectedColorValue, // Lưu màu đã chọn
                    type: 'expense',
                  );

                  Provider.of<CategoryProvider>(
                    context,
                    listen: false,
                  ).addCategory(newCat);
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(selectedColorValue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Tạo ngay",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Hàm hiển thị hộp thoại xác nhận xóa
  void _showDeleteCategoryDialog(Category category) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Xóa danh mục?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Bạn có chắc muốn xóa danh mục '${category.name}' không? Hành động này không thể hoàn tác.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // 1. Xóa khỏi Database
              Provider.of<CategoryProvider>(
                context,
                listen: false,
              ).deleteCategory(category);

              // 2. Nếu danh mục đang chọn bị xóa -> Reset lại lựa chọn
              if (selectedCategory == category.name) {
                setState(() {
                  selectedCategory = "Ăn uống"; // Hoặc để trống ""
                });
              }

              Navigator.pop(ctx);

              // 3. Thông báo nhẹ
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Đã xóa danh mục ${category.name}")),
              );
            },
            child: const Text(
              "Xóa",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
