import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../data/db/app_database.dart';
import '../../data/providers.dart';

/// Mağaza değerlendirme isteğinin ne zaman gösterileceği.
///
/// Yalnız "mutlu anda" (sınav geçildi ya da seri rozeti kazanıldı) sorulur;
/// iki istek arasında en az [minInterval] geçer ve toplamda en fazla
/// [maxAsks] kez sorulur. Mağazanın kendi kotası da ayrıca uygulanır.
abstract final class ReviewPolicy {
  static const minInterval = Duration(days: 60);
  static const maxAsks = 3;

  static bool shouldAsk({
    required bool happyMoment,
    required DateTime now,
    required int askedCount,
    DateTime? lastAsked,
  }) =>
      happyMoment &&
      askedCount < maxAsks &&
      (lastAsked == null || now.difference(lastAsked) >= minInterval);
}

/// Bir oturumun sonu "mutlu an" mı: sınav geçildi ya da seri rozeti kazanıldı.
bool isHappyMoment({bool? passed, List<String> newBadges = const []}) =>
    passed == true || newBadges.any((b) => b.startsWith('streak_'));

/// Mağazanın uygulama içi değerlendirme penceresini açar.
abstract interface class ReviewRequester {
  Future<void> request();
}

class PlatformReviewRequester implements ReviewRequester {
  const PlatformReviewRequester();

  @override
  Future<void> request() async {
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) await review.requestReview();
    } catch (_) {
      // Mağaza yoksa (ör. emülatör) sessizce geçilir.
    }
  }
}

/// [ReviewPolicy]'ye göre değerlendirme ister; son istek zamanını ve sayısını
/// `app_meta` tablosunda tutar.
class ReviewPrompter {
  ReviewPrompter(this._db, this._requester, this._clock);

  static const lastAskedKey = 'review_last_asked';
  static const askCountKey = 'review_ask_count';

  final AppDatabase _db;
  final ReviewRequester _requester;
  final DateTime Function() _clock;

  /// İstek gösterildiyse `true`.
  Future<bool> maybeAsk({required bool happyMoment}) async {
    if (!happyMoment) return false;
    final now = _clock();
    final last = DateTime.tryParse(await _db.metaValue(lastAskedKey) ?? '');
    final count = int.tryParse(await _db.metaValue(askCountKey) ?? '') ?? 0;
    if (!ReviewPolicy.shouldAsk(
      happyMoment: happyMoment,
      now: now,
      askedCount: count,
      lastAsked: last,
    )) {
      return false;
    }
    await _db.setMetaValue(lastAskedKey, now.toIso8601String());
    await _db.setMetaValue(askCountKey, '${count + 1}');
    await _requester.request();
    return true;
  }
}

final reviewRequesterProvider = Provider<ReviewRequester>(
  (ref) => const PlatformReviewRequester(),
);

final reviewPrompterProvider = Provider<ReviewPrompter>(
  (ref) => ReviewPrompter(
    ref.watch(appDatabaseProvider),
    ref.watch(reviewRequesterProvider),
    ref.watch(clockProvider),
  ),
);
