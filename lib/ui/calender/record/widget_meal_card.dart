import 'package:flutter/material.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/ui/calender/record/widget_meal_edit_dialog.dart';

enum MealType { morning, lunch, dinner }

class MealCard extends StatelessWidget {
  const MealCard({
    required this.type,
    this.detail,
    required this.onEditValue,
  });

  final MealType type;
  final String? detail;
  final Function(String?) onEditValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Card(
        shadowColor: _shadowColorEachType(),
        elevation: 4.0,
        child: InkWell(
          onTap: () async {
            String dialogTitle = _dialogTitle();
            final inputValue = await showDialog<String>(
              context: context,
              builder: (context) => MealEditDialog(title: dialogTitle, initValue: detail),
            );
            onEditValue(inputValue);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _titleIcon(),
                _detailLabel(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _shadowColorEachType() {
    switch (type) {
      case MealType.morning:
        return R.res.colors.mealBreakFast;
      case MealType.lunch:
        return R.res.colors.mealLunch;
      case MealType.dinner:
        return R.res.colors.mealDinner;
    }
  }

  Widget _titleIcon() {
    String iconPath;
    switch (type) {
      case MealType.morning:
        iconPath = R.res.images.breakfast;
        break;
      case MealType.lunch:
        iconPath = R.res.images.lunch;
        break;
      case MealType.dinner:
        iconPath = R.res.images.dinner;
        break;
    }

    return Center(child: Image.asset(iconPath));
  }

  Widget _detailLabel(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          detail ?? '',
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  String _dialogTitle() {
    switch (type) {
      case MealType.morning:
        return R.res.strings.recordMorningDialogTitle;
      case MealType.lunch:
        return R.res.strings.recordLunchDialogTitle;
      default:
        return R.res.strings.recordDinnerDialogTitle;
    }
  }
}
