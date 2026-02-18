import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/app_models.dart';
import '../providers/mock_data_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/smart_image.dart';

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
  late String _classification;
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    final p = context.read<MockDataProvider>().currentUser;
    _name = TextEditingController(text: p.name);
    _handle = TextEditingController(text: p.handle);
    _bio = TextEditingController(text: p.bio);
    _country = TextEditingController(text: p.country);
    _classification = p.classification;
    _avatarPath = p.avatarUrl;
  }

  @override
  void dispose() {
    _name.dispose();
    _handle.dispose();
    _bio.dispose();
    _country.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<MockDataProvider>().currentUser;
    final avatar = _avatarPath?.isNotEmpty == true
        ? _avatarPath!
        : profile.avatarUrl;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: SafeArea(
        child: Container(
          decoration: AppTheme.mainBackground,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                decoration: AppTheme.cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      child: ClipOval(
                        child: SizedBox.expand(
                          child: SmartImage(source: avatar, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            profile.handle,
                            style: const TextStyle(color: AppTheme.neonMagenta),
                          ),
                          Text(
                            '${profile.country} - ${profile.classification}',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                            ),
                          ),
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
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (v) => setState(
                          () => _classification = v ?? _classification,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Clasificacion',
                          filled: true,
                          fillColor: Color(0xFF16254A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 85,
                            );
                            if (picked == null) return;
                            setState(() => _avatarPath = picked.path);
                          },
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text('Cambiar foto de perfil (local)'),
                        ),
                      ),
                      if (_avatarPath != null && _avatarPath!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: SizedBox(
                            height: 120,
                            width: 120,
                            child: SmartImage(
                              source: _avatarPath!,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
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
                              avatarUrl: _avatarPath ?? profile.avatarUrl,
                              classification: _classification,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Perfil actualizado'),
                              ),
                            );
                          },
                          style: AppTheme.primaryButtonStyle,
                          child: AppTheme.gradientButtonChild(
                            text: 'Guardar cambios',
                            icon: Icons.save,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFF16254A),
        ),
      ),
    );
  }
}
