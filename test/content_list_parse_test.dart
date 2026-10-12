import 'dart:io';

import 'package:alburagh_books_games_app/features/content/data/content_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bundled content_list.json parses (offline fallback)', () {
    final raw = File('assets/data/content_list.json').readAsStringSync();
    final response = ContentApi.parseContentList(raw);
    expect(response.books, isNotEmpty);
    expect(response.games.map((g) => g.folder), contains('find_hidden_boy_ar'));
  });
}
