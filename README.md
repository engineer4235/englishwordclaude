# EnglishWordLearning

Türkçe konuşanlar için seviye seviye ilerleyen İngilizce kelime öğrenme uygulaması (Flutter, Android + iOS).

- Gereksinimler: [`docs/SRS.md`](docs/SRS.md)
- İş takibi: Jira projesi **EWL** — https://engineer4235.atlassian.net/jira/software/projects/EWL
- Claude Code kuralları: [`CLAUDE.md`](CLAUDE.md)

## Geliştirme akışı

1. Jira'dan bir iş seç (ör. `EWL-18`).
2. Branch aç: `EWL-18-kisa-aciklama`
3. Commit mesajları Jira anahtarıyla başlar: `EWL-18: Flutter iskeletini oluştur`
4. PR başlığında da anahtar bulunur. Böylece commit ve PR'lar Jira kaydında görünür (GitHub for Jira uygulaması kurulunca).

## Çalıştırma

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Drift kodu
flutter gen-l10n                                            # Türkçe metinler
flutter run
flutter analyze && flutter test
```

Klasör yapısı SRS 5.2'deki feature-first düzeni izler: `lib/core`, `lib/data`, `lib/domain`, `lib/features`, `lib/l10n`.

## İçerik dosyaları

- `assets/content/seed_content.json` — seviyeler, üniteler, kelimeler, örnek cümleler ve kelime ilişkileri. Gözden geçirme tablosu: `docs/content_review.csv`.
- `assets/content/placement_pool.json` — seviye tespit sınavının soru havuzu (CNT-6). Her seviyede (A1–C2) en az 30 kelime, her sözcük türünde en az 4 kelime bulunur; çeldiriciler aynı seviye ve türden seçilir (FR-48). Ünitesi henüz olmayan bir seviye önerilirse kullanıcı hazır olan en yüksek seviyeden başlar.

## Çevrimdışı çalışma ve dayanıklılık

Uygulama tamamen yereldir: içerik pakette gelir, ilerleme cihazdaki SQLite veritabanında tutulur (NFR-03). `test/nfr/offline_test.dart` bunu kontrol listesiyle denetler: bağımlılıklarda ve kodda ağ erişimi olmadığını; "uçak modunda" (her bağlantı denemesi hata verir) tekrar, ders, ünite sınavı ve seviye tespit sınavının sonuna kadar yapılabildiğini; ders ortasında kapanıp açılan uygulamada cevapların, XP'nin ve ünite durumunun korunduğunu (REL-2). Her cevabın anında kaydedildiği `test/nfr/persistence_test.dart` ile ayrıca doğrulanır (NFR-05).

## Uygulama kimliği

- Ad: **Learn English at Home** (Android `android:label`, iOS `CFBundleDisplayName`, uygulama başlığı `appTitle`).
- Logo kaynağı: `assets/branding/logo_source.webp` (şimdilik 256 px; mağaza öncesi asıl çözünürlükteki görselle değiştirilecek). Android (klasik ve uyarlanabilir) ve iOS simgeleri ile `assets/branding/logo.png` şu komutla yeniden üretilir: `pip install pillow && python3 tool/gen_icons.py`.
