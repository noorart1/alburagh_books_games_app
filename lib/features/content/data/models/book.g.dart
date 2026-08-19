// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookImpl _$$BookImplFromJson(Map<String, dynamic> json) => _$BookImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  lang: json['lang'] as String,
  series: json['series'] as String?,
  description: json['description'] as String,
  rate: doubleFromString(json['rate'] as String),
  downloads: intFromString(json['downloads'] as String),
  readings: nullableIntFromString(json['readings'] as String?),
  author: json['author'] as String,
  illistrator: json['illistrator'] as String?,
  publisher: json['publisher'] as String,
  ageGroup: json['age_group'] as String,
  cover: json['cover'] as String,
  file: json['file'] as String,
  order: intFromString(json['order'] as String),
  folder: json['folder'] as String,
  version: doubleFromString(json['version'] as String),
  date: dateFromUnixSecondsString(json['date'] as String),
  fileSize: json['file_size'] as String,
  samples:
      (json['samples'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$$BookImplToJson(_$BookImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'lang': instance.lang,
      'series': instance.series,
      'description': instance.description,
      'rate': instance.rate,
      'downloads': instance.downloads,
      'readings': instance.readings,
      'author': instance.author,
      'illistrator': instance.illistrator,
      'publisher': instance.publisher,
      'age_group': instance.ageGroup,
      'cover': instance.cover,
      'file': instance.file,
      'order': instance.order,
      'folder': instance.folder,
      'version': instance.version,
      'date': dateToJson(instance.date),
      'file_size': instance.fileSize,
      'samples': instance.samples,
    };
