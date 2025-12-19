import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import 'package:provider/provider.dart';

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
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          bool isSelected = selectedCategory == cat['name'];
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = cat['name']),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cat['icon'],
                    color: isSelected ? Colors.white : cat['color'],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat['name'],
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
            type: selectedCategory == "Lương"
                ? TransactionType.income
                : TransactionType.expense,
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
}
