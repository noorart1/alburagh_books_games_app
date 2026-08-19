import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alburagh_books_games_app/core/storage/app_prefs.dart';
import 'package:alburagh_books_games_app/main.dart';

void main() {
  testWidgets('Home screen renders with Start button', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const AlburaghApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('البراق'), findsOneWidget);
    expect(find.text('ابدأ'), findsOneWidget);
  });
}
