import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'providers/mock_data_provider.dart';
import 'screens/loading_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MockDataProvider())],
      child: const CarfestApp(),
    ),
  );
}

class CarfestApp extends StatelessWidget {
  const CarfestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carfest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoadingScreen(),
    );
  }
}
