import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wraps [SharedPreferences] for the simple flags the old app kept in its
/// single `alburagh_env` preferences file (see `Helpers/Setting.java`).
/// Must be overridden with a resolved instance at app startup (see main.dart).
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');
});

final musicEnabledProvider = StateProvider<bool>((ref) => true);
