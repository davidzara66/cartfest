import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mock_data_provider.dart';
import '../theme/app_theme.dart';

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
    final users = provider.users.where((u) => u.id != provider.currentUser.id).toList();
    _selectedUserId ??= users.isNotEmpty ? users.first.id : null;

    return Container(
      decoration: AppTheme.mainBackground,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ListView(
              children: users
                  .map(
                    (u) => ListTile(
                      selected: _selectedUserId == u.id,
                      leading: CircleAvatar(backgroundImage: NetworkImage(u.avatarUrl)),
                      title: Text(u.name),
                      subtitle: Text(u.handle),
                      onTap: () => setState(() => _selectedUserId = u.id),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: (provider.messagesWith(_selectedUserId ?? ''))
                        .map((m) => Align(
                              alignment: m.fromUserId == provider.currentUser.id
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: m.fromUserId == provider.currentUser.id
                                      ? AppTheme.neonMagenta
                                      : const Color(0xFF16254A),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(m.text),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Padding(
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
                          if (_selectedUserId == null) return;
                          provider.sendDirectMessage(_selectedUserId!, _ctrl.text);
                          _ctrl.clear();
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
