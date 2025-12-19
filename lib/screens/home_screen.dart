import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'add_transaction_screen.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'dart:ui';
import 'statistics_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.filteredTransactions;
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
                _buildNavItem(
                  Icons.home_rounded,
                  "Trang chủ",
                  true,
                  onTap: () {},
                ),
                _buildNavItem(
                  Icons.bar_chart_rounded,
                  "Thống kê",
                  false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatisticsScreen(),
                      ),
                    );
                  },
                ),
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
                  _buildTopNav(context, transactionProvider),
                  const SizedBox(height: 30),
                  _buildBalanceCard(transactionProvider),
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

  Widget _buildTopNav(BuildContext context, TransactionProvider provider) {
    final date = provider.selectedDate;
    final monthStr = DateFormat('MM / yyyy').format(date);
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () {
                    provider.setSelectedDate(
                      DateTime(date.year, date.month - 1),
                    );
                  },
                ),
                Text(
                  monthStr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: () {
                    provider.setSelectedDate(
                      DateTime(date.year, date.month + 1),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(TransactionProvider provider) {
    // Thêm đầu vào là provider
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              const Text(
                "Tổng số dư hiện tại",
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              // DÙNG SỐ THỰC TỪ PROVIDER TẠI ĐÂY
              Text(
                currencyFormat.format(provider.totalBalance),
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
                    currencyFormat.format(
                      provider.totalIncome,
                    ), // Số thực Thu nhập
                    AppColors.accentGreen,
                    Icons.arrow_downward,
                  ),
                  _buildStatItem(
                    "Chi tiêu",
                    currencyFormat.format(
                      provider.totalExpense,
                    ), // Số thực Chi tiêu
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
              ? _buildEmptyState()
              : AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: _buildTransactionItem(
                              context,
                              tx,
                              currencyFormat,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    Transaction tx,
    NumberFormat fmt,
  ) {
    bool isExpense = tx.typeString == 'expense';
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(tx.key),
      direction: DismissDirection.endToStart,

      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
      ),
      onDismissed: (direction) {
        final deletedTransaction = tx;
        final index = provider.transactions.indexOf(tx);
        provider.deleteTransaction(index);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Đã xóa: ${deletedTransaction.title}"),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: "HOÀN TÁC",
              textColor: Colors.yellow,
              onPressed: () {
                provider.addTransaction(deletedTransaction);
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
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
              decoration: BoxDecoration(
                color: (isExpense ? Colors.red : Colors.green).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.shopping_bag,
                color: isExpense ? AppColors.accentRed : AppColors.accentGreen,
              ),
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
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive, {
    VoidCallback? onTap,
  }) {
    return MaterialButton(
      minWidth: 40,
      onPressed: onTap,
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

  Widget _buildEmptyState() {
    return Container(
      height: 300, // Chiều cao cố định để nó chiếm không gian đẹp
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Hình tròn nền
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(
                0.1,
              ), // Màu nền mờ theo tông chủ đạo
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded, // Icon tờ hóa đơn
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),

          // 2. Dòng thông báo chính
          const Text(
            "Chưa có giao dịch",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),

          // 3. Dòng kêu gọi hành động
          Text(
            "Hãy chạm vào nút (+) để\nthêm chi tiêu đầu tiên trong tháng",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
