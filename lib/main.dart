// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';
import 'screens/selector_screen.dart';
import 'screens/course_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<CourseProvider>(
      create: (_) => CourseProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    courseProvider.loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mario Kart Selector',
      initialRoute: '/',
      routes: {
        '/': (context) => SelectorScreen(),
        '/courses': (context) => CourseListScreen(),
      },
    );
  }
}

