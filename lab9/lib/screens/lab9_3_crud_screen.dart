import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/storage_service.dart';

class Lab93CrudScreen extends StatefulWidget {
  const Lab93CrudScreen({super.key});

  @override
  State<Lab93CrudScreen> createState() => _Lab93CrudScreenState();
}

class _Lab93CrudScreenState extends State<Lab93CrudScreen> {
  final StorageService _storageService = StorageService();
  List<ItemModel> _allTasks = [];
  List<ItemModel> _filteredTasks = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final data = await _storageService.readItems();
    setState(() {
      _allTasks = data;
      _applyFilter();
    });
  }

  Future<void> _autoSave() async {
    await _storageService.writeItems(_allTasks);
    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      if (_searchQuery.trim().isEmpty) {
        _filteredTasks = List.from(_allTasks);
      } else {
        _filteredTasks = _allTasks.where((task) {
          final query = _searchQuery.toLowerCase();
          return task.title.toLowerCase().contains(query) ||
              task.description.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  // Thêm hoặc Sửa Item
  void _showItemDialog({ItemModel? existingItem}) {
    final titleController = TextEditingController(text: existingItem?.title ?? '');
    final descController = TextEditingController(text: existingItem?.description ?? '');
    final isEditing = existingItem != null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Item' : 'Add New Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 8),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) return;

              if (isEditing) {
                existingItem.title = titleController.text.trim();
                existingItem.description = descController.text.trim();
              } else {
                _allTasks.add(ItemModel(
                  id: DateTime.now().millisecondsSinceEpoch % 10000,
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                ));
              }

              Navigator.pop(ctx);
              _autoSave();
            },
            child: Text(isEditing ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(ItemModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Confirmation'),
        content: Text('Are you sure you want to delete "${item.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              _allTasks.removeWhere((element) => element.id == item.id);
              Navigator.pop(ctx);
              _autoSave();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by title or description...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) {
                _searchQuery = val;
                _applyFilter();
              },
            ),
          ),
          // Danh sách hiển thị
          Expanded(
            child: _filteredTasks.isEmpty
                ? const Center(child: Text('No matching items found.'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final item = _filteredTasks[index];
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${item.id}')),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showItemDialog(existingItem: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}