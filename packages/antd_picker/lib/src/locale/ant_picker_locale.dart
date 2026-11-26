/// AntPicker 国际化文案配置。
///
/// 独立包内建 locale 体系（风格对齐 antd_calendar 的 `AntCalendarLocale`）：
/// - 内建常用语言预设：`zh` / `zhTw` / `en` / `ja` / `ko` / `fr` / `de` /
///   `es` / `ru` / `pt` / `it` / `ar` / `th` / `vi` / `id`；
/// - [AntPickerLocale.fromLanguageCode] 按语言码解析（未知码回退中文）；
/// - 未显式提供的字段按「`fallback` → 同语言预设 → 中文」逐级回退；
/// - 组件可经 `locale` 参数注入，或全局经 [AntPickerLocaleProvider] 注入；
///   都未提供时 [AntPickerLocale.resolve] 跟随 App 的 `Localizations` 语言，
///   最后才回退中文预设。
library;

import 'package:flutter/widgets.dart';

/// 中文（简体）内置文案常量，作为所有 locale 的最终回退。
const AntPickerLocale _zhDefaults = AntPickerLocale._raw(
  languageCode: 'zh',
  monthTitlePattern: '{year}年{month}月',
  weekLabels: ['一', '二', '三', '四', '五', '六', '日'],
  datePlaceholder: '请选择日期',
  timePlaceholder: '请选择时间',
  rangeStartPlaceholder: '开始日期',
  rangeEndPlaceholder: '结束日期',
  rangeSeparator: '~',
  confirmText: '确定',
  cancelText: '取消',
  todayText: '今天',
  defaultDateFormat: 'yyyy-MM-dd',
  defaultTimeFormat: 'HH:mm',
);

/// 日期/时间选择器国际化文案。
///
/// ```dart
/// // 用内建预设
/// AntDatePicker(locale: AntPickerLocale.en, ...)
///
/// // 自定义个别文案（其余字段继承同语言预设）
/// AntDatePicker(
///   locale: AntPickerLocale(languageCode: 'en', datePlaceholder: 'Pick a day'),
///   ...
/// )
/// ```
class AntPickerLocale {
  /// 创建国际化配置（未提供的字段逐级回退 `fallback`、同语言预设、中文预设）。
  const AntPickerLocale({
    this.languageCode = 'zh',
    this.monthTitlePattern,
    this.weekLabels,
    this.datePlaceholder,
    this.timePlaceholder,
    this.rangeStartPlaceholder,
    this.rangeEndPlaceholder,
    this.rangeSeparator,
    this.confirmText,
    this.cancelText,
    this.todayText,
    this.defaultDateFormat,
    this.defaultTimeFormat,
    this.messages = const {},
    AntPickerLocale? fallback,
  }) : _fallback = fallback;

  /// 内建预设构造（全字段必填，作为回退终点）。
  const AntPickerLocale._raw({
    required this.languageCode,
    required this.monthTitlePattern,
    required this.weekLabels,
    required this.datePlaceholder,
    required this.timePlaceholder,
    required this.rangeStartPlaceholder,
    required this.rangeEndPlaceholder,
    required this.rangeSeparator,
    required this.confirmText,
    required this.cancelText,
    required this.todayText,
    required this.defaultDateFormat,
    required this.defaultTimeFormat,
  })  : _fallback = null,
        messages = const {};

  /// 中文（简体）预设 — 默认。
  static const AntPickerLocale zh = _zhDefaults;

  /// 中文（繁体）预设。
  static const AntPickerLocale zhTw = AntPickerLocale._raw(
    languageCode: 'zh-TW',
    monthTitlePattern: '{year}年{month}月',
    weekLabels: ['一', '二', '三', '四', '五', '六', '日'],
    datePlaceholder: '請選擇日期',
    timePlaceholder: '請選擇時間',
    rangeStartPlaceholder: '開始日期',
    rangeEndPlaceholder: '結束日期',
    rangeSeparator: '~',
    confirmText: '確定',
    cancelText: '取消',
    todayText: '今天',
    defaultDateFormat: 'yyyy-MM-dd',
    defaultTimeFormat: 'HH:mm',
  );

  /// 英语预设。
  static const AntPickerLocale en = AntPickerLocale._raw(
    languageCode: 'en',
    monthTitlePattern: '{month}/{year}',
    weekLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    datePlaceholder: 'Select date',
    timePlaceholder: 'Select time',
    rangeStartPlaceholder: 'Start date',
    rangeEndPlaceholder: 'End date',
    rangeSeparator: '~',
    confirmText: 'OK',
    cancelText: 'Cancel',
    todayText: 'Today',
    defaultDateFormat: 'MM/dd/yyyy',
    defaultTimeFormat: 'HH:mm',
  );

