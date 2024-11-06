import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mario_kart_selector/models/course.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  Future<void> loadCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final coursesString = prefs.getString('courses');

    if (coursesString == null) {
      // Charger depuis le fichier JSON
      String data = await rootBundle.loadString('assets/courses.json');
      final jsonResult = json.decode(data);
      _courses = (jsonResult['courses'] as List)
          .map((course) => Course.fromJson(course))
          .toList();
      saveCourses();
    } else {
      // Charger depuis SharedPreferences
      final List<dynamic> decoded = json.decode(coursesString);
      _courses = decoded.map((course) => Course.fromJson(course)).toList();
    }
    notifyListeners();
  }

  void saveCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_courses.map((c) => c.toJson()).toList());
    prefs.setString('courses', encoded);
  }

  // Autres méthodes (sélection, activation, etc.)
}
