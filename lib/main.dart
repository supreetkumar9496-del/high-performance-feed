import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:high_performance_feed/features/feed/screens/feed_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: "https://qluumdswjfbokjfeuqnu.supabase.co",
      anonKey: "sb_publishable_ujwJemrMvVD4oL9zrmTBXg_xmtiUegh"
  );

  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "High Performance Feed",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FeedScreen(),
    );
  }
}

class SetupCheckScreen extends StatelessWidget {
  const SetupCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("High Performance Feed"),
      ),
      body: const Center(
        child: Text(
          "Project setup complete",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}


