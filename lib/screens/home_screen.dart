import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mock_data_provider.dart';
import '../theme/app_theme.dart';
import 'direct_messages_screen.dart';
import 'events_screen.dart';
import 'feed_screen.dart';
import 'profile_screen.dart';
import 'ranking_screen.dart';
import 'team_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MockDataProvider>();

    final pages = [
      FeedScreen(onMenuTap: () => _scaffoldKey.currentState?.openEndDrawer()),
      const RankingScreen(),
      provider.teams.isNotEmpty
          ? TeamProfileScreen(team: provider.teams.first)
          : const Center(child: Text('No hay equipos')),
      provider.events.isNotEmpty
          ? EventsScreen(event: provider.events.first)
          : const Center(child: Text('No hay eventos')),
      const ProfileScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildShortcutDrawer(),
      body: IndexedStack(index: _currentIndex, children: pages),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.neonMagenta,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DirectMessagesScreen()));
        },
        child: const Icon(Icons.chat),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D1537),
        selectedItemColor: AppTheme.neonMagenta,
        unselectedItemColor: AppTheme.textSecondary,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Ranking'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Equipos'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Eventos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildShortcutDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF111B43),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset('assets/logo_icon.png', width: 44, height: 44),
                  ),
                  const SizedBox(width: 10),
                  const Text('Atajos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const Divider(color: Colors.white12),
            _shortcut('Feed', Icons.home_outlined, () => _goToTab(0)),
            _shortcut('Explorar', Icons.directions_car_outlined, () => _goToTab(0)),
            _shortcut('Ranking', Icons.emoji_events_outlined, () => _goToTab(1)),
            _shortcut('Competidores', Icons.groups_2_outlined, () => _goToTab(0)),
            _shortcut('Equipos', Icons.local_fire_department_outlined, () => _goToTab(2)),
            _shortcut('Eventos', Icons.calendar_month_outlined, () => _goToTab(3)),
            _shortcut('En Vivo', Icons.live_tv_outlined, () => _goToTab(3)),
            _shortcut('Mensajeria', Icons.chat_bubble_outline, () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DirectMessagesScreen()));
            }),
            _shortcut('Perfil', Icons.person_outline, () => _goToTab(4)),
          ],
        ),
      ),
    );
  }

  Widget _shortcut(String label, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label),
      onTap: onTap,
    );
  }

  void _goToTab(int index) {
    Navigator.pop(context);
    setState(() => _currentIndex = index);
  }
}
