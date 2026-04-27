import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ==================== MODELS ====================

class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final double price;
  final List<String> videoUrls;
  final double rating;
  final int students;
  final String duration;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.price,
    required this.videoUrls,
    this.rating = 0.0,
    this.students = 0,
    this.duration = '0 hours',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown',
      description: json['description'] ?? '',
      instructor: json['instructor'] ?? 'Unknown',
      price: (json['price'] ?? 0).toDouble(),
      videoUrls: List<String>.from(json['videoUrls'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      students: json['students'] ?? 0,
      duration: json['duration'] ?? '0 hours',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'instructor': instructor,
    'price': price,
    'videoUrls': videoUrls,
    'rating': rating,
    'students': students,
    'duration': duration,
  };
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'options': options,
    'correctAnswer': correctAnswer,
  };
}

class Exam {
  final String id;
  final String title;
  final String description;
  final int duration;
  final int totalQuestions;
  final int passingScore;
  final List<Question> questions;

  Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.totalQuestions,
    required this.passingScore,
    required this.questions,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 60,
      totalQuestions: json['totalQuestions'] ?? 0,
      passingScore: json['passingScore'] ?? 40,
      questions: (json['questions'] as List?)
          ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'duration': duration,
    'totalQuestions': totalQuestions,
    'passingScore': passingScore,
    'questions': questions.map((q) => q.toJson()).toList(),
  };
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final List<String> enrolledCourses;
  final double totalSpent;
  final String joinDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage = '',
    this.enrolledCourses = const [],
    this.totalSpent = 0.0,
    this.joinDate = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      enrolledCourses: List<String>.from(json['enrolledCourses'] ?? []),
      totalSpent: (json['totalSpent'] ?? 0).toDouble(),
      joinDate: json['joinDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'profileImage': profileImage,
    'enrolledCourses': enrolledCourses,
    'totalSpent': totalSpent,
    'joinDate': joinDate,
  };
}

// ==================== API SERVICE ====================

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

// ==================== PROVIDERS ====================

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

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await ApiService.getUserProfile();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final success = await ApiService.updateUserProfile(userData);
      if (success) {
        await fetchUserProfile();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  Future<bool> processPayment(String courseId, double amount) async {
    try {
      return await ApiService.processPayment(courseId, amount);
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}

// ==================== MAIN APP ====================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => ExamProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Polytechnic Coaching',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          textTheme: GoogleFonts.kalamTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<CourseProvider>().fetchCourses();
    context.read<ExamProvider>().fetchExams();
    context.read<UserProvider>().fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polytechnic Coaching'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Courses Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'কোর্স সমূহ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Consumer<CourseProvider>(
                    builder: (context, courseProvider, _) {
                      if (courseProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (courseProvider.error != null) {
                        return Center(
                          child: Text('Error: ${courseProvider.error}'),
                        );
                      }
                      if (courseProvider.courses.isEmpty) {
                        return const Center(child: Text('No courses available'));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: courseProvider.courses.length,
                        itemBuilder: (context, index) {
                          final course = courseProvider.courses[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    course.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '৳${course.price}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Implement course enrollment
                                        },
                                        child: const Text('এনরোল করুন'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            // Exams Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'পরীক্ষাসমূহ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Consumer<ExamProvider>(
                    builder: (context, examProvider, _) {
                      if (examProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (examProvider.error != null) {
                        return Center(child: Text('Error: ${examProvider.error}'));
                      }
                      if (examProvider.exams.isEmpty) {
                        return const Center(child: Text('No exams available'));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: examProvider.exams.length,
                        itemBuilder: (context, index) {
                          final exam = examProvider.exams[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exam.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'সময়: ${exam.duration} মিনিট | প্রশ্ন: ${exam.totalQuestions}',
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Implement exam start
                                    },
                                    child: const Text('পরীক্ষা শুরু করুন'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
