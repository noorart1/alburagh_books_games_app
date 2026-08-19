// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContentListResponseImpl _$$ContentListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ContentListResponseImpl(
  books:
      (json['books'] as List<dynamic>?)
          ?.map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Book>[],
  games:
      (json['games'] as List<dynamic>?)
          ?.map((e) => Game.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Game>[],
  qurans:
      (json['qurans'] as List<dynamic>?)
          ?.map((e) => Quran.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Quran>[],
  soundBooks:
      (json['sound_books'] as List<dynamic>?)
          ?.map((e) => SoundBook.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SoundBook>[],
);

Map<String, dynamic> _$$ContentListResponseImplToJson(
  _$ContentListResponseImpl instance,
) => <String, dynamic>{
  'books': instance.books,
  'games': instance.games,
  'qurans': instance.qurans,
  'sound_books': instance.soundBooks,
};
