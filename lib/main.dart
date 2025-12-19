import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'utils/app_colors.dart';
import 'screens/home_screen.dart';
import 'providers/transaction_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Khởi tạo Hive
  await Hive.initFlutter();

  // 2. Đăng ký Adapter để Hive biết cách đọc Transaction
  Hive.registerAdapter(TransactionAdapter());

  // 3. Mở một cái "Hộp" (Box) để đựng dữ liệu
  await Hive.openBox<Transaction>('transactions_box');

  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: const ExpenseTrackerApp(),
    ),
  );
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Pro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          background: AppColors.background,
        ),
        // Thiết lập Font chữ tiêu chuẩn cho toàn app
        textTheme: GoogleFonts.poppinsTextTheme(),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: AppColors.surface,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
