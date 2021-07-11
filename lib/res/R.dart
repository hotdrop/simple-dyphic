import 'package:simple_dyphic/res/colors.dart';
import 'package:simple_dyphic/res/images.dart';
import 'package:simple_dyphic/res/strings.dart';

class R {
  R._({
    required this.strings,
    required this.images,
    required this.colors,
  });

  factory R.init() {
    res = R._(
      strings: Strings.init(),
      images: Images.init(),
      colors: AppColors.init(),
    );
    return res;
  }

  static late R res;

  final Strings strings;
  final Images images;
  final AppColors colors;
}
