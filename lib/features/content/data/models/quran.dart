import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/content_item.dart';
import '../../domain/content_type.dart';
import 'json_converters.dart';

part 'quran.freezed.dart';
part 'quran.g.dart';

/// The single item in the `qurans` array of `GET /content_list`.
/// (Same shape as [Game] plus `file_size`.)
@freezed
class Quran with _$Quran implements ContentItem {
  const Quran._();

  const factory Quran({
    required String id,
    required String title,
    required String lang,
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
    @Default(<String>[]) List<String> samples,
  }) = _Quran;

  factory Quran.fromJson(Map<String, dynamic> json) => _$QuranFromJson(json);

  @override
  String get fileUrl => file;

  @override
  String get coverImageUrl => image;

  @override
  ContentType get contentType => ContentType.quran;
}
