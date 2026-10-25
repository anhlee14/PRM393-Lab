class ItemModel {
  final int id;
  String title;
  String description;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
  });

  // Chuyển từ Map JSON sang Object
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  // Chuyển từ Object sang Map JSON để ghi vào file
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}