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
