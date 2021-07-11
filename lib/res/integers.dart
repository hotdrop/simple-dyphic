class Integers {
  Integers._({
    required this.calendarIconSize,
    required this.completeStepNum,
  });

  factory Integers.init() {
    return Integers._(
      calendarIconSize: 15,
      completeStepNum: 5000,
    );
  }

  final double calendarIconSize;
  final int completeStepNum;
}
