import 'dart:async';
import 'core/config/env.dart';
import 'core/storage/hive_service.dart';
import 'core/network/supabase_client.dart';

Future<void> bootstrap() async {
  // Initialize Hive for local caching
  await HiveService.initialize();

  // Initialize Supabase from environment config (dev: .env, release: --dart-define)
  await SupabaseService.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );
}
