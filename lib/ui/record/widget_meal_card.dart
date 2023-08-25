import 'package:flutter/material.dart';
import 'package:simple_dyphic/res/images.dart';

enum MealType { morning, lunch, dinner }

class MealCard extends StatelessWidget {
  const MealCard._(
    this._iconPath,
    this._shadowColor,
    this._initValue,
    this._onChanged,
  );

  factory MealCard.breakfast({String? initValue, required Function(String?) onChanged}) {
    return MealCard._(Images.breakfastPath, const Color(0xFFFA6B72), initValue, onChanged);
  }

  factory MealCard.lunch({String? initValue, required Function(String?) onChanged}) {
    return MealCard._(Images.lunchPath, const Color(0xFFFCA41F), initValue, onChanged);
  }

  factory MealCard.dinner({String? initValue, required Function(String?) onChanged}) {
    return MealCard._(Images.dinnerPath, const Color(0xFF3D2EAD), initValue, onChanged);
  }

  final String _iconPath;
  final Color _shadowColor;
  final String? _initValue;
  final Function(String?) _onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
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
      maxLines: 5,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 14),
      ),
      onChanged: (String? v) {
        _onChanged(v);
      },
    );
  }
}
