import 'package:flutter/material.dart';

void main() {
  runApp(const MockLoginApp());
}

class MockLoginApp extends StatelessWidget {
  const MockLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.1 - Mock Login',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const LoginScreen(),
    );
  }
}

// 1. Đăng nhập
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // Tài khoản mẫu
  final String _mockEmail = 'student@fpt.edu.vn';
  final String _mockPassword = 'password123';

  Future<void> _handleLogin() async {
    // Kiểm tra tính hợp lệ của Form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final inputEmail = _emailController.text.trim();
    final inputPassword = _passwordController.text;

    // Kiểm tra thông tin đăng nhập
    if (inputEmail == _mockEmail && inputPassword == _mockPassword) {
      setState(() {
        _isLoading = false;
      });

      const mockToken = 'mock_jwt_token_PRM393_xyz987654321';

      // hiển thị Home khi thành công
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userEmail: inputEmail, token: mockToken),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });

      // Báo lỗi nếu nhập sai
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email hoặc mật khẩu không chính xác!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Icon(Icons.lock_person, size: 72, color: Colors.indigo),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Lab 10.1 - Mock Authentication Flow',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Ô nhập Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Định dạng email không hợp lệ';
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
                      prefixIcon: const Icon(Icons.key_outlined),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      if (value.length < 6) {
                        return 'Mật khẩu phải từ 6 ký tự trở lên';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Nút Log In
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : const Text('Log In', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 16),

                  // Thông tin tài khoản test
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Credentials:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text('• Email: student@fpt.edu.vn', style: TextStyle(fontSize: 12)),
                        Text('• Password: password123', style: TextStyle(fontSize: 12)),
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
  final String userEmail;
  final String token;

  const HomeScreen({
    super.key,
    required this.userEmail,
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.indigo,
                child: Icon(Icons.check, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Đăng nhập thành công!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Xin chào: $userEmail',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: Colors.indigo.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Text(
                        'Mock Token nhận được:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        token,
                        textAlign: TextAlign.center,
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