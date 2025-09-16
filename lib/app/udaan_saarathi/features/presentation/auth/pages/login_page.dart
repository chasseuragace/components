import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/pages/otp_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/pages/register_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/widgets/widgets.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/custom_snackbar.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneCtrl = TextEditingController();
  String? _message;
  bool isButtonEnabled = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  // Future<void> _navigatePostAuth(String phone, String otpOrToken) async {
  //   final shouldShowOnboarding =
  //       await ref.read(onboardingControllerProvider.future);
  //   if (!mounted) return;
  //   if (shouldShowOnboarding) {
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (_) => OnboardingListPage()),
  //     );
  //   } else {
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (_) => const AppHomeNavigationPage()),
  //     );
  //   }
  // }

  Future<void> _doLogin() async {
    final auth = ref.read(authControllerProvider.notifier);
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      setState(() => _message = 'Enter phone number');
      return;
    }
    // Async status and errors will be driven by AuthState
    try {
      final devOtp = await auth.loginStart(phone: phone);
      if (devOtp.isNotEmpty && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => OTPVerificationPage(
                    phoneNumber: phone,
                    isLogin: true,
                  )),
        );
      }
    } catch (e) {
      // AuthController will set error
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (prev, next) {
      if (prev?.responseState == ResponseStates.loading &&
          next.responseState == ResponseStates.success) {
        CustomSnackbar.showSuccessSnackbar(context, next.message!);
      }
      if (prev?.responseState == ResponseStates.loading &&
          next.responseState == ResponseStates.failure) {
        CustomSnackbar.showFailureSnackbar(context, next.message!);
      }
    });
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 60),

                        // Header
                        HeaderWidget(
                          title: 'Welcome back',
                          subtitle: 'Sign in to your account to continue',
                        ),

                        const SizedBox(height: 48),

                        // Form Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.borderColor
                                    .withValues(alpha: 0.5)),
                          ),
                          child: Column(
                            children: [
                              PhoneTextField(
                                phoneCtrl: _phoneCtrl,
                                onChange: (phone) {
                                  setState(() {
                                    isButtonEnabled = phone.length == 10;
                                  });
                                },
                              ),
                              const SizedBox(height: 24),
                              PrimaryButton(
                                text: 'Sign In',
                                onPressed: isButtonEnabled
                                    ? () {
                                        final valid =
                                            formKey.currentState?.validate() ??
                                                false;
                                        if (valid) {
                                          _doLogin();
                                        }
                                      }
                                    : null,
                                isLoading: state.loading,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Switch to Register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterPage()),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),

                        // Validation message (local)
                        // if (_message != null) ...[
                        //   const SizedBox(height: 16),
                        //   Container(
                        //     padding: const EdgeInsets.all(12),
                        //     decoration: BoxDecoration(
                        //       color: const Color(0xFFfef2f2),
                        //       borderRadius: BorderRadius.circular(8),
                        //       border: Border.all(color: const Color(0xFFfecaca)),
                        //     ),
                        //     child: Text(
                        //       _message!,
                        //       style: const TextStyle(
                        //         color: Color(0xFFdc2626),
                        //         fontSize: 14,
                        //       ),
                        //     ),
                        //   ),
                        // ],

                        // // Controller-driven error
                        // if (state.responseState == ResponseStates.failure) ...[
                        //   const SizedBox(height: 12),
                        //   Container(
                        //     padding: const EdgeInsets.all(12),
                        //     decoration: BoxDecoration(
                        //       color: const Color(0xFFfef2f2),
                        //       borderRadius: BorderRadius.circular(8),
                        //       border: Border.all(color: const Color(0xFFfecaca)),
                        //     ),
                        //     child: Text(
                        //       state.message!,
                        //       style: const TextStyle(
                        //         color: Color(0xFFdc2626),
                        //         fontSize: 14,
                        //       ),
                        //     ),
                        //   ),
                        // ],

                        // // Controller-driven info/success
                        // if (state.message != null) ...[
                        //   const SizedBox(height: 12),
                        //   Container(
                        //     padding: const EdgeInsets.all(12),
                        //     decoration: BoxDecoration(
                        //       color: const Color(0xFFf0f9ff),
                        //       borderRadius: BorderRadius.circular(8),
                        //       border: Border.all(color: const Color(0xFFbae6fd)),
                        //     ),
                        //     child: Text(
                        //       state.message!,
                        //       style: const TextStyle(
                        //         color: Color(0xFF0369a1),
                        //         fontSize: 14,
                        //       ),
                        //     ),
                        //   ),
                        // ],

                        // const SizedBox(height: 60),
                      ],
                    ),
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
