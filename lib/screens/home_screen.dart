import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'add_transaction_screen.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'dart:ui';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
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
          Positioned(
            top: -100,
            left: -50,
            child: _buildBlurCircle(Colors.white.withOpacity(0.2), 200),
          ),

          Positioned(
            top: 100,
            right: -80,
            child: _buildBlurCircle(
              AppColors.primaryLight.withOpacity(0.4),
              250,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildTopNav(),
                  const SizedBox(height: 30),
                  _buildBalanceCard(),
                  const SizedBox(height: 30),
                  _buildTransactionList(transactions),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- CÁC WIDGET THÀNH PHẦN ---

  Widget _buildBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildBackgroundHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
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
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return ClipRRect(
      // Bo góc cho hiệu ứng kính
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ), // Viền kính
          ),
          child: Column(
            children: [
              const Text(
                "Tổng số dư hiện tại",
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormat.format(25450000),
                style: const TextStyle(
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
                    currencyFormat.format(2540000), // Xài ở đây
                    AppColors.accentGreen,
                    Icons.arrow_downward,
                  ),
                  _buildStatItem(
                    "Chi tiêu",
                    currencyFormat.format(2545000), // Và ở đây
                    AppColors.accentRed,
                    Icons.arrow_upward,
                  ),
                ],
              ),
            ],
          ),
        ),
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

  Widget _buildTransactionList(List<Transaction> transactions) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

          const SizedBox(height: 12),
          transactions.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Chưa có giao dịch nào",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return _buildTransactionItem(tx, currencyFormat);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction tx, NumberFormat fmt) {
    bool isExpense = tx.type == TransactionType.expense;
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
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Icon(Icons.shopping_bag, color: AppColors.primary),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(tx.date),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          // Số tiền
          Text(
            "${isExpense ? '-' : '+'}${fmt.format(tx.amount)}",
            style: TextStyle(
              color: isExpense ? AppColors.accentRed : AppColors.accentGreen,
              fontWeight: FontWeight.bold,
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
