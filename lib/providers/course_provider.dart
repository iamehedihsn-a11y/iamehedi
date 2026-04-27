import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/api_service.dart';

class CourseProvider extends ChangeNotifier {
  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  bool _isLoading = false;
  String? _error;

  List<Course> get courses => _filteredCourses.isEmpty ? _courses : _filteredCourses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _courses = await ApiService.getCourses();
      _filteredCourses = [];
      _error = null;
    } catch (e) {
      _error = e.toString();
      _courses = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<Course?> getCourseById(String id) async {
    try {
      return await ApiService.getCourseById(id);
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  void searchCourses(String query) {
    if (query.isEmpty) {
      _filteredCourses = [];
    } else {
      _filteredCourses = _courses
          .where((course) =>
              course.title.toLowerCase().contains(query.toLowerCase()) ||
              course.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
