import 'package:flutter/material.dart';
import 'screens/lab9_1_asset_screen.dart';
import 'screens/lab9_2_storage_screen.dart';
import 'screens/lab9_3_crud_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 9 - Local JSON Storage',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const MainTabScreen(),
    );
  }
}

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lab 9 – Local JSON Storage'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.file_copy), text: '9.1 Assets'),
              Tab(icon: Icon(Icons.save), text: '9.2 Storage'),
              Tab(icon: Icon(Icons.storage), text: '9.3 CRUD'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Lab91AssetScreen(),
            Lab92StorageScreen(),
            Lab93CrudScreen(),
          ],
        ),
      ),
    );
  }
}