import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/content_item.dart';
import '../../domain/content_type.dart';
import 'json_converters.dart';

part 'sound_book.freezed.dart';
part 'sound_book.g.dart';

/// A sound book from the `sound_books` array of `GET /content_list`.
/// Unlike books/games/quran, sound books carry no `samples` field at all.
@freezed
class SoundBook with _$SoundBook implements ContentItem {
  const SoundBook._();

  const factory SoundBook({
    required String id,
    required String title,
    String? lang,
    String? description,
    @JsonKey(fromJson: nullableIntFromString) int? readings,
    required String image,
    required String file,
    @JsonKey(fromJson: intFromString) required int order,
    required String folder,
    @JsonKey(fromJson: doubleFromString) required double version,
    @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
    required DateTime date,
    @JsonKey(name: 'file_size') required String fileSize,
  }) = _SoundBook;

  factory SoundBook.fromJson(Map<String, dynamic> json) =>
      _$SoundBookFromJson(json);

  @override
  String get fileUrl => file;

  @override
  String get coverImageUrl => image;

  @override
  List<String> get samples => const [];

  @override
  ContentType get contentType => ContentType.soundBook;
}
