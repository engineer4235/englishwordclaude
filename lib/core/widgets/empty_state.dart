import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Boş liste, arama ve hata durumları için görsel + yönlendirme (EWL-336).
///
/// Simge, mor dairede; çevresinde kehribar ve yeşil küçük süs noktaları
/// bulunur. İsteğe bağlı bir eylem düğmesi kullanıcıyı sonraki adıma yönlendirir.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.actionKey,
  });

  /// Yükleme hatası; [onRetry] ile yeniden dener.
  factory EmptyState.error(
    BuildContext context, {
    Key? key,
    required VoidCallback onRetry,
  }) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      key: key,
      icon: Icons.cloud_off_rounded,
      title: l10n.loadError,
      actionLabel: l10n.retry,
      actionIcon: Icons.refresh_rounded,
      onAction: onRetry,
      actionKey: const ValueKey('retry'),
    );
  }

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final Key? actionKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppColors.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: (constraints.maxHeight - 64).clamp(0, double.infinity),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                  child: SizedBox.square(
                    dimension: 132,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              color: scheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, size: 52, color: scheme.primary),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 10,
                          child: _Dot(size: 18, color: colors.streak),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 4,
                          child: _Dot(size: 12, color: scheme.tertiary),
                        ),
                        Positioned(
                          top: 28,
                          left: 0,
                          child: _Dot(size: 8, color: scheme.primary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
                if (message != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    key: actionKey,
                    onPressed: onAction,
                    icon: Icon(actionIcon ?? Icons.arrow_forward_rounded),
                    label: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
