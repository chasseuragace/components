import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/app_home_navigation/app_home_navigation_page.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/widgets/widgets.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/page/list.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/providers/onboarding_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/custom_snackbar.dart';

class OTPVerificationPage extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String? fullName;
  final bool isLogin;

  const OTPVerificationPage({
    super.key,
    required this.phoneNumber,
    this.fullName,
    this.isLogin = false,
  });

  @override
  ConsumerState<OTPVerificationPage> createState() =>
      _OTPVerificationPageState();
}

class _OTPVerificationPageState extends ConsumerState<OTPVerificationPage>
    with CodeAutoFill {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _resendCountdown = 60;
  bool _canResend = false;
  bool _isOtpComplete = false; // enable verify only when true

  @override
  void initState() {
    super.initState();
    _startCountdown();
    listenForCode(); // start SMS listener
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 6) {
      for (var i = 0; i < 6; i++) {
        _otpControllers[i].text = code![i];
      }
      FocusScope.of(context).unfocus();
      setState(() => _isOtpComplete = true);
    }
  }

  @override
  void dispose() {
    cancel(); // stop SMS listener
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _resendCountdown = 60;
      _canResend = false;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _resendCountdown--);
        if (_resendCountdown == 0) {
          setState(() => _canResend = true);
          return false;
        }
        return true;
      }
      return false;
    });
  }

  String get _otpCode {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _navigatePostAuth() async {
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

  Future<void> _verifyOTP() async {
    final otp = _otpCode;
    if (otp.length != 6) {
      CustomSnackbar.showFailureSnackbar(context, 'Please enter complete OTP');
      return;
    }

    try {
      final auth = ref.read(authControllerProvider.notifier);
      String token;

      if (widget.isLogin) {
        token = await auth.loginVerify(phone: widget.phoneNumber, otp: otp);
      } else {
        token = await auth.verify(phone: widget.phoneNumber, otp: otp);
      }

      if (token.isNotEmpty && mounted) {
        await _navigatePostAuth();
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showFailureSnackbar(
          context, 'Invalid OTP. Please try again.');
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;

    try {
      final auth = ref.read(authControllerProvider.notifier);

      if (widget.isLogin) {
        await auth.loginStart(phone: widget.phoneNumber);
      } else {
        await auth.register(
          fullName: widget.fullName ?? '',
          phone: widget.phoneNumber,
        );
      }
      if (!mounted) return;

      CustomSnackbar.showSuccessSnackbar(context, 'New OTP sent');
      _startCountdown();

      // Clear existing OTP
      for (var controller in _otpControllers) {
        controller.clear();
      }
      setState(() => _isOtpComplete = false);
      _focusNodes[0].requestFocus();
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showFailureSnackbar(context, 'Failed to resend OTP');
    }
  }

  Widget _buildOTPField(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          // Update completion state without auto-submitting
          setState(() => _isOtpComplete = _otpCode.length == 6);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              HeaderWidget(
                title: 'Verify OTP',
                subtitle:
                    'Enter the 6-digit code sent to ${widget.phoneNumber}',
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.borderColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          List.generate(6, (index) => _buildOTPField(index)),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Verify OTP',
                      onPressed: () => _isOtpComplete ? _verifyOTP : null,
                      isLoading: state.loading,
                    ),
                    const SizedBox(height: 16),
                    if (_canResend)
                      TextButton(
                        onPressed: _resendOTP,
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Text(
                        'Resend OTP in ${_resendCountdown}s',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              // if (_message != null) ...[
              //   const SizedBox(height: 16),
              //   Container(
              //     width: double.infinity,
              //     padding: const EdgeInsets.all(12),
              //     decoration: BoxDecoration(
              //       color: _message!.contains('failed') ||
              //               _message!.contains('Invalid')
              //           ? const Color(0xFFfef2f2)
              //           : const Color(0xFFf0f9ff),
              //       borderRadius: BorderRadius.circular(8),
              //       border: Border.all(
              //         color: _message!.contains('failed') ||
              //                 _message!.contains('Invalid')
              //             ? const Color(0xFFfecaca)
              //             : const Color(0xFFbae6fd),
              //       ),
              //     ),
              //     child: Text(
              //       _message!,
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         color: _message!.contains('failed') ||
              //                 _message!.contains('Invalid')
              //             ? const Color(0xFFdc2626)
              //             : const Color(0xFF0369a1),
              //         fontSize: 14,
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
