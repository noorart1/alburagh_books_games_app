import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:alburagh_books_games_app/core/storage/app_prefs.dart';
import 'package:alburagh_books_games_app/features/content/data/content_download_manager.dart';
import 'package:alburagh_books_games_app/features/content/domain/content_type.dart';
import 'package:alburagh_books_games_app/features/content/domain/local_custom_item.dart';
import 'package:alburagh_books_games_app/features/content/presentation/content_grid_screen.dart';
import 'package:alburagh_books_games_app/features/content/presentation/content_providers.dart';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serves a tiny zip (just `content.json`) for any download request.
class _ZipAdapter implements HttpClientAdapter {
  _ZipAdapter(this.bytes);
  final List<int> bytes;

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? body, Future<void>? cancel) async =>
      ResponseBody.fromBytes(bytes, 200, headers: {
        Headers.contentLengthHeader: ['${bytes.length}'],
      });

  @override
  void close({bool force = false}) {}
}

class _TempRootManager extends ContentDownloadManager {
  _TempRootManager(super.dio, this.root);
  final Directory root;

  @override
  Future<Directory> contentRootDir() async => root;
}

void main() {
  testWidgets('game card shows the green check right after its download finishes', (tester) async {
    final root = Directory.systemTemp.createTempSync('contents');
    addTearDown(() => root.deleteSync(recursive: true));
    final zip = ZipEncoder().encode(Archive()..addFile(ArchiveFile.string('content.json', '{"html":"0/index.html"}')))!;
    final dio = Dio()..httpClientAdapter = _ZipAdapter(zip);
    final manager = _TempRootManager(dio, root);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final game = LocalCustomItem(
      id: '1',
      title: 'لعبة',
      folder: 'test_game',
      contentType: ContentType.game,
      fileUrl: 'https://example.com/test_game.zip',
    );

    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        contentDownloadManagerProvider.overrideWithValue(manager),
        contentItemsProvider.overrideWith((ref, type) => AsyncData([game])),
      ],
      child: const MaterialApp(home: ContentGridScreen(type: ContentType.game)),
    ));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pump();
    expect(find.byIcon(Icons.download_rounded), findsOneWidget);

    await tester.tap(find.text('لعبة')); // tapping a not-downloaded game starts the download
    for (var i = 0; i < 30; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(SnackBar), findsNothing, reason: 'download reported failure');

    expect(File('${root.path}/test_game/content.json').existsSync(), isTrue, reason: 'download+extract ran');
    expect(find.byIcon(Icons.check_circle), findsOneWidget, reason: 'card must update without leaving the screen');
    expect(jsonDecode(File('${root.path}/test_game/content.json').readAsStringSync()), isA<Map>());
  });
}
