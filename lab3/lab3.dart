import 'dart:async';
import 'dart:convert';

// EXERCISE 1: Product Model & Repository
class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

class ProductRepository {
  final List<Product> _products = [
    Product(id: 1, name: 'Laptop', price: 999.9),
    Product(id: 2, name: 'Mouse', price: 25.5),
  ];

  // Broadcast stream controller để nhiều listener có thể lắng nghe đồng thời
  final StreamController<Product> _addedController = StreamController<Product>.broadcast();

  // Future mô phỏng việc tải danh sách sản phẩm từ cơ sở dữ liệu/API
  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_products);
  }

  // Stream phát dữ liệu thời gian thực khi có sản phẩm mới
  Stream<Product> liveAdded() => _addedController.stream;

  // Thêm sản phẩm và đẩy vào Stream
  void addProduct(Product product) {
    _products.add(product);
    _addedController.add(product);
  }

  void dispose() {
    _addedController.close();
  }
}

Future<void> runExercise1() async {
  print('--- EXERCISE 1: Product Model & Repository ---');
  final repo = ProductRepository();

  // Đăng ký lắng nghe sự kiện Stream trước khi thêm sản phẩm
  final subscription = repo.liveAdded().listen((product) {
    print('[LIVE STREAM] Product newly added: $product');
  });

  print('Fetching all products using Future...');
  final products = await repo.getAll();
  for (var p in products) {
    print(' - $p');
  }

  // Thêm sản phẩm mới để kích hoạt luồng Stream
  print('Adding a new product...');
  repo.addProduct(Product(id: 3, name: 'Mechanical Keyboard', price: 89.0));

  await Future.delayed(const Duration(milliseconds: 200));
  await subscription.cancel();
  repo.dispose();
}

// EXERCISE 2: User Repository with JSON
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Factory constructor chuyển đổi Map (JSON) sang Object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  Future<List<User>> fetchUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Chuỗi JSON mô phỏng trả về từ REST API
    const jsonString = '''
    [
      {"name": "Duc Anh", "email": "anhldhe@fpt.edu.vn"},
      {"name": "Le Bao", "email": "lebao@gmail.com"}
    ]
    ''';

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((item) => User.fromJson(item as Map<String, dynamic>)).toList();
  }
}

Future<void> runExercise2() async {
  print('--- EXERCISE 2: User Repository with JSON ---');
  final repo = UserRepository();

  print('Fetching and parsing JSON list from API...');
  final users = await repo.fetchUsers();
  print('Parsed ${users.length} users successfully:');
  for (var user in users) {
    print(' -> ${user.name} (${user.email})');
  }
}

// EXERCISE 3: Async + Microtask Debugging
Future<void> runExercise3() async {
  print('--- EXERCISE 3: Async + Microtask Debugging ---');
  print('1. Synchronous: Start of Exercise 3');

  // Đẩy vào Event Queue
  Future(() {
    print('4. Event Queue: Future callback executed');
  });

  // Đẩy vào Microtask Queue
  scheduleMicrotask(() {
    print('3. Microtask Queue: Microtask callback executed');
  });
  print('2. Synchronous: End of Exercise 3');

  // Đợi một khoảng ngắn để Event Loop chạy hết các callback
  await Future.delayed(const Duration(milliseconds: 100));
}

// EXERCISE 4: Stream Transformation
Future<void> runExercise4() async {
  print('--- EXERCISE 4: Stream Transformation ---');

  // Khởi tạo Stream từ 1 đến 5
  final Stream<int> rawStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  print('Original Stream: [1, 2, 3, 4, 5]');
  print('Applying pipeline: where(isEven) -> map(square)');

  final Stream<int> transformedStream = rawStream
      .where((evenNum) => evenNum % 2 == 0)
      .map((square) => square * square);

  await for (var value in transformedStream) {
    print('Transformed emitted value: $value');
  }
}

// EXERCISE 5: Factory Constructors & Cache
class Settings {
  String theme;
  bool notifications;

  // 1. Biến static private giữ instance duy nhất làm bộ nhớ cache
  static Settings? _instance;

  // 2. Named constructor private ngăn việc khởi tạo đối tượng tự do từ bên ngoài
  Settings._internal({this.theme = 'Dark', this.notifications = true});

  // 3. Factory constructor luôn trả về instance duy nhất trong cache
  factory Settings() {
    _instance ??= Settings._internal();
    return _instance!;
  }
}

void runExercise5() {
  print('--- EXERCISE 5: Factory Constructors & Cache ---');

  // Khởi tạo hai đối tượng Settings
  final a = Settings();
  final b = Settings();

  print('Instance a initial theme: ${a.theme}');
  // Đổi thuộc tính trên a
  a.theme = 'Light';
  print('Instance b theme after modifying a: ${b.theme}');

  // Kiểm tra identical() để xác nhận 2 biến cùng trỏ về 1 vùng nhớ
  final isSame = identical(a, b);
  print('Are instance a and b identical? -> $isSame');

  if (isSame) {
    print('Singleton verification passed: Both instances refer to the exact same cached object.');
  }
}

void main() async {

  print('LAB 3');

  await runExercise1();

  await runExercise2();

  await runExercise3();

  await runExercise4();

  runExercise5();

}