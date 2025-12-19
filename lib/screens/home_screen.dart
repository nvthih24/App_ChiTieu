import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> transactions = [
    {
      "title": "Ăn sáng Starbucks",
      "category": "Ăn uống",
      "amount": "120.000đ",
      "icon": Icons.fastfood_rounded,
      "color": Colors.orange,
      "isExpense": true,
      "date": "Hôm nay",
    },
    {
      "title": "Lương tháng 12",
      "category": "Thu nhập",
      "amount": "15.000.000đ",
      "icon": Icons.payments_rounded,
      "color": Colors.green,
      "isExpense": false,
      "date": "Hôm qua",
    },
    {
      "title": "Grab/Be Car",
      "category": "Di chuyển",
      "amount": "55.000đ",
      "icon": Icons.directions_car_filled_rounded,
      "color": Colors.blue,
      "isExpense": true,
      "date": "18 Th12",
    },
    {
      "title": "Gói Adobe Full",
      "category": "Giải trí",
      "amount": "250.000đ",
      "icon": Icons.subscriptions_rounded,
      "color": Colors.purple,
      "isExpense": true,
      "date": "15 Th12",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildNavItem(Icons.home_rounded, "Trang chủ", true),
                _buildNavItem(Icons.bar_chart_rounded, "Thống kê", false),
              ],
            ),
            Row(
              children: [
                _buildNavItem(
                  Icons.account_balance_wallet_rounded,
                  "Ví",
                  false,
                ),
                _buildNavItem(Icons.person_rounded, "Cá nhân", false),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Lớp 1: Nền xanh phía sau (Background Header)
          _buildBackgroundHeader(context),

          // Lớp 2: Nội dung có thể cuộn (Scrollable Content)
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildTopNav(),
                  const SizedBox(height: 30),
                  _buildBalanceCard(), // Thẻ số dư nổi (Floating Card)
                  const SizedBox(height: 30),
                  _buildTransactionList(), // Danh sách giao dịch bên dưới
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- CÁC WIDGET THÀNH PHẦN ---

  Widget _buildBackgroundHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3, // Chiếm 30% chiều cao
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }

  Widget _buildTopNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chào buổi sáng,",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                "nvthih24 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Tổng số dư hiện tại",
            style: TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            "25,450,000 đ",
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFF0F0F0)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                "Thu nhập",
                "30.0tr",
                AppColors.accentGreen,
                Icons.arrow_downward,
              ),
              _buildStatItem(
                "Chi tiêu",
                "4.5tr",
                AppColors.accentRed,
                Icons.arrow_upward,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          radius: 18,
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Giao dịch gần đây",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Xem tất cả",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Danh sách giao dịch
          ListView.builder(
            shrinkWrap: true, // Quan trọng: để ListView bọc vừa nội dung
            physics:
                const NeverScrollableScrollPhysics(), // Để cuộn theo SingleChildScrollView bên ngoài
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final item = transactions[index];
              return _buildTransactionItem(item);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        // Đổ bóng cực nhẹ để tạo chiều sâu
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Khối Icon với màu Pastel
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (item['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(item['icon'], color: item['color'], size: 26),
          ),
          const SizedBox(width: 16),

          // Nội dung: Tên và Ngày tháng
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item['category']} • ${item['date']}",
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Số tiền
          Text(
            "${item['isExpense'] ? '-' : '+'}${item['amount']}",
            style: TextStyle(
              color: item['isExpense']
                  ? AppColors.accentRed
                  : AppColors.accentGreen,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return MaterialButton(
      minWidth: 40,
      onPressed: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? AppColors.primary : AppColors.textGrey),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? AppColors.primary : AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
