import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/content_item.dart';
import '../../domain/content_type.dart';
import 'json_converters.dart';

part 'book.freezed.dart';
part 'book.g.dart';

/// A book from the `books` array of `GET /content_list`.
/// Field names/types verified against the live API response.
@freezed
class Book with _$Book implements ContentItem {
  const Book._();

  const factory Book({
    required String id,
    required String title,
    required String lang,
    String? series,
    required String description,
    @JsonKey(fromJson: doubleFromString) required double rate,
    @JsonKey(fromJson: intFromString) required int downloads,
    @JsonKey(fromJson: nullableIntFromString) int? readings,
    required String author,
    String? illistrator,
    required String publisher,
    @JsonKey(name: 'age_group') required String ageGroup,
    required String cover,
    required String file,
    @JsonKey(fromJson: intFromString) required int order,
    required String folder,
    @JsonKey(fromJson: doubleFromString) required double version,
    @JsonKey(fromJson: dateFromUnixSecondsString, toJson: dateToJson)
    required DateTime date,
    @JsonKey(name: 'file_size') required String fileSize,
    @Default(<String>[]) List<String> samples,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  @override
  String get fileUrl => file;

  @override
  String get coverImageUrl => cover;

  @override
  ContentType get contentType => ContentType.book;
}
