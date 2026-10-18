import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/badge_labels.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../domain/exercise/exercise.dart';
import '../../../l10n/app_localizations.dart';
import 'practice_screen.dart' show PracticeMode;

/// Ders ve sınav sonu ekranı (EWL-333): puan halkası, kazanılan XP, yeni
/// rozetler ve başarıda konfeti.
class ResultView extends StatelessWidget {
  const ResultView({
    super.key,
    required this.mode,
    required this.result,
    required this.passed,
    required this.levelCode,
    required this.xp,
    this.newBadges = const [],
  });

  final PracticeMode mode;
  final int xp;

  /// Bu oturumda kazanılan rozetler (FR-73).
  final List<String> newBadges;
  final SessionResult result;
  final bool? passed;
  final String levelCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppColors.of(context);
    final levelPassed = mode == PracticeMode.levelExam && passed == true;
    final failed = passed == false;
    final celebrate = !failed && (passed == true || newBadges.isNotEmpty);
    final animate = !MediaQuery.of(context).disableAnimations;

    final message = switch (mode) {
      PracticeMode.lesson => l10n.resultLesson,
      PracticeMode.review ||
      PracticeMode.favorites ||
      PracticeMode.difficult ||
      PracticeMode.wordList => l10n.resultReview,
      PracticeMode.unitExam =>
        passed == true ? l10n.resultUnitPassed : l10n.resultUnitFailed,
      PracticeMode.quickPass =>
        passed == true
            ? l10n.resultQuickPassPassed
            : l10n.resultQuickPassFailed(ProgressRepository.quickPassScore),
      PracticeMode.levelExam =>
        passed == true
            ? l10n.resultLevelPassed(levelCode)
            : l10n.resultLevelFailed,
    };

    // Başarısız sınavda sakin kehribar, diğer durumlarda mor kahraman alanı.
    final heroBg = failed ? scheme.secondaryContainer : scheme.primary;
    final heroFg = failed ? scheme.onSecondaryContainer : scheme.onPrimary;
    final ringColor = failed ? scheme.secondary : colors.streak;
    final ringTrack = heroFg.withValues(alpha: 0.18);

    final hero = Container(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: BoxDecoration(
        color: heroBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge + 6),
      ),
      child: Column(
        children: [
          _ScoreRing(
            percent: result.scorePercent,
            color: ringColor,
            track: ringTrack,
            animate: animate,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      levelPassed
                          ? Icons.emoji_events_rounded
                          : failed
                          ? Icons.refresh_rounded
                          : Icons.check_circle_rounded,
                      color: heroFg,
                      size: 28,
                    ),
                    Text(
                      l10n.scorePercent(result.scorePercent),
                      key: const Key('score'),
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: heroFg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(color: heroFg),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.correctCount(result.correct, result.total),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(color: heroFg),
          ),
          if (xp > 0) ...[
            const SizedBox(height: 16),
            _Pop(
              animate: animate,
              delay: 0.35,
              child: Container(
                key: const ValueKey('xp-gained'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors.streakContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: colors.onStreakContainer,
                      size: 22,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        l10n.xpGained(xp),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.onStreakContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Stack(
          children: [
            hero,
            if (celebrate && animate)
              const Positioned.fill(
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppTheme.radiusLarge + 6),
                    ),
                    child: _Confetti(),
                  ),
                ),
              ),
          ],
        ),
        if (levelPassed)
          _AwardCard(
            key: const ValueKey('level-award'),
            icon: Icons.military_tech_rounded,
            label: l10n.levelBadge(levelCode),
            animate: animate,
            delay: 0.5,
          ),
        for (final (i, code) in newBadges.indexed)
          _AwardCard(
            key: ValueKey('new-badge-$code'),
            icon: badgeIcon(code),
            label: l10n.newBadge(badgeName(l10n, code)),
            animate: animate,
            delay: 0.55 + i * 0.1,
          ),
        if (result.wrongWords.isNotEmpty) ...[
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              l10n.wrongWordsTitle,
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (i, word) in {
                  for (final w in result.wrongWords) w.id: w,
                }.values.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  ListTile(
                    title: Text(word.lemma),
                    subtitle: Text(word.meaningTr),
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.go(switch (mode) {
            PracticeMode.review => AppRoutes.home,
            PracticeMode.favorites || PracticeMode.difficult => AppRoutes.words,
            PracticeMode.wordList => AppRoutes.wordLists,
            _ => AppRoutes.levelMap,
          }),
          child: Text(switch (mode) {
            PracticeMode.review => l10n.backToHome,
            PracticeMode.favorites ||
            PracticeMode.difficult ||
            PracticeMode.wordList => l10n.backToWords,
            _ => l10n.backToMap,
          }),
        ),
      ],
    );
  }
}

