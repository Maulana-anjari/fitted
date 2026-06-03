import 'dart:async';
import 'core/storage/hive_service.dart';
import 'core/network/supabase_client.dart';

Future<void> bootstrap() async {
  // Initialize Hive for local caching
  await HiveService.initialize();

  // Initialize Supabase
  // TODO: Replace with actual env values or use flutter_dotenv
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await SupabaseService.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } else {
    print('[Bootstrap] Supabase not configured — running in offline mode');
  }
}
