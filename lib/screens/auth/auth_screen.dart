import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _auth = AuthService();

  bool _isLogin = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _busy) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      if (_isLogin) {
        final res = await _auth.signIn(email: _emailCtrl.text.trim(), password: _passCtrl.text.trim());
        final user = res.user;
        if (user != null) {
          await _auth.upsertProfile(
            userId: user.id,
            fullName: (user.userMetadata?['full_name'] as String?) ?? 'Usuario',
            email: user.email ?? _emailCtrl.text.trim(),
          );
        }
      } else {
        final response = await _auth.signUp(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text.trim(),
          fullName: _nameCtrl.text.trim(),
        );

        if (response.session == null) {
          throw Exception('Activa Auto Confirm en Supabase > Authentication > Providers > Email para evitar verificacion por correo.');
        }
        if (response.user != null) {
          await _auth.upsertProfile(
            userId: response.user!.id,
            fullName: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.mainBackground,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: 460,
                padding: const EdgeInsets.all(22),
                decoration: AppTheme.cardDecoration(highlighted: true),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset('assets/logo.png', width: 52, height: 52, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Text(_isLogin ? 'Iniciar sesion' : 'Crear cuenta', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      if (!_isLogin) ...[
                        _field(
                          controller: _nameCtrl,
                          label: 'Nombre',
                          icon: Icons.person_outline,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa tu nombre' : null,
                        ),
                        const SizedBox(height: 12),
                      ],
                      _field(
                        controller: _emailCtrl,
                        label: 'Correo',
                        icon: Icons.email_outlined,
                        validator: (v) => (v == null || !v.contains('@')) ? 'Correo invalido' : null,
                      ),
                      const SizedBox(height: 12),
                      _field(
                        controller: _passCtrl,
                        label: 'Contrasena',
                        icon: Icons.lock_outline,
                        obscure: true,
                        validator: (v) => (v == null || v.length < 6) ? 'Minimo 6 caracteres' : null,
                      ),
                      const SizedBox(height: 14),
                      if (_error != null)
                        Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _busy ? null : _submit,
                          style: AppTheme.primaryButtonStyle,
                          child: _busy
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)),
                                )
                              : AppTheme.gradientButtonChild(
                                  text: _isLogin ? 'Entrar' : 'Registrarme',
                                  icon: _isLogin ? Icons.login : Icons.person_add,
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: _busy
                              ? null
                              : () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                    _error = null;
                                  });
                                },
                          child: Text(_isLogin ? 'No tienes cuenta? Registrate' : 'Ya tienes cuenta? Inicia sesion'),
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
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.neonCyan),
        filled: true,
        fillColor: const Color(0xFF16254A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.cardBorder),
        ),
      ),
    );
  }
}
