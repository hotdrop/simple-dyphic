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

class CalenderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.res.strings.calenderPageTitle),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final uiState = watch(calendarViewModelProvider).uiState;
          return uiState.when(
            loading: () => _onLoading(),
            success: () => _onSuccess(context),
            error: (err) => _onError(context, '$err'),
          );
        },
      ),
    );
  }

  Widget _onLoading() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _onError(BuildContext context, String errMsg) {
    Future<void>.delayed(Duration.zero).then((_) {
      AppDialog.ok(message: errMsg).show(context);
    });
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context) {
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
      focusedDay: context.read(calendarViewModelProvider).focusDate,
      selectedDayPredicate: (date) => isSameDay(context.read(calendarViewModelProvider).selectedDate, date),
      rangeSelectionMode: RangeSelectionMode.disabled,
      headerStyle: HeaderStyle(formatButtonVisible: false),
      locale: 'ja_JP',
      daysOfWeekHeight: 18.0, // デフォルト値の16だと日本語で見切れるのでちょっとふやす
      calendarFormat: CalendarFormat.month,
      eventLoader: context.read(calendarViewModelProvider).getRecordForDay,
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
      calendarBuilders: CalendarBuilders(markerBuilder: (context, date, events) => _buildMarker(events)),
      onDaySelected: (selectDate, focusDate) {
        context.read(calendarViewModelProvider).onDaySelected(selectDate);
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
    final double calendarIconSize = 15;

    // 体調アイコン
    if (record.condition != null) {
      markers.add(ConditionIcon.onCalendar(type: record.getConditionType()!, size: calendarIconSize));
    } else {
      markers.add(SizedBox(width: calendarIconSize));
    }

    // 排便マーク
    if (record.isToilet) {
      markers.add(SizedBox(width: calendarIconSize, child: Text('💩')));
    } else {
      markers.add(SizedBox(width: calendarIconSize));
    }

    // ウォーキングマーク
    if (record.isWalking) {
      markers.add(SizedBox(width: calendarIconSize, child: Text('🚶‍♀️')));
    } else {
      markers.add(SizedBox(width: calendarIconSize));
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4.0,
        child: InkWell(
          onTap: () async {
            final selectedRecord = context.read(calendarViewModelProvider).selectedRecord;
            final isUpdate = await RecordPage.start(context, selectedRecord);
            AppLogger.d('記録ページから戻ってきました。${selectedRecord.id}の更新有無: $isUpdate');
            if (isUpdate) {
              context.read(calendarViewModelProvider).refresh(selectedRecord.id);
            }
          },
          child: _viewSelectedRecordDetail(context),
        ),
      ),
    );
  }

  Widget _viewSelectedRecordDetail(BuildContext context) {
    final selectedRecord = context.read(calendarViewModelProvider).selectedRecord;
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _viewTitleOnDetail(selectedRecord),
              Divider(),
              ..._viewContentsOnDetail(selectedRecord),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewTitleOnDetail(Record selectedRecord) {
    return Center(child: Text('${selectedRecord.showFormatDate()}'));
  }

  List<Widget> _viewContentsOnDetail(Record selectedRecord) {
    List<Widget> widgets = [];

    if (selectedRecord.notRegister()) {
      widgets.add(Text(R.res.strings.calenderUnRegisterLabel));
      return widgets;
    }

    final infoStr = selectedRecord.getInfoJoinStr();
    if (infoStr.isNotEmpty) {
      widgets.add(Text(infoStr));
      widgets.add(SizedBox(height: 16));
    }

    final memo = selectedRecord.conditionMemo;
    if (memo != null && memo.isNotEmpty) {
      widgets.add(Text(R.res.strings.calenderDetailConditionMemoLabel));
      widgets.add(_labelMemo(memo));
    }

    // 体調メモ
    return widgets;
  }

  Widget _labelMemo(String memo) {
    return Text(
      '$memo',
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
    );
  }
}
