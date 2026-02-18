import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';

class TeamProfileScreen extends StatelessWidget {
  final Team team;

  const TeamProfileScreen({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.mainBackground,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(team.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&q=80&w=1200',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xEE0A1133)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppTheme.cardDecoration(highlighted: true),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: AppTheme.neonOrange),
                              const SizedBox(width: 6),
                              Text(team.country, style: const TextStyle(color: AppTheme.textSecondary)),
                              const Spacer(),
                              Text(
                                '${team.totalPoints} pts',
                                style: const TextStyle(color: AppTheme.neonCyan, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(team.description, style: const TextStyle(height: 1.4)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _statCard('MIEMBROS', '${team.memberIds.length}', Icons.people_alt_outlined, AppTheme.neonMagenta)),
                        const SizedBox(width: 10),
                        Expanded(child: _statCard('TROFEOS', '${team.totalTrophies}', Icons.emoji_events_outlined, AppTheme.neonOrange)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text('VEHICULOS DEL EQUIPO', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) => Container(
                          width: 220,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: AppTheme.cardDecoration(),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            'https://images.unsplash.com/photo-1493238792000-8113da705763?auto=format&fit=crop&q=80&w=900',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: AppTheme.primaryButtonStyle,
                        child: AppTheme.gradientButtonChild(
                          text: 'Solicitar unirse al equipo',
                          icon: Icons.group_add,
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
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
