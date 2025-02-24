class UserProfile {
  final int? age;
  final double? height;

  UserProfile({this.age, this.height});

  bool isEmpty() {
    return age == null || height == null;
  }

  UserProfile copyWith({
    int? age,
    double? height,
  }) {
    return UserProfile(
      age: age ?? this.age,
      height: height ?? this.height,
    );
  }
}
