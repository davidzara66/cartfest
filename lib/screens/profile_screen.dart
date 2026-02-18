import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../providers/mock_data_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _handle;
  late TextEditingController _bio;
  late TextEditingController _country;
  late TextEditingController _avatar;
  late String _classification;

  @override
  void initState() {
    super.initState();
    final p = context.read<MockDataProvider>().currentUser;
    _name = TextEditingController(text: p.name);
    _handle = TextEditingController(text: p.handle);
    _bio = TextEditingController(text: p.bio);
    _country = TextEditingController(text: p.country);
    _avatar = TextEditingController(text: p.avatarUrl);
    _classification = p.classification;
  }

  @override
  void dispose() {
    _name.dispose();
    _handle.dispose();
    _bio.dispose();
    _country.dispose();
    _avatar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<MockDataProvider>().currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Container(
        decoration: AppTheme.mainBackground,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: AppTheme.cardDecoration(),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(radius: 38, backgroundImage: NetworkImage(profile.avatarUrl)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                        Text(profile.handle, style: const TextStyle(color: AppTheme.neonMagenta)),
                        Text('${profile.country} • ${profile.classification}', style: const TextStyle(color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Container(
                decoration: AppTheme.cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _f(_name, 'Nombre'),
                    _f(_handle, 'Usuario (@handle)'),
                    _f(_bio, 'Bio', maxLines: 3),
                    _f(_country, 'Pais'),
                    DropdownButtonFormField<String>(
                      initialValue: _classification,
                      items: kClassifications
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _classification = v ?? _classification),
                      decoration: const InputDecoration(
                        labelText: 'Clasificacion',
                        filled: true,
                        fillColor: Color(0xFF16254A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _f(_avatar, 'URL Foto de perfil'),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          context.read<MockDataProvider>().updateProfile(
                                name: _name.text.trim(),
                                handle: _handle.text.trim(),
                                bio: _bio.text.trim(),
                                country: _country.text.trim(),
                                avatarUrl: _avatar.text.trim(),
                                classification: _classification,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
                        },
                        style: AppTheme.primaryButtonStyle,
                        child: AppTheme.gradientButtonChild(text: 'Guardar cambios', icon: Icons.save),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _f(TextEditingController c, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
        decoration: InputDecoration(labelText: label, filled: true, fillColor: const Color(0xFF16254A)),
      ),
    );
  }
}
