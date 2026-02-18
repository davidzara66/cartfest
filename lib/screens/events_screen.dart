import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../providers/mock_data_provider.dart';
import '../theme/app_theme.dart';

class EventsScreen extends StatefulWidget {
  final CarEvent event;

  const EventsScreen({super.key, required this.event});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  final _chatCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    setState(() {
      _timeLeft = widget.event.date.difference(DateTime.now());
      if (_timeLeft.isNegative) _timeLeft = Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _chatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MockDataProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('EVENTOS')),
      body: SafeArea(
        child: Container(
          decoration: AppTheme.mainBackground,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                decoration: AppTheme.cardDecoration(highlighted: true),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PROXIMO EVENTO',
                      style: TextStyle(
                        color: AppTheme.neonCyan,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.event.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.event.description,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _countBox(_timeLeft.inDays, 'DIAS'),
                        _countBox(_timeLeft.inHours % 24, 'HRS'),
                        _countBox(_timeLeft.inMinutes % 60, 'MIN'),
                        _countBox(_timeLeft.inSeconds % 60, 'SEG'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppTheme.neonOrange,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.event.location,
                          style: const TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openRegistrationForm(context),
                        icon: const Icon(Icons.app_registration),
                        label: const Text('Registrarme al evento'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                decoration: AppTheme.cardDecoration(),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(Icons.live_tv, color: AppTheme.neonMagenta),
                          SizedBox(width: 8),
                          Text(
                            'CHAT EN VIVO',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.white12),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: provider.eventChat.length,
                        itemBuilder: (context, i) {
                          final msg = provider.eventChat[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${msg.author}: ',
                                    style: const TextStyle(
                                      color: AppTheme.neonCyan,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: msg.text,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Escribe un mensaje...',
                                filled: true,
                                fillColor: Color(0xFF16254A),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: () {
                              provider.sendEventChatMessage(_chatCtrl.text);
                              _chatCtrl.clear();
                            },
                            icon: const Icon(Icons.send),
                            style: IconButton.styleFrom(
                              backgroundColor: AppTheme.neonMagenta,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openRegistrationForm(BuildContext context) async {
    final provider = context.read<MockDataProvider>();
    final formKey = GlobalKey<FormState>();
    final vehicleName = TextEditingController();
    final vehicleBrand = TextEditingController();
    final photoUrl = TextEditingController();

    String category = 'Street';
    String origin = kOrigins.first;
    String classification = kClassifications.first;
    final sections = <String>{};
    final selectedMods = <String>{};
    XFile? picked;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111B43),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: MediaQuery.of(ctx).padding.top + 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registro de vehiculo al evento',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _f(vehicleName, 'Nombre del vehiculo'),
                      _f(vehicleBrand, 'Marca'),
                      _f(photoUrl, 'URL foto del vehiculo (opcional)'),
                      const SizedBox(height: 6),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final img = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 85,
                          );
                          if (img != null) {
                            setModalState(() => picked = img);
                          }
                        },
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Subir foto del vehiculo'),
                      ),
                      if (picked != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: kIsWeb
                                ? Image.network(
                                    picked!.path,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(picked!.path),
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      DropdownButtonFormField<String>(
                        initialValue: category,
                        items: const ['Street', 'Pro', 'Master', 'Amateur']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setModalState(() => category = v ?? category),
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: origin,
                        items: kOrigins
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setModalState(() => origin = v ?? origin),
                        decoration: const InputDecoration(
                          labelText: 'Clasificado por origen',
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: classification,
                        items: kClassifications
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) => setModalState(
                          () => classification = v ?? classification,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Clasificacion de suscripcion',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Secciones a participar'),
                      Wrap(
                        spacing: 8,
                        children:
                            ['Motor', 'Suspension', 'Estetica', 'Audio', 'Aero']
                                .map(
                                  (s) => FilterChip(
                                    label: Text(s),
                                    selected: sections.contains(s),
                                    onSelected: (v) {
                                      setModalState(() {
                                        if (v) {
                                          sections.add(s);
                                        } else {
                                          sections.remove(s);
                                        }
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 10),
                      const Text('Modificaciones aplicadas'),
                      Wrap(
                        spacing: 8,
                        children: kModificationCatalog
                            .map(
                              (m) => FilterChip(
                                label: Text(m),
                                selected: selectedMods.contains(m),
                                onSelected: (v) {
                                  setModalState(() {
                                    if (v) {
                                      selectedMods.add(m);
                                    } else {
                                      selectedMods.remove(m);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            provider.registerToEvent(
                              eventId: widget.event.id,
                              vehicleName: vehicleName.text.trim(),
                              vehicleBrand: vehicleBrand.text.trim(),
                              vehiclePhotoUrl:
                                  picked?.path ?? photoUrl.text.trim(),
                              category: category,
                              origin: origin,
                              classification: classification,
                              sections: sections.toList(),
                              modifications: selectedMods.toList(),
                            );
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registro enviado correctamente'),
                              ),
                            );
                          },
                          child: const Text('Enviar registro'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _f(TextEditingController c, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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

  Widget _countBox(int value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF16254A),
          border: Border.all(color: AppTheme.cardBorder),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value.toString().padLeft(2, '0'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
