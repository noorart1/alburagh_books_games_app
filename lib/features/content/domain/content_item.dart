import 'content_type.dart';

/// Common surface shared by [Book]/[Game]/[Quran]/[SoundBook] so grid/list
/// UI can render any of them without a switch on concrete type.
abstract class ContentItem {
  String get id;
  String get title;
  String get folder;
  String get fileUrl;
  String get coverImageUrl;
  int get order;
  double get version;
  DateTime get date;
  List<String> get samples;
  int? get readings;
  ContentType get contentType;
}