/// Puanı 0'dan hedefe dolan bir halka olarak çizer.
class _ScoreRing extends StatelessWidget {
  const _ScoreRing({
    required this.percent,
    required this.color,
    required this.track,
    required this.animate,
    required this.child,
  });

  final int percent;
  final Color color;
  final Color track;
  final bool animate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final target = percent.clamp(0, 100) / 100;
    return SizedBox.square(
      dimension: 168,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: animate ? 0 : target, end: target),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => CustomPaint(
          painter: _RingPainter(value: value, color: color, track: track),
          child: child,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.value, required this.color, required this.track});

  final double value;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 14.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawArc(rect, 0, math.pi * 2, false, base);
    if (value <= 0) return;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * value, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color || old.track != track;
}

/// Gecikmeli büyüyerek beliren öğe (XP ve rozetler için).
class _Pop extends StatelessWidget {
  const _Pop({required this.animate, required this.delay, required this.child});

  final bool animate;

  /// Toplam sürenin oranı olarak bekleme (0–1).
  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!animate) return child;
    final start = delay.clamp(0.0, 0.8);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1100),
      builder: (context, t, child) {
        final local = ((t - start) / (1 - start)).clamp(0.0, 1.0);
        final scale = Curves.elasticOut.transform(local);
        return Opacity(
          opacity: Curves.easeOut.transform(local),
          child: Transform.scale(scale: 0.6 + 0.4 * scale, child: child),
        );
      },
      child: child,
    );
  }
}

/// Kazanılan rozet veya seviye ödülü kartı.
class _AwardCard extends StatelessWidget {
  const _AwardCard({
    super.key,
    required this.icon,
    required this.label,
    required this.animate,
    required this.delay,
  });

  final IconData icon;
  final String label;
  final bool animate;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: _Pop(
        animate: animate,
        delay: delay,
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colors.streakContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.streak, width: 3),
                  ),
                  child: Icon(icon, color: colors.onStreakContainer, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bir kez düşen konfeti; tekrar etmez, böylece ekran sabitlenir.
class _Confetti extends StatefulWidget {
  const _Confetti();

  @override
  State<_Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<_Confetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..forward();

  late final List<_Piece> _pieces = () {
    final random = math.Random(42);
    return List.generate(
      36,
      (i) => _Piece(
        x: random.nextDouble(),
        drift: (random.nextDouble() - 0.5) * 0.3,
        delay: random.nextDouble() * 0.35,
        spin: (random.nextDouble() - 0.5) * 12,
        size: 6 + random.nextDouble() * 6,
        colorIndex: i % 4,
      ),
    );
  }();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = AppColors.of(context);
    final palette = [
      colors.streak,
      scheme.onPrimary,
      scheme.tertiaryContainer,
      scheme.primaryContainer,
    ];
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _ConfettiPainter(
          t: _controller.value,
          pieces: _pieces,
          palette: palette,
        ),
      ),
    );
  }
}

class _Piece {
  const _Piece({
    required this.x,
    required this.drift,
    required this.delay,
    required this.spin,
    required this.size,
    required this.colorIndex,
  });

  final double x;
  final double drift;
  final double delay;
  final double spin;
  final double size;
  final int colorIndex;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.t,
    required this.pieces,
    required this.palette,
  });

  final double t;
  final List<_Piece> pieces;
  final List<Color> palette;

  @override
  void paint(Canvas canvas, Size size) {
    if (t >= 1) return;
    final paint = Paint();
    for (final p in pieces) {
      final local = ((t - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (local <= 0 || local >= 1) continue;
      final y = -20 + (size.height + 40) * Curves.easeIn.transform(local);
      final x = size.width * (p.x + p.drift * local);
      final fade = local > 0.8 ? (1 - local) / 0.2 : 1.0;
      paint.color = palette[p.colorIndex].withValues(alpha: fade);
      canvas
        ..save()
        ..translate(x, y)
        ..rotate(p.spin * local)
        ..drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.size,
              height: p.size * 0.55,
            ),
            const Radius.circular(2),
          ),
          paint,
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
