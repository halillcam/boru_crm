import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignInPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email ve şifre boş bırakılamaz')));
      return;
    }

    context.read<AuthCubit>().signIn(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
          // AuthAuthenticated durumunda yönlendirme işini ileride
          // main.dart'taki bir "auth listener" widget'ında yapacağız.
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400), // <-- bunu ekle
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.bar_chart, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(AppStrings.appName, style: AppTextStyles.heading),
                      const SizedBox(height: 6),
                      Text(AppStrings.loginSubtitle, style: AppTextStyles.subtitle),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: AppStrings.emailLabel,
                        hint: AppStrings.emailHint,
                        icon: Icons.email_outlined,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: AppStrings.passwordLabel,
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        obscureText: true,
                        trailing: Text(AppStrings.forgotPassword, style: AppTextStyles.linkText),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: AppStrings.signIn,
                        isLoading: isLoading,
                        onPressed: _onSignInPressed,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppStrings.noAccount, style: AppTextStyles.subtitle),
                          GestureDetector(
                            onTap: () {
                              // signup ekranına yönlendirir
                            },
                            child: Text(AppStrings.signUp, style: AppTextStyles.linkText),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
