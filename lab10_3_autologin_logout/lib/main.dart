import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const AutoLoginApp());
}

class AutoLoginApp extends StatelessWidget {
  const AutoLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.3 - Auto Login & Logout',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const SplashScreen(),
    );
  }
}

// Kiểm tra đăng nhập
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSavedSession();
  }

  Future<void> _checkSavedSession() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final prefs = await SharedPreferences.getInstance();
    final String? savedToken = prefs.getString('auth_token');
    final String savedName = prefs.getString('user_name') ?? 'User';

    if (!mounted) return;

    if (savedToken != null && savedToken.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userName: savedName, token: savedToken),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_clock, size: 72, color: Colors.deepPurple),
            SizedBox(height: 16),
            Text(
              'Checking User Session...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// Đăng nhập
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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    const String apiUrl = 'https://dummyjson.com/auth/login';

    try {
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

      if (response.statusCode == 200) {
        final String token = data['accessToken'] ?? data['token'] ?? '';
        final String fullName = '${data['firstName']} ${data['lastName']}';

        // lưu token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_name', fullName);

        if (!mounted) return;
        setState(() => _isLoading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userName: fullName, token: token),
          ),
        );
      } else {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showError(data['message'] ?? 'Tài khoản hoặc mật khẩu không đúng!');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Lỗi kết nối: $e');
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
      appBar: AppBar(title: const Text('Lab 10.3 - Login Screen')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.account_circle, size: 70, color: Colors.deepPurple),
                  const SizedBox(height: 16),
                  const Text(
                    'Login & Save Session',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập username' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Nhập password' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Log In & Save Session', style: TextStyle(fontSize: 16)),
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

// Màn dashboard
class HomeScreen extends StatelessWidget {
  final String userName;
  final String token;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.token,
  });

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_name');

    if (!context.mounted) return;

    // Chuyển hướng về lại màn hình Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
              const SizedBox(height: 12),
              Text(
                'Welcome, $userName!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Token đã được lưu trong SharedPreferences.\nHãy đóng app (hoặc Hot Restart) để kiểm tra Auto-login.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.deepPurple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saved Token in Device:',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Log Out (Clear Session)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red,
                ),
                onPressed: () => _handleLogout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}