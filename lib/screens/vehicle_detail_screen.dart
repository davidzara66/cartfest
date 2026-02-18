import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hp = (widget.vehicle.stats['Power'] ?? widget.vehicle.stats['Motor'] ?? 0).toInt();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: AppTheme.mainBackground,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              _build3DViewerSection(),
              _buildTabsSection(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: AppTheme.cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E67D9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.vehicle.origin.toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${widget.vehicle.brand} ${widget.vehicle.name}',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, height: 1),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.vehicle.year} • ${widget.vehicle.color}',
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 20),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Icon(Icons.speed, color: AppTheme.neonCyan),
                          const SizedBox(width: 8),
                          Text('$hp HP', style: const TextStyle(color: AppTheme.neonCyan, fontSize: 20, fontWeight: FontWeight.w700)),
                          const Spacer(),
                          const Icon(Icons.emoji_events_outlined, color: AppTheme.neonOrange),
                          const SizedBox(width: 8),
                          Text('${widget.vehicle.votes} votos', style: const TextStyle(color: AppTheme.neonOrange, fontSize: 20, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_up_outlined),
                          label: const Text('Votar por este vehiculo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9C5A32),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text('Inicia sesion para votar', style: TextStyle(color: AppTheme.textSecondary)),
                      ),
                    ],
                  ),
                ),
              ),
              _buildOwnerSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _build3DViewerSection() {
    return Stack(
      children: [
        Container(
          height: 360,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(widget.vehicle.imageUrl, fit: BoxFit.cover),
              Container(color: const Color(0xCC0A1133)),
              CustomPaint(painter: GridPainter()),
            ],
          ),
        ),
        SizedBox(
          height: 360,
          child: ModelViewer(
            backgroundColor: Colors.transparent,
            src: widget.vehicle.model3dPath,
            alt: 'Modelo 3D de ${widget.vehicle.name}',
            ar: true,
            autoRotate: true,
            cameraControls: true,
            disableZoom: false,
          ),
        ),
        Positioned(
          top: 56,
          right: 14,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xD816254A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(widget.vehicle.ownerPhotoUrl),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.vehicle.ownerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text('${widget.vehicle.brand} ${widget.vehicle.name}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 110,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Arrastra para rotar • Scroll para zoom',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _buildActionChip(Icons.door_front_door, 'Puertas'),
              _buildActionChip(Icons.build_outlined, 'Capo'),
              _buildActionChip(Icons.inventory_2_outlined, 'Maletero'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2B53),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.neonOrange, size: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildTabsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        decoration: AppTheme.cardDecoration(),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.neonOrange,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.textSecondary,
              tabs: const [
                Tab(text: 'Modificaciones'),
                Tab(text: 'Especificaciones'),
              ],
            ),
            SizedBox(
              height: 360,
              child: TabBarView(
                controller: _tabController,
                children: [_buildModificationsList(), _buildSpecificationsGrid()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.vehicle.modifications.length,
      itemBuilder: (context, index) {
        final mod = widget.vehicle.modifications[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF16264A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppTheme.neonMagenta.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.settings_input_component, color: AppTheme.neonMagenta, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mod.toUpperCase(), style: const TextStyle(color: AppTheme.neonMagenta, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    const Text('Custom Component', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpecificationsGrid() {
    final hp = (widget.vehicle.stats['Power'] ?? widget.vehicle.stats['Motor'] ?? 0).toInt();
    final specs = {
      'MARCA': widget.vehicle.brand,
      'MODELO': widget.vehicle.name,
      'ANO': widget.vehicle.year.toString(),
      'COLOR': widget.vehicle.color,
      'POTENCIA': '$hp HP',
      'ORIGEN': widget.vehicle.origin.toUpperCase(),
    };

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      itemCount: specs.length,
      itemBuilder: (context, index) {
        final key = specs.keys.elementAt(index);
        final value = specs.values.elementAt(index);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF16264A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(key, style: const TextStyle(color: AppTheme.neonMagenta, fontWeight: FontWeight.w700, fontSize: 12)),
              const Spacer(),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOwnerSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PROPIETARIO', style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.vehicle.ownerPhotoUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.vehicle.ownerName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                      Text(widget.vehicle.ownerHandle, style: const TextStyle(color: AppTheme.neonMagenta, fontSize: 20)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.neonMagenta.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('PRO', style: TextStyle(color: AppTheme.neonMagenta, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const Divider(height: 22, color: Colors.white12),
            const Row(
              children: [
                Icon(Icons.emoji_events_outlined, color: AppTheme.neonOrange),
                SizedBox(width: 8),
                Text('18', style: TextStyle(color: AppTheme.neonOrange, fontWeight: FontWeight.w700, fontSize: 20)),
                SizedBox(width: 20),
                Icon(Icons.star_outline, color: AppTheme.neonCyan),
                SizedBox(width: 8),
                Text('3100', style: TextStyle(color: AppTheme.neonCyan, fontWeight: FontWeight.w700, fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

