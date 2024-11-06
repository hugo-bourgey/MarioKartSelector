// lib/screens/selector_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class SelectorScreen extends StatefulWidget {
  const SelectorScreen({super.key});

  @override
  _SelectorScreenState createState() => _SelectorScreenState();
}

class _SelectorScreenState extends State<SelectorScreen> {
  List<Course>? selectedCourses;

  void selectCourses() {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    List<Course> availableCourses =
        courseProvider.courses.where((course) => course.isActive).toList();

    // Trouver le nombre minimum de sélections
    int minSelection = availableCourses
        .map((course) => course.selectionCount)
        .reduce((a, b) => a < b ? a : b);

    // Filtrer les courses avec le nombre minimum de sélections
    List<Course> leastSelectedCourses = availableCourses
        .where((course) => course.selectionCount == minSelection)
        .toList();

    // Éviter de sélectionner une course déjà sélectionnée aujourd'hui
    DateTime today = DateTime.now();
    leastSelectedCourses = leastSelectedCourses.where((course) {
      return course.lastSelected == null ||
          course.lastSelected!.day != today.day ||
          course.lastSelected!.month != today.month ||
          course.lastSelected!.year != today.year;
    }).toList();

    // Sélectionner les courses
    List<Course> selection = [];

    if (leastSelectedCourses.length >= 4) {
      leastSelectedCourses.shuffle();
      selection = leastSelectedCourses.take(4).toList();
    } else {
      selection.addAll(leastSelectedCourses);
      List<Course> remainingCourses = availableCourses
          .where((course) => !selection.contains(course))
          .toList();
      remainingCourses.shuffle();
      selection.addAll(remainingCourses.take(4 - selection.length));
    }

    // Mettre à jour les compteurs et dates
    for (var course in selection) {
      course.selectionCount += 1;
      course.lastSelected = DateTime.now();
    }
    courseProvider.saveCourses();

    setState(() {
      selectedCourses = selection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélecteur de Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/courses');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Bouton toujours visible
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectCourses,
              child: const Text('Sélectionner 4 courses'),
            ),
          ),
          // Affichage de la liste des courses sélectionnées
          Expanded(
            child: selectedCourses == null || selectedCourses!.isEmpty
                ? const Center(
                    child: Text(
                      'Aucune course sélectionnée.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: selectedCourses!.length,
                    itemBuilder: (context, index) {
                      final course = selectedCourses![index];
                      return ListTile(
                        title: Text(course.nom),
                        subtitle: Text('Coupe: ${course.coupe}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
