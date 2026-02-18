import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/app_models.dart';
import '../providers/mock_data_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/smart_image.dart';
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
    final stories = provider.stories;

    return SafeArea(
      child: Container(
        decoration: AppTheme.mainBackground,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
          children: [
            _buildTopBar(),
            const SizedBox(height: 10),
            _buildStories(provider, stories),
            const SizedBox(height: 10),
            _buildTabs(),
            const SizedBox(height: 12),
            ...provider.posts
                .where((post) {
                  if (_tab == 1)
                    return provider.followingIds.contains(post.authorId);
                  return true;
                })
                .map((post) {
                  final user = provider.findUserById(post.authorId);
                  final vehicle = provider.findVehicleById(post.vehicleId);
                  if (user == null || vehicle == null)
                    return const SizedBox.shrink();
                  return _postCard(provider, user, vehicle, post);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset('assets/logo.png', width: 40, height: 40),
        ),
        const SizedBox(width: 10),
        const Text(
          'CARFEST',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
        ),
        const Spacer(),
        IconButton(
          onPressed: _createPost,
          icon: const Icon(Icons.add_box_outlined, color: Colors.white),
        ),
        IconButton(
          onPressed: widget.onMenuTap,
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
      ],
    );
  }

  Future<void> _createPost() async {
    final provider = context.read<MockDataProvider>();
    final caption = TextEditingController();
    XFile? picked;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111B43),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModal) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: MediaQuery.of(ctx).padding.top + 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Crear publicacion',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: caption,
                  decoration: const InputDecoration(labelText: 'Descripcion'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final img = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );
                    if (img != null) setModal(() => picked = img);
                  },
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Subir imagen local'),
                ),
                if (picked != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SmartImage(
                      source: picked!.path,
                      height: 120,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: picked == null
                        ? null
                        : () {
                            provider.createPost(
                              caption: caption.text.trim().isEmpty
                                  ? 'Nuevo build publicado'
                                  : caption.text.trim(),
                              imageUrl: picked!.path,
                            );
                            Navigator.pop(ctx);
                          },
                    child: const Text('Publicar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStories(MockDataProvider provider, List<StoryItem> stories) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: AppTheme.cardDecoration(),
      child: SizedBox(
        height: 95,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: stories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, i) {
            final story = stories[i];
            final user = provider.findUserById(story.userId);
            return GestureDetector(
              onTap: () => _openStories(stories, provider, i),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: AppTheme.fireGradient,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      child: ClipOval(
                        child: SizedBox.expand(
                          child: SmartImage(
                            source: user?.avatarUrl ?? story.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openStories(
    List<StoryItem> stories,
    MockDataProvider provider,
    int initial,
  ) async {
    if (stories.isEmpty) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _StoriesViewer(
          stories: stories,
          provider: provider,
          initial: initial,
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

  Widget _postCard(
    MockDataProvider provider,
    UserProfile user,
    Vehicle vehicle,
    FeedPost post,
  ) {
    final hp = (vehicle.stats['Power'] ?? vehicle.stats['Motor'] ?? 0).toInt();
    final following = provider.followingIds.contains(user.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: ClipOval(
                child: SizedBox.expand(
                  child: SmartImage(source: user.avatarUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            title: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(user.handle),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user.isPro)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.neonMagenta.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(color: AppTheme.neonMagenta),
                    ),
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
              SmartImage(
                source: vehicle.imageUrl,
                height: 220,
                width: double.infinity,
              ),
              Positioned(
                top: 10,
                right: 10,
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VehicleDetailScreen(vehicle: vehicle),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.neonMagenta,
                  ),
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
                    Flexible(
                      child: Text(
                        '${vehicle.brand} ${vehicle.name}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.neonOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$hp HP',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('${vehicle.year} - ${vehicle.origin.toLowerCase()}'),
                const SizedBox(height: 10),
                Text(
                  post.caption,
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => provider.togglePostLike(post.id),
                      icon: Icon(
                        provider.isPostLiked(post.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      color: AppTheme.neonMagenta,
                    ),
                    Text('${provider.getPostLikes(post)}'),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _commentSheet(provider, post.id),
                      icon: const Icon(Icons.mode_comment_outlined),
                    ),
                    Text('${provider.getComments(post.id).length}'),
                    const Spacer(),
                    IconButton(
                      onPressed: () => provider.togglePostSaved(post.id),
                      icon: Icon(
                        provider.isPostSaved(post.id)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                      ),
                      color: AppTheme.neonCyan,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _commentSheet(MockDataProvider provider, String postId) async {
    final ctrl = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111B43),
      builder: (ctx) => SafeArea(
        child: StatefulBuilder(
          builder: (context, setStateModal) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
              left: 12,
              right: 12,
              top: MediaQuery.of(ctx).padding.top + 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...provider
                    .getComments(postId)
                    .map((c) => ListTile(title: Text(c))),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ctrl,
                        decoration: const InputDecoration(
                          hintText: 'Comentar...',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        provider.addPostComment(postId, ctrl.text);
                        ctrl.clear();
                        setStateModal(() {});
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StoriesViewer extends StatefulWidget {
  final List<StoryItem> stories;
  final MockDataProvider provider;
  final int initial;

  const _StoriesViewer({
    required this.stories,
    required this.provider,
    required this.initial,
  });

  @override
  State<_StoriesViewer> createState() => _StoriesViewerState();
}

class _StoriesViewerState extends State<_StoriesViewer> {
  late final PageController _controller;
  late int _index;
  Timer? _timer;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initial;
    _controller = PageController(initialPage: _index);
    _startStoryTimer();
  }

  void _startStoryTimer() {
    _timer?.cancel();
    _progress = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.02;
      });
      if (_progress >= 1) {
        _nextStory();
      }
    });
  }

  void _nextStory() {
    _timer?.cancel();
    if (_index >= widget.stories.length - 1) {
      Navigator.pop(context);
      return;
    }
    _index++;
    _controller.animateToPage(
      _index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
    _startStoryTimer();
  }

  void _prevStory() {
    _timer?.cancel();
    if (_index <= 0) {
      _startStoryTimer();
      return;
    }
    _index--;
    _controller.animateToPage(
      _index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
    _startStoryTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.stories.length,
              onPageChanged: (i) {
                _index = i;
                _startStoryTimer();
              },
              itemBuilder: (context, i) {
                final story = widget.stories[i];
                final user = widget.provider.findUserById(story.userId);
                return Stack(
                  children: [
                    Positioned.fill(
                      child: SmartImage(
                        source: story.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              minHeight: 4,
                              value: _progress,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.neonMagenta,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                child: ClipOval(
                                  child: SizedBox.expand(
                                    child: SmartImage(
                                      source: user?.avatarUrl ?? story.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                user?.handle ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _prevStory,
                    child: const SizedBox.expand(),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _nextStory,
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
