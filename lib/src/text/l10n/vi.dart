import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../types.dart';
import 'l10n.dart';

class RruleL10nVi extends RruleL10n {
  const RruleL10nVi._();

  static RruleL10nVi create() {
    initializeDateFormatting('vi');
    return const RruleL10nVi._();
  }

  @override
  String get locale => 'vi';

  @override
  String frequencyInterval(RecurrenceFrequency frequency, int interval) {
    String plurals({required String one, required String singular}) {
      switch (interval) {
        case 1:
          return one;
        case 2:
          return 'Khác $singular';
        default:
          return 'Tất cả $interval ${singular}s';
      }
    }

    switch (frequency) {
      case RecurrenceFrequency.secondly:
        return plurals(one: 'thứ hai', singular: 'thứ hai');

      case RecurrenceFrequency.minutely:
        return plurals(one: 'từng phút', singular: 'phút');
      case RecurrenceFrequency.hourly:
        return plurals(one: 'Hàng giờ', singular: 'giờ');
      case RecurrenceFrequency.daily:
        return plurals(one: 'Hằng ngày', singular: 'ngày');
      case RecurrenceFrequency.weekly:
        return plurals(one: 'Hằng tuần', singular: 'tuần');
      case RecurrenceFrequency.monthly:
        return plurals(one: 'Hằng tháng', singular: 'tháng');
      case RecurrenceFrequency.yearly:
        return plurals(one: 'Hằng năm', singular: 'năm');
    }
  }

  @override
  String weeklyOnWeekday(DateTime startDate, int interval) {
    String plurals({required String one, required String singular}) {
      switch (interval) {
        case 1:
          return one;
        case 2:
          return 'Khác $singular';
        default:
          return 'Tất cả ${ordinal(interval)} $singular';
      }
    }

    final weekdayName =
    formatWithIntl(() => DateFormat.EEEE().format(startDate));
    return plurals(one: 'Tất cả $weekdayName', singular: weekdayName);
  }

  @override
  String until(DateTime until, {bool includeTime = false}) =>
      ', đến khi ${formatWithIntl(() => includeTime ? DateFormat.yMMMMEEEEd().add_jms().format(until) : DateFormat.yMMMMEEEEd().format(until))}';

  @override
  String count(int count) {
    switch (count) {
      case 1:
        return ', một lần';
      case 2:
        return ', hai lần';
      default:
        return ', $count lần';
    }
  }

  @override
  String onInstances(String instances) => 'trên $instances thí dụ';

  @override
  String inMonths(String months, {InOnVariant variant = InOnVariant.simple}) =>
      '${_inVariant(variant)} $months';

  @override
  String inWeeks(String weeks, {InOnVariant variant = InOnVariant.simple}) =>
      '${_inVariant(variant)} trên $weeks tuần của năm';

  String _inVariant(InOnVariant variant) {
    switch (variant) {
      case InOnVariant.simple:
        return 'trong';
      case InOnVariant.also:
        return 'trong số đó cũng có trong';
      case InOnVariant.instanceOf:
        return 'của';
    }
  }

  @override
  String onDaysOfWeek(
      String days, {
        bool indicateFrequency = false,
        DaysOfWeekFrequency? frequency = DaysOfWeekFrequency.monthly,
        InOnVariant variant = InOnVariant.simple,
      }) {
    assert(variant != InOnVariant.also);

    final frequencyString =
    frequency == DaysOfWeekFrequency.monthly ? 'tháng' : 'năm';
    final suffix = indicateFrequency ? ' của $frequencyString' : '';
    return '${_onVariant(variant)} $days$suffix';
  }

  @override
  String get weekdaysString => 'các ngày trong tuần';

  @override
  String get everydayString => 'hằng ngày';

  @override
  String get everyXDaysOfWeekPrefix => 'mỗi khi ';
  @override
  String nthDaysOfWeek(Iterable<int> occurrences, String daysOfWeek) {
    if (occurrences.isEmpty) return daysOfWeek;

    final ordinals = list(
      occurrences.map(ordinal).toList(),
      ListCombination.conjunctiveShort,
    );
    return ' $ordinals $daysOfWeek';
  }

  @override
  String onDaysOfMonth(
      String days, {
        DaysOfVariant daysOfVariant = DaysOfVariant.dayAndFrequency,
        InOnVariant variant = InOnVariant.simple,
      }) {
    final suffix = {
      DaysOfVariant.simple: '',
      DaysOfVariant.day: ' ngày',
      DaysOfVariant.dayAndFrequency: ' ngày trong tháng',
    }[daysOfVariant];
    return '${_onVariant(variant)} của $days$suffix';
  }

  @override
  String onDaysOfYear(
      String days, {
        InOnVariant variant = InOnVariant.simple,
      }) =>
      '${_onVariant(variant)} của $days ngày trong năm';

  String _onVariant(InOnVariant variant) {
    switch (variant) {
      case InOnVariant.simple:
        return 'trên';
      case InOnVariant.also:
        return 'cũng là';
      case InOnVariant.instanceOf:
        return 'của';
    }
  }

  @override
  String list(List<String> items, ListCombination combination) {
    String two;
    String end;
    switch (combination) {
      case ListCombination.conjunctiveShort:
        two = ' & ';
        end = ' & ';
        break;
      case ListCombination.conjunctiveLong:
        two = ' và ';
        end = ', và ';
        break;
      case ListCombination.disjunctive:
        two = ' hoặc ';
        end = ', hoặc ';
        break;
    }
    return RruleL10n.defaultList(items, two: two, end: end);
  }

  @override
  String ordinal(int number, {bool isSingleItem = true}) {
    assert(number != 0);
    if (number == -1) return 'cuối';

    final n = number.abs();
    String string;
    if (n % 10 == 1 && n % 100 != 11) {
      if (n == 1) {
        string = 'Đầu tiên';
      } else {
        string = '${n}st';
      }
    } else if (n % 10 == 2 && n % 100 != 12) {
      if (n == 2) {
        string = 'thứ hai';
      } else {
        string = '${n}nd';
      }
    } else if (n % 10 == 3 && n % 100 != 13) {
      if (n == 3) {
        string = 'ngày thứ ba';
      } else {
        string = '${n}rd';
      }
    } else {
      string = '${n}th';
    }

    return number < 0 ? '$string-to-last' : string;
  }
}
