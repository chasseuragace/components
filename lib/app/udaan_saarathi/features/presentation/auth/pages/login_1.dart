import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/app_home_navigation/app_home_navigation_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/providers/onboarding_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _isRegister = true; // toggle between register and login
  String? _message;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
    final auth = ref.read(authControllerProvider.notifier);
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    if (name.isEmpty || phone.isEmpty) {
      setState(() => _message = 'Enter name and phone');
      return;
    }
    setState(() => _message = 'Registering...');
    try {
      final devOtp = await auth.register(fullName: name, phone: phone);
      // Auto-verify in dev using returned OTP
      final token = await auth.verify(phone: phone, otp: devOtp);
      if (token.isNotEmpty && mounted) {
        // Decide destination by onboarding controller
        final shouldShowOnboarding = await ref.read(onboardingControllerProvider.future);
        if (!mounted) return;
        if (shouldShowOnboarding) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => OnboardingListPage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AppHomeNavigationPage()),
          );
        }
      }
    } catch (e) {
      setState(() => _message = 'Register failed');
    }
  }

  Future<void> _doLogin() async {
    final auth = ref.read(authControllerProvider.notifier);
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      setState(() => _message = 'Enter phone');
      return;
    }
    setState(() => _message = 'Starting login...');
    try {
      final devOtp = await auth.loginStart(phone: phone);
      final token = await auth.loginVerify(phone: phone, otp: devOtp);
      if (token.isNotEmpty && mounted) {
        final shouldShowOnboarding = await ref.read(onboardingControllerProvider.future);
        if (!mounted) return;
        if (shouldShowOnboarding) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => OnboardingListPage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AppHomeNavigationPage()),
          );
        }
      }
    } catch (e) {
      setState(() => _message = 'Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Candidate Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Register'),
                  selected: _isRegister,
                  onSelected: (v) => setState(() => _isRegister = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Login'),
                  selected: !_isRegister,
                  onSelected: (v) => setState(() => _isRegister = false),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isRegister) ...[
              const Text('Full Name'),
              TextField(controller: _nameCtrl),
              const SizedBox(height: 12),
            ],
            const Text('Phone (+977...)'),
            TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            if (state.loading) const Text('Loading...')
            else ...[
              ElevatedButton(
                onPressed: _isRegister ? _doRegister : _doLogin,
                child: Text(_isRegister ? 'Register' : 'Login'),
              ),
            ],
            if (_message != null) ...[
              const SizedBox(height: 8),
              Text(_message!),
            ]
          ],
        ),
      ),
    );
  }
}
