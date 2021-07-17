import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/dyphic_id.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/record_repository.dart';
import 'package:simple_dyphic/ui/base_view_model.dart';

final calendarViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _CalendarViewModel(ref.read));

class _CalendarViewModel extends BaseViewModel {
  _CalendarViewModel(this._read) {
    _init();
  }

  final Reader _read;

  final Map<int, Record> _recordsMap = {};
  Map<int, Record> get recordsMap => _recordsMap;

  late DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate;

  late Record _selectedRecord;
  Record get selectedRecord => _selectedRecord;

  late DateTime _focusDate;
  DateTime get focusDate => _focusDate;

  Future<void> _init() async {
    final records = await _read(recordRepositoryProvider).findAll();
    _selectedRecord = Record.createEmpty(DateTime.now());

    final nowDate = DateTime.now();
    records.forEach((record) {
      _recordsMap[record.id] = record;
      if (record.isSameDay(nowDate)) {
        _selectedRecord = record;
      }
    });
    _focusDate = nowDate;
    _selectedDate = nowDate;

    onSuccess();
  }

  List<Record> getRecordForDay(DateTime date) {
    final id = DyphicID.makeRecordId(date);
    final event = _recordsMap[id];
    return event != null ? [event] : [];
  }

  void onDaySelected(DateTime selectDate, {Record? selectedItem}) {
    final id = DyphicID.makeRecordId(selectDate);
    _selectedRecord = _recordsMap[id] ?? Record.createEmpty(selectDate);
    _focusDate = selectDate;
    _selectedDate = selectDate;
    notifyListeners();
  }

  Future<void> refresh(int id) async {
    final updateRecord = await _read(recordRepositoryProvider).find(id);
    _recordsMap[id] = updateRecord;
    _selectedRecord = updateRecord;
    notifyListeners();
  }
}
