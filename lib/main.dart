import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/auth/login_screen.dart';

// Definisikan tema di sini agar mudah dikelola
class AppTheme {
  static const Color primaryColor = Color(0xFF6A1B9A); // Ungu Tua
  static const Color accentColor = Color(0xFF42A5F5);  // Biru Muda
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
    ),
    scaffoldBackgroundColor: Colors.grey[50],
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
          fontSize: 20, fontWeight: FontWeight.w600, color: whiteColor),
      iconTheme: IconThemeData(color: whiteColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: darkCardColor,
      background: darkBackgroundColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackgroundColor,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
          fontSize: 20, fontWeight: FontWeight.w600, color: whiteColor),
      iconTheme: IconThemeData(color: whiteColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traveloka Abal Abal',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Otomatis sesuai tema sistem
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}