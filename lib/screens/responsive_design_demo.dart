// Responsive & Adaptive Design Demo
// Demonstrates how to create UIs that work across different screen sizes and platforms

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Main Demo Screen - Shows responsive design principles
class ResponsiveDesignDemo extends StatelessWidget {
  const ResponsiveDesignDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Design Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const ResponsiveLayout(),
    );
  }
}

/// Responsive Layout - Adapts based on screen size
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoints for responsive design
        if (constraints.maxWidth < 600) {
          // Mobile layout
          return const MobileLayout();
        } else if (constraints.maxWidth < 1200) {
          // Tablet layout
          return const TabletLayout();
        } else {
          // Desktop layout
          return const DesktopLayout();
        }
      },
    );
  }
}

// ============================================================================
// MOBILE LAYOUT (< 600px width)
// ============================================================================

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildHeaderCard(context, isMobile: true),
          const SizedBox(height: 16),
          
          // Stats Section (Stacked vertically on mobile)
          ..._buildStatsCards(context, isMobile: true),
          const SizedBox(height: 16),
          
          // Task List Section
          _buildTaskListSection(context),
          const SizedBox(height: 16),
          
          // Action Buttons (Full width on mobile)
          _buildActionButtons(context, isMobile: true),
          
          // Device Info
          const SizedBox(height: 24),
          _buildDeviceInfo(context),
        ],
      ),
    );
  }
}

// ============================================================================
// TABLET LAYOUT (600px - 1200px width)
// ============================================================================

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildHeaderCard(context, isMobile: false),
          const SizedBox(height: 24),
          
          // Stats Section (2 columns on tablet)
          Row(
            children: _buildStatsCards(context, isMobile: false)
                .map((card) => Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: card,
                    )))
                .toList(),
          ),
          const SizedBox(height: 24),
          
          // Two column layout for tasks and actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildTaskListSection(context),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _buildActionButtons(context, isMobile: false),
              ),
            ],
          ),
          
          // Device Info
          const SizedBox(height: 24),
          _buildDeviceInfo(context),
        ],
      ),
    );
  }
}

// ============================================================================
// DESKTOP LAYOUT (> 1200px width)
// ============================================================================

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              _buildHeaderCard(context, isMobile: false),
              const SizedBox(height: 32),
              
              // Stats Section (3 columns on desktop)
              Row(
                children: _buildStatsCards(context, isMobile: false)
                    .map((card) => Expanded(child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: card,
                        )))
                    .toList(),
              ),
              const SizedBox(height: 32),
              
              // Main content grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTaskListSection(context),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildActionButtons(context, isMobile: false),
                        const SizedBox(height: 24),
                        _buildDeviceInfo(context),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// REUSABLE COMPONENTS
// ============================================================================

/// Header Card Component
Widget _buildHeaderCard(BuildContext context, {required bool isMobile}) {
  return Card(
    elevation: 2,
    child: Padding(
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.dashboard,
                size: isMobile ? 32 : 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Dashboard',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 20 : 28,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Responsive & Adaptive UI Demo',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isMobile) ...[
            const SizedBox(height: 16),
            Text(
              'This interface adapts to different screen sizes and platforms. '
              'Try resizing your window or running on different devices!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    ),
  );
}

/// Stats Cards Component
List<Widget> _buildStatsCards(BuildContext context, {required bool isMobile}) {
  final stats = [
    {'icon': Icons.task_alt, 'label': 'Tasks', 'value': '24', 'color': Colors.blue},
    {'icon': Icons.check_circle, 'label': 'Completed', 'value': '18', 'color': Colors.green},
    {'icon': Icons.pending, 'label': 'Pending', 'value': '6', 'color': Colors.orange},
  ];

  return stats.map((stat) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              stat['icon'] as IconData,
              size: isMobile ? 32 : 40,
              color: stat['color'] as Color,
            ),
            const SizedBox(height: 8),
            Text(
              stat['value'] as String,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 24 : 32,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              stat['label'] as String,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }).toList();
}

/// Task List Section
Widget _buildTaskListSection(BuildContext context) {
  return Card(
    elevation: 1,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Tasks',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            return _TaskItem(
              title: 'Task ${index + 1}',
              subtitle: 'Description for task ${index + 1}',
              isCompleted: index < 3,
            );
          }),
        ],
      ),
    ),
  );
}

/// Task Item Widget
class _TaskItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;

  const _TaskItem({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isCompleted ? Icons.check_circle : Icons.circle_outlined,
        color: isCompleted ? Colors.green : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {},
      ),
    );
  }
}

/// Action Buttons Component
Widget _buildActionButtons(BuildContext context, {required bool isMobile}) {
  return Card(
    elevation: 1,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add New Task'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
            label: const Text('Filter Tasks'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            label: const Text('Settings'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Device Info Component
Widget _buildDeviceInfo(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final orientation = MediaQuery.of(context).orientation;
  final platform = _getPlatformName();
  
  String layoutType;
  if (size.width < 600) {
    layoutType = 'Mobile';
  } else if (size.width < 1200) {
    layoutType = 'Tablet';
  } else {
    layoutType = 'Desktop';
  }

  return Card(
    color: Colors.grey[100],
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Device Information',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Divider(),
          _InfoRow(label: 'Layout Type', value: layoutType),
          _InfoRow(label: 'Screen Width', value: '${size.width.toInt()}px'),
          _InfoRow(label: 'Screen Height', value: '${size.height.toInt()}px'),
          _InfoRow(label: 'Orientation', value: orientation.name),
          _InfoRow(label: 'Platform', value: platform),
        ],
      ),
    ),
  );
}

/// Info Row Widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

/// Get Platform Name
String _getPlatformName() {
  if (kIsWeb) return 'Web';
  try {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
  } catch (e) {
    return 'Unknown';
  }
  return 'Unknown';
}

// ============================================================================
// ORIENTATION-AWARE EXAMPLE
// ============================================================================

/// Orientation Demo Screen
class OrientationDemo extends StatelessWidget {
  const OrientationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orientation Demo'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    orientation == Orientation.portrait
                        ? Icons.stay_current_portrait
                        : Icons.stay_current_landscape,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    orientation == Orientation.portrait
                        ? 'Portrait Mode'
                        : 'Landscape Mode',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    orientation == Orientation.portrait
                        ? 'UI optimized for vertical scrolling'
                        : 'UI optimized for horizontal layout',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back to Demo'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