  /// 日语预设。
  static const AntPickerLocale ja = AntPickerLocale._raw(
    languageCode: 'ja',
    monthTitlePattern: '{year}年{month}月',
    weekLabels: ['月', '火', '水', '木', '金', '土', '日'],
    datePlaceholder: '日付を選択',
    timePlaceholder: '時刻を選択',
    rangeStartPlaceholder: '開始日',
    rangeEndPlaceholder: '終了日',
    rangeSeparator: '~',
    confirmText: '決定',
    cancelText: 'キャンセル',
    todayText: '今日',
    defaultDateFormat: 'yyyy/MM/dd',
    defaultTimeFormat: 'HH:mm',
  );

  /// 韩语预设。
  static const AntPickerLocale ko = AntPickerLocale._raw(
    languageCode: 'ko',
    monthTitlePattern: '{year}년 {month}월',
    weekLabels: ['월', '화', '수', '목', '금', '토', '일'],
    datePlaceholder: '날짜 선택',
    timePlaceholder: '시간 선택',
    rangeStartPlaceholder: '시작 날짜',
    rangeEndPlaceholder: '종료 날짜',
    rangeSeparator: '~',
    confirmText: '확인',
    cancelText: '취소',
    todayText: '오늘',
    defaultDateFormat: 'yyyy-MM-dd',
    defaultTimeFormat: 'HH:mm',
  );

  /// 法语预设。
  static const AntPickerLocale fr = AntPickerLocale._raw(
    languageCode: 'fr',
    monthTitlePattern: '{month}/{year}',
    weekLabels: ['lun', 'mar', 'mer', 'jeu', 'ven', 'sam', 'dim'],
    datePlaceholder: 'Sélectionner une date',
    timePlaceholder: 'Sélectionner une heure',
    rangeStartPlaceholder: 'Date de début',
    rangeEndPlaceholder: 'Date de fin',
    rangeSeparator: '~',
    confirmText: 'OK',
    cancelText: 'Annuler',
    todayText: "Aujourd'hui",
    defaultDateFormat: 'dd/MM/yyyy',
    defaultTimeFormat: 'HH:mm',
  );

  /// 德语预设。
  static const AntPickerLocale de = AntPickerLocale._raw(
    languageCode: 'de',
    monthTitlePattern: '{month}.{year}',
    weekLabels: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
    datePlaceholder: 'Datum auswählen',
    timePlaceholder: 'Uhrzeit auswählen',
    rangeStartPlaceholder: 'Startdatum',
    rangeEndPlaceholder: 'Enddatum',
    rangeSeparator: '~',
    confirmText: 'OK',
    cancelText: 'Abbrechen',
    todayText: 'Heute',
    defaultDateFormat: 'dd.MM.yyyy',
    defaultTimeFormat: 'HH:mm',
  );

  /// 西班牙语预设。
  static const AntPickerLocale es = AntPickerLocale._raw(
    languageCode: 'es',
    monthTitlePattern: '{month}/{year}',
    weekLabels: ['lun', 'mar', 'mié', 'jue', 'vie', 'sáb', 'dom'],
    datePlaceholder: 'Seleccionar fecha',
    timePlaceholder: 'Seleccionar hora',
    rangeStartPlaceholder: 'Fecha de inicio',
    rangeEndPlaceholder: 'Fecha de fin',
    rangeSeparator: '~',
    confirmText: 'Aceptar',
    cancelText: 'Cancelar',
    todayText: 'Hoy',
    defaultDateFormat: 'dd/MM/yyyy',
    defaultTimeFormat: 'HH:mm',
  );

  /// 俄语预设。
  static const AntPickerLocale ru = AntPickerLocale._raw(
    languageCode: 'ru',
    monthTitlePattern: '{month}.{year}',
    weekLabels: ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'],
    datePlaceholder: 'Выберите дату',
    timePlaceholder: 'Выберите время',
    rangeStartPlaceholder: 'Дата начала',
    rangeEndPlaceholder: 'Дата окончания',
    rangeSeparator: '~',
    confirmText: 'ОК',
    cancelText: 'Отмена',
    todayText: 'Сегодня',
    defaultDateFormat: 'dd.MM.yyyy',
    defaultTimeFormat: 'HH:mm',
  );

