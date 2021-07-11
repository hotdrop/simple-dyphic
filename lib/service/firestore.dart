import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/service/firebase_auth.dart';

final firestoreProvider = Provider((ref) => _Firestore(ref.read));
final _firestore = Provider((ref) => FirebaseFirestore.instance);

class _Firestore {
  const _Firestore(this._read);

  static final String _rootCollection = 'dyphic';
  static final String _recordRootCollection = 'records';
  static final String _recordBreakFastField = 'breakfast';
  static final String _recordLunchField = 'lunch';
  static final String _recordDinnerField = 'dinner';
  static final String _recordIsWalking = 'isWalking';
  static final String _recordIsToilet = 'isToilet';
  static final String _recordCondition = 'condition';
  static final String _recordConditionMemoField = 'conditionMemo';

  final Reader _read;

  Future<List<Record>> findAll() async {
    try {
      final userId = _read(firebaseAuthProvider)?.uid;
      if (userId == null) {
        AppLogger.d('未ログインなのでレコード情報は取得しません。');
        return [];
      }
      final snapshot = await _read(_firestore).collection(_rootCollection).doc(userId).collection(_recordRootCollection).get();
      return snapshot.docs.map((doc) {
        final map = doc.data();
        return Record.create(
          id: int.parse(doc.id),
          breakfast: _getString(map, _recordBreakFastField),
          lunch: _getString(map, _recordLunchField),
          dinner: _getString(map, _recordDinnerField),
          isWalking: _getBool(map, _recordIsWalking),
          isToilet: _getBool(map, _recordIsToilet),
          condition: _getString(map, _recordCondition),
          conditionMemo: _getString(map, _recordConditionMemoField),
        );
      }).toList();
    } on FirebaseException catch (e, s) {
      await AppLogger.e('Firestore: record情報の全件取得に失敗', e, s);
      rethrow;
    }
  }

  Future<void> saveAll(List<Record> records) async {
    final userId = _read(firebaseAuthProvider)?.uid;
    if (userId == null) {
      AppLogger.d('未ログインなのでレコード情報は保存しません。');
      return;
    }
    records.forEach((r) async => await _save(userId, r));
  }

  Future<void> save(Record record) async {
    final userId = _read(firebaseAuthProvider)?.uid;
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

  // ここから下はMapとDocumentSnapshotから型情報ありで取りたい場合の便利メソッド
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
