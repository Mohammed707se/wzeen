// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/chat_service.dart';
import 'providers/chat_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider(ChatService())),
      ],
      child: MaterialApp(
        title: 'المحلل المالي',
        theme: ThemeData(
          primaryColor: const Color(0xFF6857E9),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF6857E9),
            secondary: const Color(0xFF6857E9),
          ),
          fontFamily: 'Cairo',
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}




