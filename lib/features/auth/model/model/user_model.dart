class User {
  final int? id;
  final String fullName;
  final String? gender;
  final String email;
  final String password;
  final String studentID;
  final int? academicLevel;
  final String? profilePhoto; // for profile

  User({
    this.id,
    required this.fullName,
    this.gender,
    required this.email,
    required this.password,
    required this.studentID,
    this.academicLevel,
    this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    return {

      'fullName': fullName,
      'gender': gender,
      'email': email,
      'password': password,
      'studentID': studentID,
      'academicLevel': academicLevel,
      'profilePhoto': profilePhoto,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'],
      gender: map['gender'],
      email: map['email'],
      password: map['password'],
      studentID: map['studentID'],
      academicLevel: map['academicLevel'],
      profilePhoto: map['profilePhoto'],
    );
  }
  User copyWith({
    int? id,
    String? fullName,
    String? gender,
    String? email,
    String? password,
    String? studentID,
    int? academicLevel,
    String? profilePhoto,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      password: password ?? this.password,
      studentID: studentID ?? this.studentID,
      academicLevel: academicLevel ?? this.academicLevel,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  //for api
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['idd'],
      fullName: json['full_name'],
      gender: json['gender'],
      email: json['email'],
      password: json['password'] ?? '',
      studentID: json['student_id'],
      academicLevel: json['level'],
      profilePhoto: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'password': password,
      'student_id': studentID,
      'gender': gender,
      'level': academicLevel,
      'profile_image': profilePhoto,
    };
  }
}