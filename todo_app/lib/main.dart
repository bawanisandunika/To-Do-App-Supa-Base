// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_screen.dart';
import 'screens/welcome_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://svifdypufoujolooljmz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN2aWZkeXB1Zm91am9sb29sam16Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIyNDc3MzIsImV4cCI6MjA0NzgyMzczMn0.NzM3jN0luQkc_xRRtOdkh_5ElftiAOpaUeqiw-PtguA',
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WelcomeScreen(), // Show WelcomeScreen initially
    );
  }
}