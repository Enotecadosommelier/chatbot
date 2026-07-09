import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/state/providers.dart';

class WsetDiplomaApp extends ConsumerWidget {
  const WsetDiplomaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider);

    return MaterialApp(
      title: 'WSET Diploma Prep',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: bootstrap.when(
        data: (_) => const HomeScreen(),
        loading: () => const _SplashScreen(),
        error: (error, _) => _SplashScreen(error: error),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  final Object? error;

  const _SplashScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wine_bar, size: 64),
              const SizedBox(height: 16),
              const Text('WSET Diploma Prep', style: TextStyle(fontSize: 22)),
              const SizedBox(height: 24),
              if (error == null)
                const CircularProgressIndicator()
              else
                Text(
                  'Something went wrong preparing your offline question bank:\n$error',
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
