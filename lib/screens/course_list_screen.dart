// lib/screens/course_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  bool toggleAll = true;

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final courses = courseProvider.courses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Courses'),
        actions: [
          IconButton(
            icon: Icon(toggleAll ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: () {
              setState(() {
                toggleAll = !toggleAll;
                for (var course in courses) {
                  course.isActive = toggleAll;
                  if (toggleAll) {
                    int minSelection = courses
                        .map((c) => c.selectionCount)
                        .reduce((a, b) => a < b ? a : b);
                    course.selectionCount = minSelection;
                  }
                }
                courseProvider.saveCourses();
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return ListTile(
            title: Text(course.nom),
            subtitle: Text(
              'Coupe: ${course.coupe}\n'
              'Sélections: ${course.selectionCount}\n'
              'Dernière sélection: ${course.lastSelected != null ? course.lastSelected!.toLocal().toString().split(' ')[0] : 'Jamais'}',
            ),
            trailing: Switch(
              value: course.isActive,
              onChanged: (value) {
                setState(() {
                  course.isActive = value;
                  if (value) {
                    int minSelection = courses
                        .map((c) => c.selectionCount)
                        .reduce((a, b) => a < b ? a : b);
                    course.selectionCount = minSelection;
                  }
                  courseProvider.saveCourses();
                });
              },
            ),
          );
        },
      ),
    );
  }
}
