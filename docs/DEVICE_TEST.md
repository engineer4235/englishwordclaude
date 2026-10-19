# Cihaz testi kontrol listesi

Yayından önce en az bir Android telefonda ve bir iPhone'da (TestFlight)
uygulanır. Otomatik kısım her birleştirmede CI'da da çalışır
(Actions → **Cihaz testleri**: Android emülatörü + iOS simülatörü).

## 1. Otomatik ölçüm (NFR-01, NFR-02, NFR-06, NFR-11)

Uygulamayı silip (temiz kurulum) telefonu USB ile bağlayın. Süreler
**profil modunda** ölçülmelidir; hata ayıklama (debug) derlemesi birkaç kat
yavaştır ve sınırları her zaman aşar:

```sh
flutter drive --profile -d <cihaz> \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  --dart-define=STRICT_PERF=true
```

CI'daki emülatör/simülatör çalışması hata ayıklama derlemesiyle ve yazılımla
çizimle yapılır; orada yalnız akışın çalıştığı doğrulanır, süreler bilgi
amaçlıdır.

Test, tanıtımı geçip ilk derse girer ve sekmeler arasında gezinir. Çıktıda
şu satırlar görünür; `STRICT_PERF` ile sınır aşılırsa test kırmızı olur:

| Ölçüm | Sınır | Gereksinim |
|---|---|---|
| `soguk_acilis_ms` | < 2000 | NFR-01 soğuk açılış |
| `ilk_derse_kadar_ms` | < 90000 | NFR-06 ilk derse başlama |
| `en_yavas_gecis_ms` | < 100 | NFR-02 ekran geçişi tepkisi |
| `kare_build_p90_ms`, `kare_raster_p90_ms` | < 16.7 | NFR-02 60 fps |

Aynı test Android ve iOS'ta geçiyorsa iki platform aynı akışı gösteriyor
demektir (NFR-11).

## 2. Elle kontrol

### Erişilebilirlik (NFR-07)
- [ ] **TalkBack** (Android) / **VoiceOver** (iOS) açıkken tanıtım, ana sayfa,
      kelime kartı, bir alıştırma ve sonuç ekranı baştan sona yalnız
      kaydırma/çift dokunmayla kullanılabiliyor; her düğmenin anlamlı bir adı var.
- [ ] Sistem yazı boyutu en büyükteyken metinler kesilmiyor, düğmeler
      ekrandan taşmıyor.
- [ ] Koyu tema ve açık temada metinler okunaklı.

### Kullanılabilirlik (NFR-06)
- [ ] Uygulamayı hiç görmemiş biri, yardım almadan 90 saniye içinde ilk
      kelime kartına ulaşıyor (kronometreyle).

### Platform davranışı (NFR-11)
- [ ] Bildirim izni isteniyor; seçilen saatte günlük hatırlatma geliyor
      (FR-100).
- [ ] Seslendirme (TTS) her iki platformda kelimeyi ve cümleyi okuyor.
- [ ] Uçak modunda ders, tekrar ve sınav tamamlanıyor (NFR-03).
- [ ] Ders ortasında uygulama kapatılıp açılınca ilerleme korunuyor (NFR-05).
- [ ] Geri hareketi (Android geri tuşu / iOS kaydırma) beklenen ekrana dönüyor.

Sonuçları ilgili Jira kaydına (EWL-113, EWL-117, EWL-118, EWL-122) yorum
olarak ekleyin.
