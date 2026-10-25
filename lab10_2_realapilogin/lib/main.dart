import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const RealApiLoginApp());
}

class RealApiLoginApp extends StatelessWidget {
  const RealApiLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.2 - Real API Login',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const LoginScreen(),
    );
  }
}

// Màn đăng nhập
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController(text: 'emilys');
  final TextEditingController _passwordController = TextEditingController(text: 'emilyspass');

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleRealLogin() async {
    // Kiểm tra validation
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    const String apiUrl = 'https://dummyjson.com/auth/login';

    try {
      // Gửi POST request lên DummyJSON
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
          'expiresInMins': 30,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      // Phản hồi từ Server
      if (response.statusCode == 200) {
        // DummyJSON trả về accessToken
        final String token = data['accessToken'] ?? data['token'] ?? '';
        final String fullName = '${data['firstName']} ${data['lastName']}';
        final String email = data['email'] ?? '';
        final String avatarUrl = data['image'] ?? '';

        if (!mounted) return;
        setState(() => _isLoading = false);

        // Chuyển sang màn hình Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              fullName: fullName,
              email: email,
              avatarUrl: avatarUrl,
              token: token,
            ),
          ),
        );
      } else {
        // Trường hợp server trả về lỗi
        if (!mounted) return;
        setState(() => _isLoading = false);
        final errorMessage = data['message'] ?? 'Tài khoản hoặc mật khẩu không đúng!';
        _showError(errorMessage);
      }
    } catch (e) {
      // Trường hợp mất mạng hoặc không kết nối được server
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Không thể kết nối đến máy chủ: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.2 – DummyJSON Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.cloud_sync_outlined, size: 70, color: Colors.teal),
                  const SizedBox(height: 16),
                  const Text(
                    'Real REST API Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Endpoint: https://dummyjson.com/auth/login',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Ô nhập Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Vui lòng nhập username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Ô nhập Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Vui lòng nhập password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Nút Submit
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRealLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text('Log In via REST API', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 20),

                  // Gợi ý thông tin kiểm thử
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal.shade200),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DummyJSON Demo Account:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text('• Username: emilys', style: TextStyle(fontSize: 12)),
                        Text('• Password: emilyspass', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Màn hình dashboard
class HomeScreen extends StatelessWidget {
  final String fullName;
  final String email;
  final String avatarUrl;
  final String token;

  const HomeScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                child: avatarUrl.isEmpty ? const Icon(Icons.person, size: 45) : null,
              ),
              const SizedBox(height: 16),
              Text(
                fullName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                color: Colors.teal.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.teal.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.vpn_key_outlined, size: 18, color: Colors.teal),
                          SizedBox(width: 8),
                          Text(
                            'Parsed JWT Token from DummyJSON:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        token,
                        style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Đăng xuất'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}