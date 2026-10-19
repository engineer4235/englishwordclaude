import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Uygulamaya gömülü, paket olmayan bileşenlerin lisanslarını Flutter'ın
/// lisans sayfasına ekler (CNT-1, EWL-101). Paketlerin lisanslarını Flutter
/// kendisi ekler.
void registerAppLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(const [
      'Lexend',
    ], await rootBundle.loadString('assets/fonts/OFL.txt'));
  });
}
