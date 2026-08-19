// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SoundBookImpl _$$SoundBookImplFromJson(Map<String, dynamic> json) =>
    _$SoundBookImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      lang: json['lang'] as String?,
      description: json['description'] as String?,
      readings: nullableIntFromString(json['readings'] as String?),
      image: json['image'] as String,
      file: json['file'] as String,
      order: intFromString(json['order'] as String),
      folder: json['folder'] as String,
      version: doubleFromString(json['version'] as String),
      date: dateFromUnixSecondsString(json['date'] as String),
      fileSize: json['file_size'] as String,
    );

Map<String, dynamic> _$$SoundBookImplToJson(_$SoundBookImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'lang': instance.lang,
      'description': instance.description,
      'readings': instance.readings,
      'image': instance.image,
      'file': instance.file,
      'order': instance.order,
      'folder': instance.folder,
      'version': instance.version,
      'date': dateToJson(instance.date),
      'file_size': instance.fileSize,
    };
