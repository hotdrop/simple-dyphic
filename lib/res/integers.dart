class Integers {
  Integers._({
    required this.settingsPageIconSize,
    required this.settingsPageAccountIconSize,
  });

  factory Integers.init() {
    return Integers._(
      settingsPageIconSize: 30,
      settingsPageAccountIconSize: 50,
    );
  }

  final double recordPageIconSize = 35;
  final double settingsPageIconSize;
  final double settingsPageAccountIconSize;
}
