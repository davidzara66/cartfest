import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mock_data_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/smart_image.dart';

class DirectMessagesScreen extends StatefulWidget {
  const DirectMessagesScreen({super.key});

  @override
  State<DirectMessagesScreen> createState() => _DirectMessagesScreenState();
}

class _DirectMessagesScreenState extends State<DirectMessagesScreen> {
  String? _selectedUserId;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MockDataProvider>();
    final users = provider.users
        .where((u) => u.id != provider.currentUser.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes')),
      body: SafeArea(
        child: _selectedUserId == null
            ? _threadList(users)
            : _chatView(provider),
      ),
    );
  }

  Widget _threadList(List users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, i) {
        final u = users[i];
        return ListTile(
          leading: CircleAvatar(
            child: ClipOval(
              child: SizedBox.expand(
                child: SmartImage(source: u.avatarUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          title: Text(u.name),
          subtitle: Text(u.handle),
          onTap: () => setState(() => _selectedUserId = u.id),
        );
      },
    );
  }

  Widget _chatView(MockDataProvider provider) {
    final user = provider.findUserById(_selectedUserId!);
    final msgs = provider.messagesWith(_selectedUserId!);

    return Container(
      decoration: AppTheme.mainBackground,
      child: Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => _selectedUserId = null),
            ),
            title: Text(user?.name ?? ''),
            subtitle: Text(user?.handle ?? ''),
          ),
          const Divider(height: 1, color: Colors.white12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: msgs.length,
              itemBuilder: (context, i) {
                final m = msgs[i];
                final mine = m.fromUserId == provider.currentUser.id;
                return Align(
                  alignment: mine
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 280),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: mine
                          ? AppTheme.neonMagenta
                          : const Color(0xFF16254A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(m.text, style: const TextStyle(fontSize: 15)),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      decoration: const InputDecoration(hintText: 'Mensaje...'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      provider.sendDirectMessage(_selectedUserId!, _ctrl.text);
                      _ctrl.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
