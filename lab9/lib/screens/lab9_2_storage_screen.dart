import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/storage_service.dart';

class Lab92StorageScreen extends StatefulWidget {
  const Lab92StorageScreen({super.key});

  @override
  State<Lab92StorageScreen> createState() => _Lab92StorageScreenState();
}

class _Lab92StorageScreenState extends State<Lab92StorageScreen> {
  final StorageService _storageService = StorageService();
  final List<ItemModel> _items = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPersistedData();
  }

  // Tải dữ liệu đã lưu
  Future<void> _loadPersistedData() async {
    final loaded = await _storageService.readItems();
    setState(() {
      _items.clear();
      _items.addAll(loaded);
    });
  }

  // Thêm item mới
  void _addItem() {
    if (_titleController.text.trim().isEmpty) return;

    final newItem = ItemModel(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
    );

    setState(() {
      _items.add(newItem);
    });

    _titleController.clear();
    _descController.clear();
  }

  // Lưu danh sách
  Future<void> _saveToFile() async {
    await _storageService.writeItems(_items);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu thành công vào bộ nhớ máy (Persisted)!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Nhập đầu vào
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _addItem,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Item'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                            onPressed: _saveToFile,
                            icon: const Icon(Icons.save),
                            label: const Text('Save to Storage'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Danh sách hiển thị
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('Chưa có dữ liệu. Nhập và bấm Save để lưu.'))
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item.description),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}