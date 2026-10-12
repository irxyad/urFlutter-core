import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:urflutter_core/extensions.dart';

class EmptyRoutePage extends StatelessWidget {
  const EmptyRoutePage({super.key, required this.state});

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text('Page Not Found'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withTransparency(
                      0.4,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.signpost_outlined,
                    size: 56,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Page Not Found',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  '"${state.matchedLocation}" does not exist.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  'The route you\'re looking for doesn\'t exist '
                  'or may have been moved.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
