import 'package:flutter/material.dart';
import 'debug_flags_api.dart';

/// A full-featured debug flags panel with search, toggles, and bulk actions.
///
/// Can be used as a standalone page or embedded inside [DebugFlagsOverlay].
class DebugFlagsPanel extends StatefulWidget {
  final DebugFlagsAPI api;

  const DebugFlagsPanel({super.key, required this.api});

  @override
  State<DebugFlagsPanel> createState() => _DebugFlagsPanelState();
}

class _DebugFlagsPanelState extends State<DebugFlagsPanel> {
  List<DebugFlag> _flags = [];
  String _search = '';
  bool _loading = true;
  bool _fileLoggingEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadFlags();
  }

  Future<void> _loadFlags() async {
    final flags = await widget.api.getAvailableFlags();
    if (mounted) setState(() { _flags = flags; _loading = false; });
  }

  List<DebugFlag> get _filtered {
    if (_search.isEmpty) return _flags;
    final q = _search.toLowerCase();
    return _flags.where((f) =>
        f.key.toLowerCase().contains(q) ||
        f.description.toLowerCase().contains(q)).toList();
  }

  int get _enabledCount => _flags.where((f) => f.isEnabled).length;

  Future<void> _toggle(DebugFlag flag, bool value) async {
    if (value) {
      await widget.api.enableFlag(flag.key);
    } else {
      await widget.api.disableFlag(flag.key);
    }
    setState(() { flag.isEnabled = value; });
  }

  Future<void> _enableAll() async {
    await widget.api.enableAll();
    setState(() { for (final f in _flags) { f.isEnabled = true; } });
  }

  Future<void> _disableAll() async {
    await widget.api.disableAll();
    setState(() { for (final f in _flags) { f.isEnabled = false; } });
  }

  Future<void> _resetAll() async {
    await widget.api.resetAll();
    await _loadFlags();
  }

  Future<void> _toggleFileLogging() async {
    await widget.api.enableFileLogging();
    setState(() { _fileLoggingEnabled = true; });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Flags'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'enable_all': _enableAll();
                case 'disable_all': _disableAll();
                case 'reset': _resetAll();
                case 'file_logging': _toggleFileLogging();
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'enable_all', child: Text('Enable All')),
              const PopupMenuItem(value: 'disable_all', child: Text('Disable All')),
              const PopupMenuItem(value: 'reset', child: Text('Reset to Defaults')),
              PopupMenuItem(
                value: 'file_logging',
                enabled: !_fileLoggingEnabled,
                child: Text(_fileLoggingEnabled ? 'File Logging ✓' : 'Enable File Logging (iOS)'),
              ),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      Text(
                        '$_enabledCount / ${_flags.length} enabled',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search flags...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() { _search = v; }),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final flag = filtered[index];
                      final isOverridden = flag.isEnabled != flag.defaultValue;
                      return SwitchListTile(
                        title: Text(
                          flag.key,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'monospace',
                            fontWeight: isOverridden ? FontWeight.bold : FontWeight.normal,
                            color: isOverridden ? theme.colorScheme.primary : null,
                          ),
                        ),
                        subtitle: Text(
                          flag.description,
                          style: theme.textTheme.bodySmall,
                        ),
                        value: flag.isEnabled,
                        onChanged: (v) => _toggle(flag, v),
                        dense: true,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

/// Helper to push the debug flags panel as a full-screen route.
///
/// Usage:
/// ```dart
/// DebugFlagsPanel.show(context, player.debugFlags);
/// ```
extension DebugFlagsPanelNavigation on DebugFlagsPanel {
  /// Push the debug flags panel as a full-screen Material route.
  static void show(BuildContext context, DebugFlagsAPI api) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DebugFlagsPanel(api: api),
      ),
    );
  }
}
