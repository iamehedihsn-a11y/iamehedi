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