  /// 葡萄牙语预设。
  static const AntPickerLocale pt = AntPickerLocale._raw(
    languageCode: 'pt',
    monthTitlePattern: '{month}/{year}',
    weekLabels: ['seg', 'ter', 'qua', 'qui', 'sex', 'sáb', 'dom'],
    datePlaceholder: 'Selecionar data',
    timePlaceholder: 'Selecionar hora',
    rangeStartPlaceholder: 'Data inicial',
    rangeEndPlaceholder: 'Data final',
    rangeSeparator: '~',
    confirmText: 'OK',
    cancelText: 'Cancelar',
    todayText: 'Hoje',
    defaultDateFormat: 'dd/MM/yyyy',
    defaultTimeFormat: 'HH:mm',
  );

  /// 意大利语预设。
  static const AntPickerLocale it = AntPickerLocale._raw(
    languageCode: 'it',
    monthTitlePattern: '{month}/{year}',
    weekLabels: ['lun', 'mar', 'mer', 'gio', 'ven', 'sab', 'dom'],
    datePlaceholder: 'Seleziona data',
    timePlaceholder: 'Seleziona ora',
    rangeStartPlaceholder: 'Data di inizio',
    rangeEndPlaceholder: 'Data di fine',
    rangeSeparator: '~',
    confirmText: 'OK',
    cancelText: 'Annulla',
    todayText: 'Oggi',
    defaultDateFormat: 'dd/MM/yyyy',
    defaultTimeFormat: 'HH:mm',
  );

  /// 阿拉伯语预设。
  static const AntPickerLocale ar = AntPickerLocale._raw(
    languageCode: 'ar',
    monthTitlePattern: '{month}/{year}',
    weekLabels: ['إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت', 'أحد'],
    datePlaceholder: 'اختر التاريخ',
    timePlaceholder: 'اختر الوقت',
    rangeStartPlaceholder: 'تاريخ البدء',
    rangeEndPlaceholder: 'تاريخ الانتهاء',
    rangeSeparator: '~',
    confirmText: 'موافق',
    cancelText: 'إلغاء',
    todayText: 'اليوم',
    defaultDateFormat: 'yyyy-MM-dd',
    defaultTimeFormat: 'HH:mm',
  );

  /// 泰语预设。
  static const AntPickerLocale th = AntPickerLocale._raw(
    languageCode: 'th',
    monthTitlePattern: '{month}/{year}',
    weekLabels: ['จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.', 'อา.'],
    datePlaceholder: 'เลือกวันที่',
    timePlaceholder: 'เลือกเวลา',
    rangeStartPlaceholder: 'วันที่เริ่มต้น',
    rangeEndPlaceholder: 'วันที่สิ้นสุด',
    rangeSeparator: '~',
    confirmText: 'ตกลง',
    cancelText: 'ยกเลิก',
    todayText: 'วันนี้',
    defaultDateFormat: 'dd/MM/yyyy',
    defaultTimeFormat: 'HH:mm',
  );

  /// 越南语预设。
  static const AntPickerLocale vi = AntPickerLocale._raw(
    languageCode: 'vi',
    monthTitlePattern: '{month}/{year}',
    weekLabels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
    datePlaceholder: 'Chọn ngày',
    timePlaceholder: 'Chọn giờ',
    rangeStartPlaceholder: 'Ngày bắt đầu',
    rangeEndPlaceholder: 'Ngày kết thúc',
    rangeSeparator: '~',
    confirmText: 'OK',
    cancelText: 'Hủy',
    todayText: 'Hôm nay',
    defaultDateFormat: 'dd/MM/yyyy',
    defaultTimeFormat: 'HH:mm',
  );

  /// 印尼语预设。
  static const AntPickerLocale id = AntPickerLocale._raw(
    languageCode: 'id',
    monthTitlePattern: '{month}/{year}',
    weekLabels: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
    datePlaceholder: 'Pilih tanggal',
    timePlaceholder: 'Pilih waktu',
    rangeStartPlaceholder: 'Tanggal mulai',
    rangeEndPlaceholder: 'Tanggal akhir',
    rangeSeparator: '~',
    confirmText: 'OK',
    cancelText: 'Batal',
    todayText: 'Hari ini',
    defaultDateFormat: 'dd/MM/yyyy',
    defaultTimeFormat: 'HH:mm',
  );

