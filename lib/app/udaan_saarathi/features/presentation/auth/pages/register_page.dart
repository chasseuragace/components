import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/enum/response_states.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/services/custom_validator.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/auth_controller.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/widgets/widgets.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/custom_snackbar.dart';
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
  bool isButtonEnabled = false;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    // _emailCtrl.dispose();
    // _usernameCtrl.dispose();
    // _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
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
    // Async status and errors will be driven by AuthState
    try {
      final devOtp = await auth.register(fullName: name, phone: phone);

      if (devOtp.isNotEmpty && mounted) {
        Navigator.of(context).pushNamed(
          RouteConstants.kOtpScreen,
          arguments: [phone, false, devOtp, name],
        );

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (_) => OTPVerificationPage(
        //             phoneNumber: phone,
        //             fullName: name,
        //             isLogin: false,
        //             devOtp: devOtp,
        //           )),
        // );
      }
    } catch (e) {
      // AuthController will set error
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
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
                          child: Form(
                            key: formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? input) =>
                                      CustomValidator.nameValidator(
                                          type: "Full name", input: input),
                                  controller: _nameCtrl,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: minimalistInputDecoration(
                                    'Full name',
                                    icon: Icons.person_outline,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      final nameOk = value.trim().isNotEmpty;
                                      final phoneOk =
                                          _phoneCtrl.text.trim().length == 10;
                                      isButtonEnabled = nameOk && phoneOk;
                                    });
                                  },
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
                                PhoneTextField(
                                  phoneCtrl: _phoneCtrl,
                                  onChange: (phone) {
                                    setState(() {
                                      final nameOk =
                                          _nameCtrl.text.trim().isNotEmpty;
                                      final phoneOk = phone.length == 10;
                                      isButtonEnabled = nameOk && phoneOk;
                                    });
                                  },
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
                                  onPressed: isButtonEnabled
                                      ? () {
                                          final valid = formKey.currentState
                                                  ?.validate() ??
                                              false;
                                          if (valid) {
                                            _doRegister();
                                          }
                                        }
                                      : null,
                                  isLoading: state.loading,
                                ),
                              ],
                            ),
                          )),

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
                              Navigator.of(context).pushReplacementNamed(
                                RouteConstants.kLogin,
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

                      // const SizedBox(height: 40),
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
