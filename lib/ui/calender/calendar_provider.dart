import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_dyphic/model/dyphic_id.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/record_repository.dart';

part 'calendar_provider.g.dart';

@riverpod
class CalendarController extends _$CalendarController {
  @override
  Future<void> build() async {
    final records = await ref.read(recordRepositoryProvider).findAll();

    final recordsMap = <int, Record>{};
    final nowDate = DateTime.now();
    for (var record in records) {
      recordsMap[record.id] = record;

      if (record.isSameDay(nowDate)) {
        ref.read(calendarSelectedRecordStateProvider.notifier).state = record;
      }
    }

    ref.read(calendarRecordsMapStateProvder.notifier).state = recordsMap;
  }

  List<Record> getRecordForDay(DateTime date) {
    final id = DyphicID.makeRecordId(date);
    final event = ref.read(calendarRecordsMapStateProvder)[id];
    return event != null ? [event] : [];
  }

  void onDaySelected(DateTime selectDate, {Record? selectedItem}) {
    final id = DyphicID.makeRecordId(selectDate);
    ref.read(calendarSelectedRecordStateProvider.notifier).state = ref.read(calendarRecordsMapStateProvder)[id] ?? Record.createEmpty(selectDate);
    ref.read(calendarFocusDateStateProvider.notifier).state = selectDate;
    ref.read(calendarSelectedDateStateProvider.notifier).state = selectDate;
  }

  Future<void> refresh(int id) async {
    final updateRecord = await ref.read(recordRepositoryProvider).find(id);
    final newRecordsMap = {...ref.read(calendarRecordsMapStateProvder)};
    newRecordsMap[id] = updateRecord;
    ref.read(calendarRecordsMapStateProvder.notifier).state = newRecordsMap;
    ref.read(calendarSelectedRecordStateProvider.notifier).state = updateRecord;
  }
}

// カレンダーの記録データ
final calendarRecordsMapStateProvder = StateProvider<Map<int, Record>>((ref) => {});

// 選択した日付の記録データ
final calendarSelectedRecordStateProvider = StateProvider<Record>((ref) {
  return Record.createEmpty(DateTime.now());
});

// 選択した日付
final calendarSelectedDateStateProvider = StateProvider<DateTime>((_) => DateTime.now());

// フォーカスが当たっている日付
final calendarFocusDateStateProvider = StateProvider<DateTime>((_) => DateTime.now());
