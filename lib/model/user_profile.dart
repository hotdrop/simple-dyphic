class UserProfile {
  final DateTime? birthDate;
  final double? height;
  final double? weight;

  UserProfile({this.birthDate, this.height, this.weight});

  bool isEmpty() {
    return birthDate == null || height == null || weight == null;
  }

  UserProfile copyWith({
    DateTime? birthDate,
    double? height,
    double? weight,
  }) {
    return UserProfile(
      birthDate: birthDate ?? this.birthDate,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }
}
