import 'package:flutter/material.dart';
import 'package:simple_dyphic/res/R.dart';

enum MealType { morning, lunch, dinner }

class MealCard extends StatelessWidget {
  const MealCard._(
    this._iconPath,
    this._shadowColor,
    this._initValue,
    this._onChanged,
  );

  factory MealCard.breakfast({String? initValue, required Function(String?) onChanged}) {
    return MealCard._(R.res.images.breakfast, R.res.colors.mealBreakFast, initValue, onChanged);
  }

  factory MealCard.lunch({String? initValue, required Function(String?) onChanged}) {
    return MealCard._(R.res.images.lunch, R.res.colors.mealLunch, initValue, onChanged);
  }

  factory MealCard.dinner({String? initValue, required Function(String?) onChanged}) {
    return MealCard._(R.res.images.dinner, R.res.colors.mealDinner, initValue, onChanged);
  }

  final String _iconPath;
  final Color _shadowColor;
  final String? _initValue;
  final Function(String?) _onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Card(
        shadowColor: _shadowColor,
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _titleIcon(),
              _editField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleIcon() {
    return Center(
      child: Image.asset(_iconPath),
    );
  }

  Widget _editField(BuildContext context) {
    return TextFormField(
      initialValue: _initValue,
      maxLines: 3,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
      ),
      onChanged: (String? v) {
        _onChanged(v);
      },
    );
  }
}