  /// 按语言码解析内建预设（大小写不敏感，支持 `zh_CN` / `zh-Hans` 等写法）。
  ///
  /// 未知语言码回退中文预设。
  static AntPickerLocale fromLanguageCode(String code) {
    final normalized = code.replaceAll('_', '-').toLowerCase();
    const presets = {
      'zh': zh,
      'zh-cn': zh,
      'zh-hans': zh,
      'zh-sg': zh,
      'zh-tw': zhTw,
      'zh-hk': zhTw,
      'zh-mo': zhTw,
      'zh-hant': zhTw,
      'en': en,
      'ja': ja,
      'ko': ko,
      'fr': fr,
      'de': de,
      'es': es,
      'ru': ru,
      'pt': pt,
      'it': it,
      'ar': ar,
      'th': th,
      'vi': vi,
      'id': id,
    };
    final primary = normalized.split('-').first;
    return presets[normalized] ?? presets[primary] ?? zh;
  }

  /// 语言码，如 `zh`、`en`、`zh-CN`。
  final String languageCode;

  /// 年月标题模板，`{year}` / `{month}` 为占位符。
  final String? monthTitlePattern;

  /// 周标签（自周一起始的 7 个标签；周日起始时组件自动轮转）。
  final List<String>? weekLabels;

  /// 日期输入占位文案。
  final String? datePlaceholder;

  /// 时间输入占位文案。
  final String? timePlaceholder;

  /// 日期范围起点占位文案。
  final String? rangeStartPlaceholder;

  /// 日期范围终点占位文案。
  final String? rangeEndPlaceholder;

  /// 日期范围分隔符（默认 `~`）。
  final String? rangeSeparator;

  /// 确认按钮文案。
  final String? confirmText;

  /// 取消按钮文案。
  final String? cancelText;

  /// 「今天」文案。
  final String? todayText;

  /// 默认日期显示格式（`yyyy-MM-dd` / `MM/dd/yyyy` / `dd.MM.yyyy` 等）。
  final String? defaultDateFormat;

  /// 默认时间显示格式（`HH:mm` / `HH:mm:ss`）。
  final String? defaultTimeFormat;

  /// 自定义文案扩展表（key → 文案），经 [text] 读取。
  final Map<String, String> messages;

  /// 字段缺失时的一级回退预设（最终回退同语言预设 / 中文内置文案）。
  final AntPickerLocale? _fallback;

  /// 同语言的内建预设（供自定义实例逐字段继承）。
  AntPickerLocale? get _preset =>
      identical(this, _zhDefaults) ? null : fromLanguageCode(languageCode);

  /// 生效的月标题模板。
  String get effectiveMonthTitlePattern =>
      monthTitlePattern ??
      _fallback?.monthTitlePattern ??
      _preset?.monthTitlePattern ??
      _zhDefaults.monthTitlePattern!;

  /// 生效的周标签（自周一起始）。
  List<String> get effectiveWeekLabels =>
      weekLabels ??
      _fallback?.weekLabels ??
      _preset?.weekLabels ??
      _zhDefaults.weekLabels!;

  /// 生效的日期占位文案。
  String get effectiveDatePlaceholder =>
      datePlaceholder ??
      _fallback?.datePlaceholder ??
      _preset?.datePlaceholder ??
      _zhDefaults.datePlaceholder!;

  /// 生效的时间占位文案。
  String get effectiveTimePlaceholder =>
      timePlaceholder ??
      _fallback?.timePlaceholder ??
      _preset?.timePlaceholder ??
      _zhDefaults.timePlaceholder!;

  /// 生效的日期范围起点占位文案。
  String get effectiveRangeStartPlaceholder =>
      rangeStartPlaceholder ??
      _fallback?.rangeStartPlaceholder ??
      _preset?.rangeStartPlaceholder ??
      _zhDefaults.rangeStartPlaceholder!;

  /// 生效的日期范围终点占位文案。
  String get effectiveRangeEndPlaceholder =>
      rangeEndPlaceholder ??
      _fallback?.rangeEndPlaceholder ??
      _preset?.rangeEndPlaceholder ??
      _zhDefaults.rangeEndPlaceholder!;

  /// 生效的日期范围分隔符。
  String get effectiveRangeSeparator =>
      rangeSeparator ??
      _fallback?.rangeSeparator ??
      _preset?.rangeSeparator ??
      _zhDefaults.rangeSeparator!;

  /// 生效的确认文案。
  String get effectiveConfirmText =>
      confirmText ??
      _fallback?.confirmText ??
      _preset?.confirmText ??
      _zhDefaults.confirmText!;

  /// 生效的取消文案。
  String get effectiveCancelText =>
      cancelText ??
      _fallback?.cancelText ??
      _preset?.cancelText ??
      _zhDefaults.cancelText!;

