import 'package:flutter/material.dart';
import 'package:simple_dyphic/model/dyphic_id.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/ui/calender/record/record_page.dart';
import 'package:table_calendar/table_calendar.dart';

class DyphicCalendar extends StatefulWidget {
  const DyphicCalendar({required this.records, required this.onReturnEditPage});

  final List<Record> records;
  final void Function(bool isUpdate) onReturnEditPage;

  @override
  _DyphicCalendarState createState() => _DyphicCalendarState();
}

class _DyphicCalendarState extends State<DyphicCalendar> {
  final Map<int, Record> _records = {};

  DateTime _focusDate = DateTime.now();
  DateTime? _selectedDate;
  Record _selectedRecord = Record.createEmpty(DateTime.now());

  @override
  void initState() {
    super.initState();
    final nowDate = DateTime.now();
    widget.records.forEach((record) {
      _records[record.id] = record;
      if (record.isSameDay(nowDate)) {
        _selectedRecord = record;
      }
    });
    _selectedDate = _focusDate;
  }

  List<Record> _getRecordForDay(DateTime date) {
    final id = DyphicID.makeRecordId(date);
    final event = _records[id];
    return event != null ? [event] : [];
  }

  void _onDaySelected(DateTime date, {Record? selectedItem}) {
    setState(() {
      _focusDate = date;
      _selectedDate = date;
      _selectedRecord = selectedItem ?? Record.createEmpty(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildCalendar(context),
        const SizedBox(height: 8.0),
        _cardDailyRecord(context),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return TableCalendar<Record>(
      firstDay: DateTime(2020, 11, 1),
      lastDay: DateTime(2030, 12, 31),
      focusedDay: _focusDate,
      selectedDayPredicate: (date) => isSameDay(_selectedDate, date),
      rangeSelectionMode: RangeSelectionMode.disabled,
      headerStyle: HeaderStyle(formatButtonVisible: false),
      locale: 'ja_JP',
      daysOfWeekHeight: 18.0, // デフォルト値の16だと日本語で見切れるのでちょっとふやす
      calendarFormat: CalendarFormat.month,
      eventLoader: _getRecordForDay,
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.deepOrange.withAlpha(70),
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      calendarBuilders: CalendarBuilders(markerBuilder: (context, date, events) => _buildMarker(events)),
      onDaySelected: (selectDate, focusDate) {
        final id = DyphicID.makeRecordId(selectDate);
        if (_records.containsKey(id)) {
          final record = _records[id];
          _onDaySelected(selectDate, selectedItem: record);
        } else {
          _onDaySelected(selectDate);
        }
      },
    );
  }

  ///
  /// カレンダーの日付の下に表示するマーカーアイコンの処理
  ///
  Widget _buildMarker(List<Record> argRecords) {
    final markers = <Widget>[];

    if (argRecords.isEmpty) {
      return SizedBox();
    }

    final record = argRecords.first;
    // TODO 体調のアイコン
    // if (record.typeMedical()) {
    //   markers.add(Image.asset(
    //     'res/images/ic_hospital.png',
    //     width: R.res.integers.calendarIconSize,
    //     height: R.res.integers.calendarIconSize,
    //   ));
    // } else {
    //   markers.add(SizedBox(width: R.res.integers.calendarIconSize));
    // }

    // TODO 排便アイコン
    // if (record.typeInjection()) {
    //   markers.add(Image.asset(
    //     'res/images/ic_inject.png',
    //     width: R.res.integers.calendarIconSize,
    //     height: R.res.integers.calendarIconSize,
    //   ));
    // } else {
    //   markers.add(SizedBox(width: R.res.integers.calendarIconSize));
    // }

    // ウォーキングアイコン
    if (record.isWalking ?? false) {
      markers.add(Icon(Icons.directions_walk, size: R.res.integers.calendarIconSize, color: R.res.colors.walking));
    } else {
      markers.add(SizedBox(width: R.res.integers.calendarIconSize));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: markers,
    );
  }

  ///
  /// タップした日付の記録情報をカレンダーの下に表示する
  ///
  Widget _cardDailyRecord(BuildContext context) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        elevation: 4.0,
        child: InkWell(
          onTap: () async {
            final isUpdate = await RecordPage.start(context, _selectedRecord);
            widget.onReturnEditPage(isUpdate);
          },
          child: _detailDailyRecord(context),
        ),
      ),
    );
  }

  Widget _detailDailyRecord(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelRecordInfo(),
          ],
        ),
      ),
    );
  }

  Widget _labelRecordInfo() {
    final widgets = <Widget>[];

    if (!_selectedRecord.notRegister()) {
      // 体調の詳細
      if (_selectedRecord.condition != null) {
        widgets.add(Text(_selectedRecord.condition!));
        widgets.add(SizedBox(height: 8.0));
      }

      // 散歩
      if (_selectedRecord.isWalking ?? false) {
        widgets.add(Text(R.res.strings.calenderDetailWalkingLabel, style: TextStyle(color: R.res.colors.walking)));
        widgets.add(SizedBox(height: 8.0));
      }

      // 体調メモ
      final memo = _selectedRecord.conditionMemo;
      if (memo != null) {
        widgets.add(Text(R.res.strings.calenderDetailConditionMemoLabel));
        widgets.add(_labelMemo(memo));
      }
    } else {
      widgets.add(Text(R.res.strings.calenderUnRegisterLabel));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _labelMemo(String memo) {
    return Text(
      '$memo',
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
    );
  }
}
