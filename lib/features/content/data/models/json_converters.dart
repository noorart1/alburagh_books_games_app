/// The `content_list` API returns every numeric-looking field as a JSON
/// string (confirmed by fetching the live endpoint), and a few fields are
/// `null` for some items (e.g. `readings` on games/quran/sound_books,
/// `series`/`illistrator` on some books). These helpers centralize that
/// parsing instead of repeating `int.parse` calls with per-field defaults.
library;

int intFromString(String value) => int.parse(value);

int? nullableIntFromString(String? value) => value == null ? null : int.tryParse(value);

double doubleFromString(String value) => double.parse(value);

String? intToJson(int value) => value.toString();

/// `date` is a Unix timestamp in seconds, as a string (e.g. "1440741445").
DateTime dateFromUnixSecondsString(String value) =>
    DateTime.fromMillisecondsSinceEpoch(int.parse(value) * 1000);

String dateToJson(DateTime value) =>
    (value.millisecondsSinceEpoch ~/ 1000).toString();
