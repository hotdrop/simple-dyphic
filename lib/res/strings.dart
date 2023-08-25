class Strings {
  const Strings._();

  static const String appTitle = '体調管理';

  // カレンダー
  static const String calenderPageTitle = 'カレンダー';
  static const String calenderNoEvent = '予定なし';

  // 記録ページ
  static const String recordPageTitleDateFormat = 'yyyy年MM月dd日';
  static const String recordConditionOverview = '今日の体調は？';
  static const String recordWalkingLabel = '🚶‍♀️散歩した';
  static const String recordToileLabel = '💩排便した';
  static const String recordConditionMemoTitle = '体調メモ';
  static const String recordConditionMemoHint = '細かい体調はこちらに記載しましょう！';
  static const String recordConditionSaveButton = '体調情報を保存する';
  static const String recordSaveButton = '保存する';
  static const String recordCloseAttensionMessage = '内容が更新されていますが、保存せずに閉じてよろしいですか？';

  // 設定ページ
  static const String settingsPageTitle = '設定';
  static const String settingsNotLoginEmailLabel = '未サインイン';
  static const String settingsNotLoginNameLabel = 'ー';
  static const String settingsLoginInfo = '※Googleアカウントでサインインできます。サインインするとデータのバックアップや復元ができます。';
  static const String settingsLoginWithGoogle = 'Googleアカウントでサインインする';
  static const String settingsLogoutLabel = 'Googleアカウントからサインアウトする';
  static const String settingsSignOutDialogMessage = 'Googleアカウントからサインアウトします。よろしいですか？';
  static const String settingsLicenseLavel = 'バージョンとライセンス';
  static const String settingsBackupLabel = 'バックアップ';
  static const String settingsBackupDetailLabel = 'データをリモートにバックアップします。';
  static const String settingsBackupConfirmMessage = 'データをリモートにバックアップします。よろしいですか？';
  static const String settingsBackupSuccessMessage = 'バックアップが完了しました！';
  static const String settingsRestoreLabel = '復元';
  static const String settingsRestoreDetailLabel = 'バックアップからデータを復元します。';
  static const String settingsRestoreConfirmMessage = 'バックアップからデータを復元します。よろしいですか？\n注意！現在のデータは全て消えてしまいます。ご注意ください。';
  static const String settingsRestoreSuccessMessage = '復元が完了しました！';

  // 体調
  static const String conditionTypeBad = '悪い';
  static const String conditionTypeNormal = '普通';
  static const String conditionTypeGood = '良い';

  // ダイアログ
  static const String dialogOk = 'OK';
  static const String dialogCancel = 'キャンセル';
}
