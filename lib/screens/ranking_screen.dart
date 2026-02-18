import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../providers/mock_data_provider.dart';
import '../theme/app_theme.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = context.watch<MockDataProvider>().vehicles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RANKING'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.neonMagenta,
          labelColor: Colors.white,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: const [
            Tab(text: 'EUROPEO'),
            Tab(text: 'ASIATICO'),
            Tab(text: 'AMERICANO'),
          ],
        ),
      ),
      body: Container(
        decoration: AppTheme.mainBackground,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildRankingList(
              vehicles.where((v) => v.origin.toLowerCase().contains('euro')).toList(),
            ),
            _buildRankingList(
              vehicles.where((v) => v.origin.toLowerCase().contains('asia')).toList(),
            ),
            _buildRankingList(
              vehicles.where((v) => v.origin.toLowerCase().contains('amer')).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingList(List<Vehicle> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text(
          'No hay vehiculos en esta categoria',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final vehicle = list[index];
        final hp = (vehicle.stats['Power'] ?? vehicle.stats['Motor'] ?? 0).toInt();

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: AppTheme.cardDecoration(highlighted: index == 0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              backgroundColor: index == 0 ? AppTheme.neonOrange : AppTheme.neonBlue,
              child: Text('${index + 1}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            title: Text('${vehicle.brand} ${vehicle.name}', style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('${vehicle.ownerName} • ${vehicle.origin}', style: const TextStyle(color: AppTheme.textSecondary)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${vehicle.votes} votos', style: const TextStyle(color: AppTheme.neonOrange, fontWeight: FontWeight.w700)),
                Text('$hp HP', style: const TextStyle(color: AppTheme.neonCyan, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        );
      },
    );
  }
}
