import 'package:flutter/material.dart';
import 'package:flutter_supabase_example/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vnjawdrpljvglpaxdkkk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuamF3ZHJwbGp2Z2xwYXhka2trIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE3MTU5NjIsImV4cCI6MjAxNzI5MTk2Mn0.tOOlEsnFszE9U8cLnXnE1ea0xRNuLHEWRJOIHZJ2U_8',
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuamF3ZHJwbGp2Z2xwYXhka2trIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcwMTcxNTk2MiwiZXhwIjoyMDE3MjkxOTYyfQ.blN_5l9hm0yYfYPaxWK1p1LFNgJDkx_Nh2ns3Fyi_-0'
    },
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
