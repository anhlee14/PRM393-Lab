import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/item_model.dart';

class Lab91AssetScreen extends StatefulWidget {
  const Lab91AssetScreen({super.key});

  @override
  State<Lab91AssetScreen> createState() => _Lab91AssetScreenState();
}

class _Lab91AssetScreenState extends State<Lab91AssetScreen> {
  List<ItemModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssetJson();
  }

  Future<void> _loadAssetJson() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/items.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);

      setState(() {
        _items = jsonList.map((item) => ItemModel.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: _items.isEmpty
          ? const Center(child: Text('Không tìm thấy dữ liệu trong Assets.'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(child: Text('${item.id}')),
              title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item.description),
            ),
          );
        },
      ),
    );
  }
}