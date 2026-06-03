import 'dart:async';
import 'core/storage/hive_service.dart';
import 'core/network/supabase_client.dart';

Future<void> bootstrap() async {
  // Initialize Hive for local caching
  await HiveService.initialize();

  // Initialize Supabase
  await SupabaseService.initialize(
    url: 'https://tltzaslwhualoctbkdgw.supabase.co',
    anonKey: 'REMOVED',
  );
}
