import 'package:supabase_flutter/supabase_flutter.dart';

class MockLocalStorage extends LocalStorage {
  MockLocalStorage()
      : super(
    initialize: () async {},

    /// Session expires at is at its maximum value for unix timestamp
    accessToken: () async =>
    '{"currentSession":{"token_type": "","access_token":"","expires_in":3600,"refresh_token":"","user":{"app_metadata": {},"id":"","aud":"","created_at":"","role":"authenticated","updated_at":""}},"expiresAt":2147483647}',
    persistSession: (_) async {},
    removePersistedSession: () async {},
    hasAccessToken: () async => true,
  );
}