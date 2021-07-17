class Strings {
  const Strings._();
  factory Strings.init() {
    return Strings._();
  }

  final String appTitle = '体調管理';

  // カレンダー
  final String calenderPageTitle = '体調管理アプリ';
  final String calenderNoEvent = '予定なし';
  final String calenderUnRegisterLabel = 'この日の記録は未登録です。\nここをタップして記録しましょう。';
  final String calenderDetailConditionLabel = '体調: ';
  final String calenderDetailWalkingLabel = '散歩した';
  final String calenderDetailToiletLabel = '排便あり';
  final String calenderDetailInfoSeparator = '、';
  final String calenderDetailConditionMemoLabel = '【体調メモ】';

  // 記録ページ
  final String recordPageTitleDateFormat = 'yyyy年MM月dd日';
  final String recordConditionOverview = '今日の体調は？';
  final String recordWalkingLabel = '🚶‍♀️散歩した';
  final String recordToileLabel = '💩排便した';
  final String recordConditionMemoTitle = '体調メモ';
  final String recordConditionMemoHint = '細かい体調はこちらに記載しましょう！';
  final String recordConditionSaveButton = '体調情報を保存する';
  final String recordSaveButton = '保存する';
  final String recordCloseAttensionMessage = '内容が更新されていますが、保存せずに閉じてよろしいですか？';

  // 設定ページ
  final String settingsPageTitle = '設定';
  final String settingsNotLoginEmailLabel = '未ログイン';
  final String settingsNotLoginNameLabel = 'ー';
  final String settingsLoginInfo = '※Googleアカウントでログインできます。ログインするとデータのバックアップや復元ができます。';
  final String settingsLoginNameNotSettingLabel = '未設定';
  final String settingsLoginEmailNotSettingLabel = '未設定';
  final String settingsLoginWithGoogle = 'ログイン';
  final String settingsLogoutLabel = 'ログアウト';
  final String settingsChangeAppThemeLabel = 'テーマ切り替え';
  final String settingsAppVersionLabel = 'アプリバージョン';
  final String settingsBackupLabel = 'バックアップ';
  final String settingsBackupDetailLabel = 'データをリモートにバックアップします。';
  final String settingsBackupConfirmMessage = 'データをリモートにバックアップします。よろしいですか？';
  final String settingsBackupSuccessMessage = 'バックアップが完了しました！';
  final String settingsRestoreLabel = '復元';
  final String settingsRestoreDetailLabel = 'バックアップからデータを復元します。';
  final String settingsRestoreConfirmMessage = 'バックアップからデータを復元します。よろしいですか？\n注意！現在のデータは全て消えてしまいます。ご注意ください。';
  final String settingsRestoreSuccessMessage = '復元が完了しました！';

  // 体調
  final String conditionTypeBad = '悪い';
  final String conditionTypeNormal = '普通';
  final String conditionTypeGood = '良い';

  // ダイアログ
  final String dialogOk = 'OK';
  final String dialogCancel = 'キャンセル';
}
