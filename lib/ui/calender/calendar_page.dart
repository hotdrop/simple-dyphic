import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';

import 'package:simple_dyphic/ui/calender/calendar_provider.dart';
import 'package:simple_dyphic/ui/record/record_page.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';
import 'package:simple_dyphic/ui/widget/condition_icon.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends ConsumerWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
      ),
      body: ref.watch(calendarControllerProvider).when(
            data: (_) => const _ViewBody(),
            error: (err, stackTrace) {
              _processOnError(context, '$err');
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            loading: () {
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

class _ViewBody extends StatelessWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _ViewCalendar(),
        SizedBox(height: 8.0),
        _ViewSelectedDayInfoCard(),
      ],
    );
  }
}

class _ViewCalendar extends ConsumerWidget {
  const _ViewCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datamap = ref.watch(calendarRecordsMapStateProvder);

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
      eventLoader: (dateTime) {
        return ref.read(calendarControllerProvider.notifier).getRecordForDay(datamap, dateTime);
      },
      calendarStyle: CalendarStyle(
        selectedDecoration: const BoxDecoration(
          color: Color(0xFF66CCFF),
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
        ref.read(calendarControllerProvider.notifier).onDaySelected(selectDate);
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

    if (record.condition != null) {
      markers.add(ConditionIcon.onCalendar(type: record.getConditionType()!, size: _calendarIconSize));
    } else {
      markers.add(const SizedBox(width: _calendarIconSize));
    }

    if (record.isToilet) {
      markers.add(const SizedBox(width: _calendarIconSize, child: Text('💩')));
    } else {
      markers.add(const SizedBox(width: _calendarIconSize));
    }

    if (record.isExercise) {
      markers.add(const SizedBox(width: _calendarIconSize, child: Text('🏃‍♂️')));
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
      ref.read(calendarControllerProvider.notifier).refresh(selectedRecord.id);
    }
  }
}

class _ViewContentsOnInfoCard extends StatelessWidget {
  const _ViewContentsOnInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
      return const Text('この日の記録は未登録です。\nここをタップして記録しましょう。');
    } else {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ViewMemoOnInfoCard(),
        ],
      );
    }
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
          const Text('【体調メモ】'),
          Text(memo, maxLines: 10, overflow: TextOverflow.ellipsis),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
