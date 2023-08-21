import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/service/firebase_auth.dart';

final firestoreProvider = Provider((ref) => _Firestore(ref));

class _Firestore {
  const _Firestore(this._ref);

  static const String _rootCollection = 'dyphic';
  static const String _recordRootCollection = 'records';
  static const String _recordBreakFastField = 'breakfast';
  static const String _recordLunchField = 'lunch';
  static const String _recordDinnerField = 'dinner';
  static const String _recordIsWalking = 'isWalking';
  static const String _recordIsToilet = 'isToilet';
  static const String _recordCondition = 'condition';
  static const String _recordConditionMemoField = 'conditionMemo';

  final Ref _ref;

  Future<List<Record>> findAll() async {
    try {
      final userId = _ref.read(firebaseAuthProvider).userId;
      if (userId == null) {
        AppLogger.d('未ログインなのでレコード情報は取得しません。');
        return [];
      }

      final snapshot = await FirebaseFirestore.instance //
          .collection(_rootCollection)
          .doc(userId)
          .collection(_recordRootCollection)
          .get();

      final records = <Record>[];
      for (var doc in snapshot.docs) {
        final map = doc.data();
        final record = Record.create(
          id: int.parse(doc.id),
          breakfast: _getString(map, _recordBreakFastField),
          lunch: _getString(map, _recordLunchField),
          dinner: _getString(map, _recordDinnerField),
          isWalking: _getBool(map, _recordIsWalking),
          isToilet: _getBool(map, _recordIsToilet),
          condition: _getString(map, _recordCondition),
          conditionMemo: _getString(map, _recordConditionMemoField),
        );
        records.add(record);
      }

      return records;
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: record情報の全件取得に失敗', e, s);
      rethrow;
    }
  }

  Future<void> saveAll(List<Record> records) async {
    final userId = _ref.read(firebaseAuthProvider).userId;
    if (userId == null) {
      AppLogger.d('未ログインなのでレコード情報は保存しません。');
      return;
    }

    for (var record in records) {
      await _save(userId, record);
    }
  }

  Future<void> save(Record record) async {
    final userId = _ref.read(firebaseAuthProvider).userId;
    if (userId == null) {
      AppLogger.d('未ログインなのでレコード情報は保存しません。');
      return;
    }
    await _save(userId, record);
  }

  Future<void> _save(String userId, Record record) async {
    try {
      final map = <String, dynamic>{};
      if (record.breakfast != null) map[_recordBreakFastField] = record.breakfast;
      if (record.lunch != null) map[_recordLunchField] = record.lunch;
      if (record.dinner != null) map[_recordDinnerField] = record.dinner;
      map[_recordIsWalking] = record.isWalking;
      map[_recordIsToilet] = record.isToilet;
      if (record.condition != null) map[_recordCondition] = record.condition;
      if (record.conditionMemo != null) map[_recordConditionMemoField] = record.conditionMemo;

      await FirebaseFirestore.instance
          .collection(_rootCollection)
          .doc(userId)
          .collection(_recordRootCollection)
          .doc(record.id.toString())
          .set(map, SetOptions(merge: true));
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: id=${record.id} の保持に失敗', e, s);
      rethrow;
    }
  }

  String _getString(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is String) {
      return fieldVal;
    } else {
      return '';
    }
  }

  bool _getBool(Map<String, dynamic>? map, String fieldName) {
    dynamic fieldVal = map?[fieldName] ?? 0;
    if (fieldVal is bool) {
      return fieldVal;
    } else {
      return false;
    }
  }
}
