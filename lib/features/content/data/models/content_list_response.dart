import 'package:freezed_annotation/freezed_annotation.dart';

import 'book.dart';
import 'game.dart';
import 'quran.dart';
import 'sound_book.dart';

part 'content_list_response.freezed.dart';
part 'content_list_response.g.dart';

/// Raw response shape of `GET /content_list` — verified live: top-level keys
/// are exactly `books`, `games`, `qurans`, `sound_books`.
@freezed
class ContentListResponse with _$ContentListResponse {
  const factory ContentListResponse({
    @Default(<Book>[]) List<Book> books,
    @Default(<Game>[]) List<Game> games,
    @Default(<Quran>[]) List<Quran> qurans,
    @JsonKey(name: 'sound_books')
    @Default(<SoundBook>[])
    List<SoundBook> soundBooks,
  }) = _ContentListResponse;

  factory ContentListResponse.fromJson(Map<String, dynamic> json) =>
      _$ContentListResponseFromJson(json);
}
