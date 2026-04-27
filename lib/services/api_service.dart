import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/course.dart';
import '../models/exam.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://your-api.com/api'; // Change this to your API

  // ===== COURSES API =====
  static Future<List<Course>> getCourses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Course.fromJson(data)).toList();
      }
      throw Exception('Failed to load courses');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Course> getCourseById(String courseId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses/$courseId'));
      if (response.statusCode == 200) {
        return Course.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to load course');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ===== EXAMS API =====
  static Future<List<Exam>> getExams() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/exams'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Exam.fromJson(data)).toList();
      }
      throw Exception('Failed to load exams');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Exam> getExamById(String examId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/exams/$examId'));
      if (response.statusCode == 200) {
        return Exam.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to load exam');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> submitExam(String examId, Map<String, String> answers) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/exams/$examId/submit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'answers': answers}),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ===== USER API =====
  static Future<User> getUserProfile() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/profile'));
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to load user');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ===== PAYMENT API =====
  static Future<bool> processPayment(String courseId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments/process'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'courseId': courseId, 'amount': amount}),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ===== STUDY MATERIALS API =====
  static Future<List<dynamic>> getStudyMaterials(String courseId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses/$courseId/materials'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load materials');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
