import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/item_model.dart';

class StorageService {
  static const String _fileName = 'local_database.json';

  // Lấy đường dẫn file JSON trong thư mục Documents của ứng dụng
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // Đọc dữ liệu từ file JSON
  Future<List<ItemModel>> readItems() async {
    try {
      final file = await _getLocalFile();

      // Nếu file chưa tồn tại thì tạo file mới với danh sách rỗng
      if (!await file.exists()) {
        await file.writeAsString(jsonEncode([]));
        return [];
      }

      final contents = await file.readAsString();
      if (contents.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((item) => ItemModel.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // Lưu danh sách items vào file
  Future<File> writeItems(List<ItemModel> items) async {
    final file = await _getLocalFile();
    final jsonList = items.map((item) => item.toJson()).toList();
    return file.writeAsString(jsonEncode(jsonList));
  }
}