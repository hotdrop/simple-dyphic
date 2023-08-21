import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/dyphic_id.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/record_repository.dart';
import 'package:simple_dyphic/ui/base_view_model.dart';

final calendarViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _CalendarViewModel(ref));

// 選択した日付の記録データ
final calendarSelectedRecordStateProvider = StateProvider<Record>((ref) {
  return Record.createEmpty(DateTime.now());
});

// 選択した日付
final calendarSelectedDateStateProvider = StateProvider<DateTime>((_) {
  return DateTime.now();
});

// フォーカスが当たっている日付
final calendarFocusDateStateProvider = StateProvider<DateTime>((_) {
  return DateTime.now();
});

///
/// ViewModel
///
class _CalendarViewModel extends BaseViewModel {
  _CalendarViewModel(this._ref) {
    _init();
  }

  final Ref _ref;

  final Map<int, Record> _recordsMap = {};
  Map<int, Record> get recordsMap => _recordsMap;

  Future<void> _init() async {
    final records = await _ref.read(recordRepositoryProvider).findAll();

    final nowDate = DateTime.now();
    for (var record in records) {
      _recordsMap[record.id] = record;

      if (record.isSameDay(nowDate)) {
        _ref.read(calendarSelectedRecordStateProvider.notifier).state = record;
      }
    }

    onSuccess();
  }

  List<Record> getRecordForDay(DateTime date) {
    final id = DyphicID.makeRecordId(date);
    final event = _recordsMap[id];
    return event != null ? [event] : [];
  }

  void onDaySelected(DateTime selectDate, {Record? selectedItem}) {
    final id = DyphicID.makeRecordId(selectDate);
    _ref.read(calendarSelectedRecordStateProvider.notifier).state = _recordsMap[id] ?? Record.createEmpty(selectDate);
    _ref.read(calendarFocusDateStateProvider.notifier).state = selectDate;
    _ref.read(calendarSelectedDateStateProvider.notifier).state = selectDate;
  }

  Future<void> refresh(int id) async {
    final updateRecord = await _ref.read(recordRepositoryProvider).find(id);
    _recordsMap[id] = updateRecord;
    _ref.read(calendarSelectedRecordStateProvider.notifier).state = updateRecord;
    notifyListeners();
  }
}
