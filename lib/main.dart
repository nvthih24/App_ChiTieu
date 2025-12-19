import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'utils/app_colors.dart';
import 'screens/home_screen.dart';
import 'providers/transaction_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaction.dart';
import 'models/category.dart';
import 'providers/category_provider.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox<Transaction>('transactions_box');
  await Hive.openBox<Category>('categories_box');

  var settingsBox = await Hive.openBox('settings_box');

  bool hasSeenOnboarding = settingsBox.get(
    'hasSeenOnboarding',
    defaultValue: false,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: ExpenseTrackerApp(startScreen: !hasSeenOnboarding),
    ),
  );
}

class ExpenseTrackerApp extends StatelessWidget {
  final bool startScreen;

  const ExpenseTrackerApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sổ Thu Chi Pro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          background: AppColors.background,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: AppColors.surface,
        ),
      ),
      home: startScreen ? const OnboardingScreen() : HomeScreen(),
    );
  }
}
