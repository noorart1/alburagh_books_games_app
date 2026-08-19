import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/content_item.dart';
import '../../domain/content_type.dart';
import 'json_converters.dart';

part 'game.freezed.dart';
part 'game.g.dart';

/// A game from the `games` array of `GET /content_list`.
@freezed
class Game with _$Game implements ContentItem {
  const Game._();

  const factory Game({
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
    @Default(<String>[]) List<String> samples,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  @override
  String get fileUrl => file;

  @override
  String get coverImageUrl => image;

  @override
  ContentType get contentType => ContentType.game;
}
