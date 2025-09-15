import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/app_home_navigation/app_home_navigation_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/pages/login_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/pages/otp_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/widgets/widgets.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/providers/onboarding_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/input_decoration.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  // final _emailCtrl = TextEditingController();
  // final _usernameCtrl = TextEditingController();
  // final _passwordCtrl = TextEditingController();
  String? _message;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    // _emailCtrl.dispose();
    // _usernameCtrl.dispose();
    // _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _navigatePostAuth(String phone, String otpOrToken) async {
    final shouldShowOnboarding =
        await ref.read(onboardingControllerProvider.future);
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

  Future<void> _doRegister() async {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //       builder: (_) => OTPVerificationPage(
    //             phoneNumber: _phoneCtrl.text.trim(),
    //             fullName: _nameCtrl.text.trim(),
    //             isLogin: false,
    //           )),
    // );
    final auth = ref.read(authControllerProvider.notifier);
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    // final email = _emailCtrl.text.trim();
    // final username = _usernameCtrl.text.trim();
    // final password = _passwordCtrl.text.trim();

    if (name.isEmpty || phone.isEmpty
        // email.isEmpty ||
        // username.isEmpty ||
        // password.isEmpty
        ) {
      setState(() => _message = 'Please fill all fields');
      return;
    }
    setState(() => _message = 'Registering...');
    try {
      final devOtp = await auth.register(fullName: name, phone: phone);

      if (devOtp.isNotEmpty && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => OTPVerificationPage(
                    phoneNumber: phone,
                    fullName: name,
                    isLogin: false,
                  )),
        );
      }
    } catch (e) {
      setState(() => _message = 'Register failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),

                      // Header
                      HeaderWidget(
                        title: 'Create account',
                        subtitle: 'Get started with your new account',
                      ),

                      const SizedBox(height: 32),

                      // Form Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.borderColor.withOpacity(0.5)),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _nameCtrl,
                              textCapitalization: TextCapitalization.words,
                              decoration: minimalistInputDecoration(
                                'Full name',
                                icon: Icons.person_outline,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // TextField(
                            //   controller: _usernameCtrl,
                            //   decoration: minimalistInputDecoration(
                            //     'Username',
                            //     icon: Icons.alternate_email_outlined,
                            //   ),
                            // ),
                            // const SizedBox(height: 16),
                            // TextField(
                            //   controller: _emailCtrl,
                            //   keyboardType: TextInputType.emailAddress,
                            //   decoration: minimalistInputDecoration(
                            //     'Email address',
                            //     icon: Icons.mail_outline,
                            //   ),
                            // ),
                            // const SizedBox(height: 16),
                            TextField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              decoration: minimalistInputDecoration(
                                'Phone number',
                                icon: Icons.phone_outlined,
                              ),
                            ),
                            // const SizedBox(height: 16),
                            // TextField(
                            //   controller: _passwordCtrl,
                            //   obscureText: true,
                            //   decoration: minimalistInputDecoration(
                            //     'Password',
                            //     icon: Icons.lock_outline,
                            //   ),
                            // ),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              text: 'Create Account',
                              onPressed: _doRegister,
                              isLoading: state.loading,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Switch to Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),

                      if (_message != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _message!.contains('failed')
                                ? const Color(0xFFfef2f2)
                                : const Color(0xFFf0f9ff),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _message!.contains('failed')
                                  ? const Color(0xFFfecaca)
                                  : const Color(0xFFbae6fd),
                            ),
                          ),
                          child: Text(
                            _message!,
                            style: TextStyle(
                              color: _message!.contains('failed')
                                  ? const Color(0xFFdc2626)
                                  : const Color(0xFF0369a1),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
