class Strings {
  const Strings._();
  factory Strings.init() {
    return Strings._();
  }

  final String appTitle = '体調管理';

  final String calenderPageTitle = 'カレンダー';
  final String calenderNoEvent = '予定なし';
  final String calenderUnRegisterLabel = 'この日の記録は未登録です。\nここをタップして記録しましょう。';
  final String calenderDetailWalkingLabel = '散歩した';
  final String calenderDetailConditionMemoLabel = '【体調メモ】';

  // 記録ページ
  final String recordPageTitleDateFormat = 'yyyy年MM月dd日';
  final String recordMorningDialogTitle = '朝食';
  final String recordLunchDialogTitle = '昼食';
  final String recordDinnerDialogTitle = '夕食';
  final String recordMealDialogHint = '食事の内容(簡単に)';

  final String recordConditionOverview = '今日の体調を選んでください。';
  final String recordWalkingLabel = '散歩した';
  final String recordUncoLabel = '排便した';
  final String recordConditionMemoTitle = '体調メモ';
  final String recordConditionMemoHint = '細かい体調はこちらに記載しましょう！';
  final String recordConditionSaveButton = '体調情報を保存する';

  final String recordMemoTitle = '今日のメモ';
  final String recordMemoHint = 'その他、残しておきたい記録があったらここに記載してください。';
  final String recordMemoSaveButton = 'メモを保存する';

  // 設定ページ
  final String settingsPageTitle = '設定';
  final String settingsNotLoginEmailLabel = '未ログイン';
  final String settingsNotLoginNameLabel = 'ー';
  final String settingsLoginInfo = '※Googleアカウントでログインできます。ログインするとデータのバックアップが可能になります。';
  final String settingsLoginNameNotSettingLabel = '未設定';
  final String settingsLoginEmailNotSettingLabel = '未設定';
  final String settingsLoginWithGoogle = 'ログイン';
  final String settingsLogoutLabel = 'ログアウト';
  final String settingsChangeAppThemeLabel = 'テーマ切り替え';
  final String settingsAppVersionLabel = 'アプリバージョン';

  // 体調
  final String conditionTypeBad = '悪い';
  final String conditionTypeNormal = '普通';
  final String conditionTypeGood = '良い';

  // ダイアログ
  final String dialogSuccessMessage = '処理が完了しました！';
  final String dialogErrorMessage = 'エラーが発生しました(´·ω·`)';
  final String dialogOk = 'OK';
  final String dialogCancel = 'キャンセル';
}
