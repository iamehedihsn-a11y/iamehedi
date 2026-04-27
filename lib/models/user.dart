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
