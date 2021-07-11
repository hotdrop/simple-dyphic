class Integers {
  Integers._({
    required this.calendarIconSize,
    required this.recordPageIconSize,
    required this.settingsPageIconSize,
    required this.settingsPageAccountIconSize,
  });

  factory Integers.init() {
    return Integers._(
      calendarIconSize: 15,
      recordPageIconSize: 40,
      settingsPageIconSize: 30,
      settingsPageAccountIconSize: 50,
    );
  }

  final double calendarIconSize;
  final double recordPageIconSize;
  final double settingsPageIconSize;
  final double settingsPageAccountIconSize;
}
