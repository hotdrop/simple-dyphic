import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/record_repository.dart';
import 'package:simple_dyphic/ui/base_view_model.dart';

final calendarViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _CalendarViewModel(ref.read));

class _CalendarViewModel extends BaseViewModel {
  _CalendarViewModel(this._read) {
    _init();
  }

  final Reader _read;
  late List<Record> _records;
  List<Record> get records => _records;

  Future<void> _init() async {
    _records = await _read(recordRepositoryProvider).findAll();
    onSuccess();
  }

  Future<void> refresh() async {
    _records = await _read(recordRepositoryProvider).findAll();
    onSuccess();
  }
}
