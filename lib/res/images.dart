class Images {
  Images._({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory Images.init() {
    return Images._(
      breakfast: 'assets/images/ic_breakfast.png',
      lunch: 'assets/images/ic_breakfast.png',
      dinner: 'assets/images/ic_breakfast.png',
    );
  }

  final String breakfast;
  final String lunch;
  final String dinner;
}
