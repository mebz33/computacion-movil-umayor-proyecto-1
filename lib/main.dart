import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  runApp(const ElMauleInformaApp());
}

class ElMauleInformaApp extends StatelessWidget {
  const ElMauleInformaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Maule Informa',
      theme: appTheme(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
