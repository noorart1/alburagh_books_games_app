import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:alburagh_books_games_app/features/content/data/models/content_list_response.dart';

void main() {
  test('parses a real GET /content_list response fetched from the live API', () {
    final raw = File('test/fixtures/content_list.json').readAsStringSync();
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final response = ContentListResponse.fromJson(json);

    expect(response.books, isNotEmpty);
    expect(response.games, isNotEmpty);
    expect(response.qurans, isNotEmpty);
    expect(response.soundBooks, isNotEmpty);

    final book = response.books.first;
    expect(book.id, '1');
    expect(book.folder, 'felfeli_01_diko_ar');
    expect(book.ageGroup, isNotEmpty);
    expect(book.rate, isA<double>());
    expect(book.downloads, isA<int>());
    expect(book.date.year, greaterThan(2000));
    expect(book.samples, isNotEmpty);
    expect(book.fileUrl, book.file);
    expect(book.coverImageUrl, book.cover);

    final game = response.games.first;
    expect(game.readings, isNull);
    expect(game.coverImageUrl, game.image);

    final quran = response.qurans.first;
    expect(quran.fileSize, isNotEmpty);

    final soundBook = response.soundBooks.first;
    expect(soundBook.samples, isEmpty);
  });
}