  /// 生效的「今天」文案。
  String get effectiveTodayText =>
      todayText ??
      _fallback?.todayText ??
      _preset?.todayText ??
      _zhDefaults.todayText!;

  /// 生效的默认日期显示格式。
  String get effectiveDateFormat =>
      defaultDateFormat ??
      _fallback?.defaultDateFormat ??
      _preset?.defaultDateFormat ??
      _zhDefaults.defaultDateFormat!;

  /// 生效的默认时间显示格式。
  String get effectiveTimeFormat =>
      defaultTimeFormat ??
      _fallback?.defaultTimeFormat ??
      _preset?.defaultTimeFormat ??
      _zhDefaults.defaultTimeFormat!;

  /// 按周起始约定返回周标签序列（周日起始时把周一标签轮转到末位）。
  List<String> weekLabelsFor({required bool weekStartsOnMonday}) {
    final labels = effectiveWeekLabels;
    if (weekStartsOnMonday || labels.length < 7) return labels;
    return [labels.last, ...labels.sublist(0, labels.length - 1)];
  }

  /// 头部年月标题（模板占位符替换）。
  String monthTitle(int year, int month) => effectiveMonthTitlePattern
      .replaceAll('{year}', '$year')
      .replaceAll('{month}', '$month');

  /// 读取自定义扩展文案，key 不存在时返回 [fallbackText]（默认 key 本身）。
  String text(String key, [String? fallbackText]) =>
      messages[key] ?? fallbackText ?? key;

  /// 从组件树读取注入的 locale；未注入时返回 null。
  static AntPickerLocale? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AntPickerLocaleProvider>()
      ?.locale;

  /// 从组件树读取注入的 locale；未注入时回退中文预设。
  static AntPickerLocale of(BuildContext context) => maybeOf(context) ?? zh;

  /// 解析组件实际使用的 locale。
  ///
  /// 优先级：显式 [explicit] 参数 → [AntPickerLocaleProvider] 注入 →
  /// App 的 `Localizations` 语言（`MaterialApp(locale: ...)` / 系统语言）→
  /// 中文预设。组件内部统一用本方法取 locale，实现「跟随 App 国际化」。
  static AntPickerLocale resolve(
    BuildContext context, [
    AntPickerLocale? explicit,
  ]) {
    if (explicit != null) return explicit;
    final injected = maybeOf(context);
    if (injected != null) return injected;
    final appLocale = Localizations.maybeLocaleOf(context);
    if (appLocale != null) {
      return fromLanguageCode(appLocale.toLanguageTag());
    }
    return zh;
  }

  @override
  bool operator ==(Object other) =>
      other is AntPickerLocale &&
      other.languageCode == languageCode &&
      other.monthTitlePattern == monthTitlePattern &&
      _listEquals(other.weekLabels, weekLabels) &&
      other.datePlaceholder == datePlaceholder &&
      other.timePlaceholder == timePlaceholder &&
      other.rangeStartPlaceholder == rangeStartPlaceholder &&
      other.rangeEndPlaceholder == rangeEndPlaceholder &&
      other.rangeSeparator == rangeSeparator &&
      other.confirmText == confirmText &&
      other.cancelText == cancelText &&
      other.todayText == todayText &&
      other.defaultDateFormat == defaultDateFormat &&
      other.defaultTimeFormat == defaultTimeFormat &&
      other._fallback == _fallback;

  static bool _listEquals(List<String>? a, List<String>? b) {
    if (a == null || b == null) return identical(a, b);
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        languageCode,
        monthTitlePattern,
        Object.hashAll(weekLabels ?? const []),
        datePlaceholder,
        timePlaceholder,
        rangeStartPlaceholder,
        rangeEndPlaceholder,
        rangeSeparator,
        confirmText,
        cancelText,
        todayText,
        defaultDateFormat,
        defaultTimeFormat,
      );
}

/// 选择器国际化注入 — InheritedWidget，包裹一次全局生效。
///
/// ```dart
/// AntPickerLocaleProvider(
///   locale: AntPickerLocale.en,
///   child: AntDatePicker(...),
/// )
/// ```
class AntPickerLocaleProvider extends InheritedWidget {
  /// 创建注入节点。
  const AntPickerLocaleProvider({
    super.key,
    required this.locale,
    required super.child,
  });

  /// 注入的国际化配置。
  final AntPickerLocale locale;

  @override
  bool updateShouldNotify(AntPickerLocaleProvider oldWidget) =>
      oldWidget.locale != locale;
}
