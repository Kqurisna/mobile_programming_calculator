import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../data/group_data.dart';
import '../../utils/page_transitions.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorText;
  bool _loading = false;
  int _attempts = 0;
  static const _maxAttempts = 3;

  late final AnimationController _entrance;
  late final Animation<double> _entranceCurve;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _entranceCurve = CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic);
    _entrance.forward();
  }

  void _handleLogin() async {
    if (_attempts >= _maxAttempts) return;
    HapticFeedback.lightImpact();

    setState(() {
      _errorText = null;
      _loading = true;
    });

    await Future.delayed(const Duration(milliseconds: 320));

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      HapticFeedback.mediumImpact();
      setState(() {
        _loading = false;
        _errorText = 'Username atau password tidak boleh kosong.';
      });
      return;
    }

    final match = groupData.where(
      (u) => u.username.toLowerCase() == username.toLowerCase() && u.password == password,
    );

    if (match.isNotEmpty) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        fadeSlideRoute(HomeScreen(username: match.first.username)),
      );
    } else {
      HapticFeedback.mediumImpact();
      _attempts++;
      setState(() {
        _loading = false;
        _errorText = _attempts >= _maxAttempts
            ? 'Gagal login setelah $_maxAttempts percobaan.'
            : 'Username atau password salah. Percobaan ke-$_attempts dari $_maxAttempts.';
      });
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locked = _attempts >= _maxAttempts;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.loginBg,
          ),
        ),
        child: Stack(
          children: [
            // hanya 2 elemen dekoratif — sengaja diminimalkan, jangan ramai
            Positioned(
              top: -60,
              right: -50,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.turquoise.withOpacity(0.10),
                ),
              ),
            ),
            Positioned(
              bottom: -90,
              left: -60,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cyan.withOpacity(0.08),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxxl),
                  child: FadeTransition(
                    opacity: _entranceCurve,
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(_entranceCurve),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xxxl),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          boxShadow: AppShadow.elevated,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: const Icon(Icons.calculate_rounded, color: AppColors.primaryBlue, size: 28),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            const Text('Selamat Datang', style: AppText.h1),
                            const SizedBox(height: AppSpacing.xs),
                            const Text('Masuk untuk mengakses Kalkulator Kelompok', style: AppText.bodyMuted),
                            const SizedBox(height: AppSpacing.xxl),

                            const Text('USERNAME', style: AppText.label),
                            const SizedBox(height: AppSpacing.sm),
                            _buildInput(
                              controller: _usernameController,
                              hint: 'Masukkan username',
                              icon: Icons.person_outline_rounded,
                              enabled: !locked,
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            const Text('PASSWORD', style: AppText.label),
                            const SizedBox(height: AppSpacing.sm),
                            _buildInput(
                              controller: _passwordController,
                              hint: 'Masukkan password',
                              icon: Icons.lock_outline_rounded,
                              obscure: _obscurePassword,
                              enabled: !locked,
                              trailing: IconButton(
                                splashRadius: 20,
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  size: 19,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                            ),

                            AnimatedSize(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                              child: _errorText != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: AppSpacing.md),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.error_outline_rounded, size: 15, color: Color(0xFFD64545)),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              _errorText!,
                                              style: const TextStyle(color: Color(0xFFD64545), fontSize: 12.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),

                            const SizedBox(height: AppSpacing.xxl),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: (_loading || locked) ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: locked ? const Color(0xFFCBD5E0) : AppColors.loginButton,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                                      )
                                    : Text(locked ? 'Terkunci' : 'Masuk', style: AppText.button.copyWith(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    bool enabled = true,
    Widget? trailing,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      style: const TextStyle(fontSize: 14.5, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAB6C2), fontSize: 14),
        prefixIcon: Icon(icon, size: 19, color: AppColors.textMuted),
        suffixIcon: trailing,
        filled: true,
        fillColor: AppColors.inputBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.inputBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.inputBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.3)),
      ),
    );
  }
}
