import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization notice: $e');
  }
  runApp(const AcademicShowcaseApp());
}

class AcademicShowcaseApp extends StatelessWidget {
  const AcademicShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'AcademiQ',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const LoginScreen(),
      ),
    );
  }
}
