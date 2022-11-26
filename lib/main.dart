import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kirana_billing/billing_screen.dart';
import 'package:kirana_billing/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAbyMJlFSxnEZfpvKvELrryviJFPkTwMAA",
      appId: "1:305550594016:web:9eb9c675fa42013dd42585",
      messagingSenderId: "305550594016",
      projectId: "kirana-bill-18",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text('Kirana Bill'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BillingScreen()),
                );
              },
              child: const Text('New Bill'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()),
                );
              },
              child: const Text('Past Bills'),
            ),
          ],
        ),
      ),
    );
  }
}
