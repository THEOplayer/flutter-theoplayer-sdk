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

/// Global API to show the debug flags panel as a draggable overlay on any screen.
///
/// No navigator key required — finds the root overlay automatically.
///
/// Usage:
/// ```dart
/// // 1. Initialize once (e.g. after player creation)
/// DebugFlagsOverlay.init(api: player.debugFlags);
///
/// // 2. Show from anywhere — no BuildContext needed
/// DebugFlagsOverlay.show();
///
/// // 3. Hide programmatically (or user taps the X)
/// DebugFlagsOverlay.hide();
///
/// // 4. Toggle
/// DebugFlagsOverlay.toggle();
/// ```
class DebugFlagsOverlay {
  static DebugFlagsAPI? _api;
  static OverlayEntry? _entry;

  DebugFlagsOverlay._();

  /// Initialize the overlay system. Call once after player creation.
  static void init({required DebugFlagsAPI api}) {
    _api = api;
  }

  /// Whether the overlay is currently visible.
  static bool get isVisible => _entry != null;

  /// Show the debug flags panel as a draggable overlay.
  ///
  /// Finds the root navigator's overlay automatically via [WidgetsBinding].
  /// No [BuildContext] or [GlobalKey] needed.
  static void show() {
    if (_entry != null) return;
    if (_api == null) {
      debugPrint('[DebugFlagsOverlay] Not initialized. Call DebugFlagsOverlay.init() first.');
      return;
    }

    final overlay = _findRootOverlay();
    if (overlay == null) {
      debugPrint('[DebugFlagsOverlay] Could not find root Overlay. Is the app running?');
      return;
    }

    _entry = OverlayEntry(builder: (context) {
      return _DraggablePanel(
        api: _api!,
        onClose: hide,
      );
    });
    overlay.insert(_entry!);
  }

  /// Hide the overlay.
  static void hide() {
    _entry?.remove();
    _entry = null;
  }

  /// Toggle visibility.
  static void toggle() => isVisible ? hide() : show();

  /// Walk the element tree from the root to find the topmost [OverlayState].
  static OverlayState? _findRootOverlay() {
    final rootElement = WidgetsBinding.instance.rootElement;
    if (rootElement == null) return null;

    OverlayState? overlay;
    void visitor(Element element) {
      if (element is StatefulElement && element.state is OverlayState) {
        overlay = element.state as OverlayState;
        return;
      }
      element.visitChildren(visitor);
    }

    rootElement.visitChildren(visitor);
    return overlay;
  }
}

class _DraggablePanel extends StatefulWidget {
  final DebugFlagsAPI api;
  final VoidCallback onClose;

  const _DraggablePanel({required this.api, required this.onClose});

  @override
  State<_DraggablePanel> createState() => _DraggablePanelState();
}

class _DraggablePanelState extends State<_DraggablePanel> {
  double _top = 80;
  static const double _minHeight = 250;
  final double _height = 500;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final clampedHeight = _height.clamp(_minHeight, screenHeight - _top - 20);

    return Positioned(
      top: _top,
      left: 12,
      right: 12,
      height: clampedHeight,
      child: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (d) {
                setState(() { _top = (_top + d.delta.dy).clamp(20, screenHeight - _minHeight); });
              },
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.drag_handle, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Debug Flags',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: widget.onClose,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: DebugFlagsPanel(api: widget.api),
            ),
          ],
        ),
      ),
    );
  }
}
