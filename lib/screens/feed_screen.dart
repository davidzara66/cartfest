import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mock_data_provider.dart';
import '../theme/app_theme.dart';
import 'vehicle_detail_screen.dart';

class FeedScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const FeedScreen({super.key, this.onMenuTap});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MockDataProvider>();
    final posts = provider.posts;

    return Container(
      decoration: AppTheme.mainBackground,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
        children: [
          _buildTopBar(),
          const SizedBox(height: 10),
          _buildStories(provider),
          const SizedBox(height: 10),
          _buildTabs(),
          const SizedBox(height: 12),
          ...posts.where((post) {
            if (_tab == 1) {
              return provider.followingIds.contains(post.authorId);
            }
            return true;
          }).map((post) {
            final user = provider.findUserById(post.authorId);
            final vehicle = provider.findVehicleById(post.vehicleId);
            if (user == null || vehicle == null) return const SizedBox.shrink();
            return _postCard(provider, user, vehicle, post);
          }),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset('assets/logo_icon.png', width: 40, height: 40),
        ),
        const Spacer(),
        IconButton(
          onPressed: widget.onMenuTap,
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildStories(MockDataProvider provider) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: AppTheme.cardDecoration(),
      child: SizedBox(
        height: 95,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: provider.stories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, i) {
            final story = provider.stories[i];
            final user = provider.findUserById(story.userId);
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: AppTheme.fireGradient,
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(user?.avatarUrl ?? story.imageUrl),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 64,
                  child: Text(
                    user?.handle ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          _tabButton('Para Ti', 0),
          _tabButton('Siguiendo', 1),
          _tabButton('Trending', 2),
        ],
      ),
    );
  }

  Widget _tabButton(String text, int value) {
    final selected = _tab == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppTheme.neonMagenta : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(text, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _postCard(MockDataProvider provider, dynamic user, dynamic vehicle, dynamic post) {
    final hp = (vehicle.stats['Power'] ?? vehicle.stats['Motor'] ?? 0).toInt();
    final following = provider.followingIds.contains(user.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl)),
            title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(user.handle),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user.isPro)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.neonMagenta.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('PRO', style: TextStyle(color: AppTheme.neonMagenta)),
                  ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => provider.toggleFollow(user.id),
                  child: Text(following ? 'Siguiendo' : 'Seguir'),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Image.network(vehicle.imageUrl, height: 220, width: double.infinity, fit: BoxFit.cover),
              Positioned(
                top: 10,
                right: 10,
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicle: vehicle)));
                  },
                  style: FilledButton.styleFrom(backgroundColor: AppTheme.neonMagenta),
                  child: const Text('Ver en 3D'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${vehicle.brand} ${vehicle.name}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppTheme.neonOrange, borderRadius: BorderRadius.circular(20)),
                      child: Text('$hp HP', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('${vehicle.year} • ${vehicle.origin.toLowerCase()}'),
                const SizedBox(height: 10),
                Text(post.caption, style: const TextStyle(color: AppTheme.textSecondary)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: vehicle.modifications
                      .map<Widget>((m) => Chip(
                            label: Text(m),
                            backgroundColor: const Color(0xFF1B2B57),
                            side: const BorderSide(color: AppTheme.cardBorder),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
