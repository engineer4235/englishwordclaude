import 'package:flutter/material.dart';

/// Uygulama logosu (EWL-328 ile eklenen marka görseli). Kaynak:
/// `assets/branding/logo_source.webp`.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 120, this.semanticLabel});

  final double size;

  /// Verilmezse logo ekran okuyucudan gizlenir (yanında başlık olduğu için).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: Image.asset(
        'assets/branding/logo_source.webp',
        width: size,
        height: size,
        fit: BoxFit.cover,
        semanticLabel: semanticLabel,
        excludeFromSemantics: semanticLabel == null,
        errorBuilder: (context, error, stack) => SizedBox.square(
          dimension: size,
          child: Icon(
            Icons.menu_book_rounded,
            size: size * 0.6,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
