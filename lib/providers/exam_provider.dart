import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../services/api_service.dart';

class ExamProvider extends ChangeNotifier {
  List<Exam> _exams = [];
  bool _isLoading = false;
  String? _error;
  Map<String, String> _selectedAnswers = {};

  List<Exam> get exams => _exams;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, String> get selectedAnswers => _selectedAnswers;

  Future<void> fetchExams() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _exams = await ApiService.getExams();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _exams = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<Exam?> getExamById(String id) async {
    try {
      return await ApiService.getExamById(id);
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  void selectAnswer(String questionId, String answer) {
    _selectedAnswers[questionId] = answer;
    notifyListeners();
  }

  Future<bool> submitExam(String examId) async {
    try {
      return await ApiService.submitExam(examId, _selectedAnswers);
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  void clearExam() {
    _selectedAnswers = {};
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
