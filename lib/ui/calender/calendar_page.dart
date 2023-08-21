import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';

import 'package:simple_dyphic/ui/calender/calendar_view_model.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/ui/record/record_page.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';
import 'package:simple_dyphic/ui/widget/app_icon.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends ConsumerWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(calendarViewModelProvider).uiState;

    return Scaffold(
      appBar: AppBar(
        title: Text(R.res.strings.calenderPageTitle),
      ),
      body: uiState.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        success: () {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: const [
              _ViewCalendar(),
              SizedBox(height: 8.0),
              _ViewSelectedDayInfoCard(),
            ],
          );
        },
        error: (err) {
          _processOnError(context, '$err');
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _processOnError(BuildContext context, String errMsg) {
    Future<void>.delayed(Duration.zero).then((_) {
      AppDialog.ok(message: errMsg).show(context);
    });
  }
}

class _ViewCalendar extends ConsumerWidget {
  const _ViewCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TableCalendar<Record>(
      firstDay: DateTime(2020, 11, 1),
      lastDay: DateTime(2030, 12, 31),
      focusedDay: ref.watch(calendarFocusDateStateProvider),
      selectedDayPredicate: (date) {
        final selectedDate = ref.read(calendarSelectedDateStateProvider);
        return isSameDay(selectedDate, date);
      },
      rangeSelectionMode: RangeSelectionMode.disabled,
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      locale: 'ja_JP',
      daysOfWeekHeight: 18.0, // デフォルト値の16だと日本語で見切れるのでちょっとふやす
      calendarFormat: CalendarFormat.month,
      eventLoader: ref.read(calendarViewModelProvider).getRecordForDay,
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: R.res.colors.selectCalender,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) => _ViewMarkers(events),
      ),
      onDaySelected: (selectDate, focusDate) {
        ref.read(calendarViewModelProvider).onDaySelected(selectDate);
      },
    );
  }
}

///
/// カレンダーの日付の下に表示するマーカーアイコンの処理
///
class _ViewMarkers extends StatelessWidget {
  const _ViewMarkers(this.records, {Key? key}) : super(key: key);

  final List<Record> records;
  static const double _calendarIconSize = 15;

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildMarker(),
      );
    } else {
      return const SizedBox();
    }
  }

  List<Widget> _buildMarker() {
    final markers = <Widget>[];

    final record = records.first;

    // 体調アイコン
    if (record.condition != null) {
      markers.add(ConditionIcon.onCalendar(type: record.getConditionType()!, size: _calendarIconSize));
    } else {
      markers.add(const SizedBox(width: _calendarIconSize));
    }

    // 排便マーク
    if (record.isToilet) {
      markers.add(const SizedBox(width: _calendarIconSize, child: Text('💩')));
    } else {
      markers.add(const SizedBox(width: _calendarIconSize));
    }

    // ウォーキングマーク
    if (record.isWalking) {
      markers.add(const SizedBox(width: _calendarIconSize, child: Text('🚶‍♀️')));
    } else {
      markers.add(const SizedBox(width: _calendarIconSize));
    }
    return markers;
  }
}

///
/// タップした日付の記録情報をカレンダーの下に表示する
///
class _ViewSelectedDayInfoCard extends ConsumerWidget {
  const _ViewSelectedDayInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4.0,
        child: InkWell(
          onTap: () async => await _onTap(context, ref),
          child: const _ViewContentsOnInfoCard(),
        ),
      ),
    );
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    final selectedRecord = ref.read(calendarSelectedRecordStateProvider);
    final isUpdate = await RecordPage.start(context, selectedRecord);
    AppLogger.d('記録ページから戻ってきました。${selectedRecord.id}の更新有無: $isUpdate');
    if (isUpdate) {
      ref.read(calendarViewModelProvider).refresh(selectedRecord.id);
    }
  }
}

class _ViewContentsOnInfoCard extends StatelessWidget {
  const _ViewContentsOnInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ViewHeaderOnInfoCard(),
              Divider(),
              _ViewDetailOnInfoCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewHeaderOnInfoCard extends ConsumerWidget {
  const _ViewHeaderOnInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = ref.watch(calendarSelectedRecordStateProvider).showFormatDate();
    return Center(
      child: Text(dateStr),
    );
  }
}

class _ViewDetailOnInfoCard extends ConsumerWidget {
  const _ViewDetailOnInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNotContents = ref.watch(calendarSelectedRecordStateProvider).notRegister();

    if (isNotContents) {
      return Text(R.res.strings.calenderUnRegisterLabel);
    } else {
      return Column(
        children: const [
          _ViewConditionOnInfoCard(),
          _ViewMemoOnInfoCard(),
        ],
      );
    }
  }
}

class _ViewConditionOnInfoCard extends ConsumerWidget {
  const _ViewConditionOnInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(calendarSelectedRecordStateProvider);
    final infoStr = _createLabel(record);

    if (infoStr.isNotEmpty) {
      return Column(
        children: [
          Text(infoStr),
          const SizedBox(height: 16),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  String _createLabel(Record record) {
    List<String> infos = [];

    if (record.condition != null) {
      infos.add('${R.res.strings.calenderDetailConditionLabel}${record.condition}');
    }
    if (record.isWalking) {
      infos.add(R.res.strings.calenderDetailWalkingLabel);
    }
    if (record.isToilet) {
      infos.add(R.res.strings.calenderDetailToiletLabel);
    }
    if (infos.isNotEmpty) {
      return infos.join(R.res.strings.calenderDetailInfoSeparator);
    }
    return '';
  }
}

class _ViewMemoOnInfoCard extends ConsumerWidget {
  const _ViewMemoOnInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memo = ref.watch(calendarSelectedRecordStateProvider).conditionMemo;

    if (memo != null && memo.isNotEmpty) {
      return Column(
        children: [
          Text(R.res.strings.calenderDetailConditionMemoLabel),
          Text(memo, maxLines: 10, overflow: TextOverflow.ellipsis),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
