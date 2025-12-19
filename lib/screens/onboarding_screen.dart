import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Dữ liệu nội dung 3 trang giới thiệu
  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Quản lý Đơn giản",
      "desc":
          "Theo dõi thu nhập và chi tiêu của bạn một cách dễ dàng và trực quan nhất.",
      "icon": Icons.savings_rounded,
      "color": Colors.green,
    },
    {
      "title": "Thống kê Chi tiết",
      "desc":
          "Biểu đồ trực quan giúp bạn hiểu rõ dòng tiền của mình đang đi về đâu.",
      "icon": Icons.pie_chart_rounded,
      "color": Colors.orange,
    },
    {
      "title": "Tiết kiệm Hiệu quả",
      "desc":
          "Lên kế hoạch tài chính thông minh để đạt được mục tiêu tương lai.",
      "icon": Icons.rocket_launch_rounded,
      "color": Colors.blue,
    },
  ];

  // Hàm xử lý khi bấm nút "Bắt đầu"
  void _finishOnboarding() async {
    // 1. Lưu lại là "Đã xem" vào Hive
    var box = await Hive.openBox('settings_box');
    await box.put('hasSeenOnboarding', true);

    // 2. Chuyển sang màn hình chính (Xóa luôn màn hình intro khỏi stack để không back lại được)
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. PHẦN SLIDER (Trang trượt)
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Vòng tròn nền Icon
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: _pages[index]['color'].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _pages[index]['icon'],
                          size: 100,
                          color: _pages[index]['color'],
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Tiêu đề
                      Text(
                        _pages[index]['title'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Mô tả
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          _pages[index]['desc'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 2. PHẦN ĐIỀU HƯỚNG DƯỚI CÙNG
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dấu chấm chỉ trang (Indicators)
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == index
                            ? 24
                            : 8, // Dài ra nếu đang chọn
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Nút bấm
                  _currentPage == _pages.length - 1
                      ? ElevatedButton(
                          onPressed: _finishOnboarding,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Bắt đầu ngay",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text(
                            "Tiếp theo",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
