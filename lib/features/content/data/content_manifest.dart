import 'dart:convert';
import 'dart:io';

import '../domain/content_type.dart';

/// One page of a book, from `content.json`'s `"index"` array —
/// `thumb` is the table-of-contents thumbnail, `html` the page's entry file
/// (both paths relative to the content's extracted folder).
class BookPage {
  const BookPage({required this.thumb, required this.html});

  factory BookPage.fromJson(Map<String, dynamic> json) => BookPage(
        thumb: json['thumb'] as String,
        html: json['html'] as String,
      );

  final String thumb;
  final String html;
}

/// Parsed `content.json`, matching `ContentFragment.parseContentsJson` in
/// the original app: books carry a multi-page `index` array (thumb + html
/// per page); games/quran/sound-books carry a single `html` entry file.
class ContentManifest {
  const ContentManifest({this.pages, this.html});

  factory ContentManifest.fromJson(Map<String, dynamic> json, ContentType type) {
    if (type == ContentType.book) {
      final index = (json['index'] as List<dynamic>? ?? [])
          .map((e) => BookPage.fromJson(e as Map<String, dynamic>))
          .toList();
      return ContentManifest(pages: index);
    }
    return ContentManifest(html: json['html'] as String);
  }

  /// Book pages, in reading order. Null for non-book content.
  final List<BookPage>? pages;

  /// Single entry HTML file, relative to the content folder. Null for books.
  final String? html;

  bool get isPaged => pages != null;
}

Future<ContentManifest> loadContentManifest(Directory contentDir, ContentType type) async {
  final file = File('${contentDir.path}/content.json');
  final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  return ContentManifest.fromJson(json, type);
}
