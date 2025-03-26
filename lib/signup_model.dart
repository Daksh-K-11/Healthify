class UserProfile {
  final String fullName;
  final String password;
  final String phoneNumber;
  final String dob;
  final String gender;
  final String height;
  final String weight;
  final String city;
  final String medicalHistory;
  final String geneticPredisposition;
  final String smoking;
  final String drinking;
  final String sleepingHours;
  final String exerciseHours;

  UserProfile({
    required this.fullName,
    required this.password,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.height,
    required this.weight,
    required this.city,
    required this.medicalHistory,
    required this.geneticPredisposition,
    required this.smoking,
    required this.drinking,
    required this.sleepingHours,
    required this.exerciseHours,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json['full_name'],
      password: json['password'],
      phoneNumber: json['phone_number'],
      dob: json['dob'],
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      city: json['city'],
      medicalHistory: json['medical_history'],
      geneticPredisposition: json['genetic_predisposition'],
      smoking: json['smoking'],
      drinking: json['drinking'],
      sleepingHours: json['sleeping_hours'],
      exerciseHours: json['exercise_hours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'password': password,
      'phone_number': phoneNumber,
      'dob': dob,
      'gender': gender,
      'height': height,
      'weight': weight,
      'city': city,
      'medical_history': medicalHistory,
      'genetic_predisposition': geneticPredisposition,
      'smoking': smoking,
      'drinking': drinking,
      'sleeping_hours': sleepingHours,
      'exercise_hours': exerciseHours,
    };
  }
}
