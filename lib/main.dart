import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env for dev. In release builds the file is absent and this is a no-op;
  // values then come from --dart-define via Env.
  await dotenv.load(fileName: '.env');

  await bootstrap();

  runApp(
    const ProviderScope(
      child: FittedApp(),
    ),
  );
}
