import 'package:flutter/material.dart';

/// Başlığında renkli daire içinde simge olan kart (EWL-335). İstatistik ve
/// profil bölümlerinde kullanılır.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    this.accent = false,
    this.trailing,
    this.padding = const EdgeInsets.all(16),
    this.flush = false,
  });

  /// Doğrudan kart kenarına uzanan içerik (örneğin [ListTile] listesi). Bu
  /// durumda yalnızca başlık iç boşluk alır.
  final bool flush;

  final IconData icon;
  final String title;
  final List<Widget> children;

  /// Kehribar vurgu; yoksa mor.
  final bool accent;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bg = accent ? scheme.secondaryContainer : scheme.primaryContainer;
    final fg = accent ? scheme.onSecondaryContainer : scheme.onPrimaryContainer;
    final header = Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: fg),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
        ?trailing,
      ],
    );
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: flush
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: header,
                ),
                ...children,
                const SizedBox(height: 8),
              ],
            )
          : Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [header, const SizedBox(height: 12), ...children],
              ),
            ),
    );
  }
}

/// Kalın, yuvarlak uçlu ilerleme çubuğu.
class RoundedBar extends StatelessWidget {
  const RoundedBar({
    super.key,
    required this.value,
    this.color,
    this.track,
    this.height = 10,
  });

  final double value;
  final Color? color;
  final Color? track;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1).toDouble(),
        minHeight: height,
        color: color ?? scheme.primary,
        backgroundColor: track ?? scheme.surfaceContainerHighest,
      ),
    );
  }
}
