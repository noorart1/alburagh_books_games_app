/// Preference keys, mirroring `Helpers/Setting.java` in the original app.
///
/// `lastPassword` intentionally has no equivalent here — the old app stored
/// the login password in cleartext in SharedPreferences to silently
/// re-authenticate on cold start. We keep the "remember email" behavior but
/// store only a session-safe credential in [SecureStore], never a plaintext
/// password in [SharedPreferences].
class StorageKeys {
  StorageKeys._();

  static const lastMail = 'last_mail';
  static const userExpire = 'user_expire';
  static const firstRun = 'first_run';
  static const favoriteContents = 'favorite_contents';
  static const musicState = 'music_state';
  static const resumeMusicOnContentClose = 'resume_music_on_content_close';
  static const lastFavoriteType = 'last_favorite_type';
}

/// Secure-storage-only keys (never plaintext SharedPreferences).
class SecureStorageKeys {
  SecureStorageKeys._();

  static const lastPassword = 'last_password';
}
