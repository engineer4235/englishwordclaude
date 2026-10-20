import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

/// Uygulamanın Google Play sayfası.
const playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.engineer4235.english_word_learning';

/// Uygulamanın web sayfası (Play bağlantısı ve yasal metinler).
const websiteUrl = 'https://engineer4235.github.io/englishwordclaude/';

/// Paylaşılan metne eklenecek bağlantı: Android'de Play sayfası, diğer
/// platformlarda web sayfası.
String storeLink([TargetPlatform? platform]) =>
    (platform ?? defaultTargetPlatform) == TargetPlatform.android
    ? playStoreUrl
    : websiteUrl;

/// Sistemin paylaşım penceresini açar.
abstract interface class ShareService {
  Future<void> shareText(String text);
}

class PlatformShareService implements ShareService {
  const PlatformShareService();

  @override
  Future<void> shareText(String text) async {
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } catch (_) {
      // Paylaşım kullanılamıyorsa sessizce geçilir.
    }
  }
}

final shareServiceProvider = Provider<ShareService>(
  (ref) => const PlatformShareService(),
);
