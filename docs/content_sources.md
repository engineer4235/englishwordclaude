# İçerik kaynakları ve lisanslar (CNT-1)

Bu belge, uygulamada kullanılan içeriğin ve bileşenlerin nereden geldiğini ve
hangi koşullarla kullanıldığını kayda geçirir.

## Kelime içeriği

| Öğe | Kaynak | Lisans / hak |
|---|---|---|
| Kelime seçimi (A1–B2) | Proje için derlendi. Seçimde CEFR seviyelerinde yaygın olarak öğretilen temel kelimeler ve gündelik konular esas alındı. Ticari sözlüklerin (Oxford, Cambridge vb.) seviyeli listeleri ve tanımları kopyalanmadı. | Projeye ait |
| Türkçe anlamlar | Proje için yazıldı. | Projeye ait |
| Okunuşlar (IPA) | Standart Amerikan İngilizcesi telaffuzuna göre proje için yazıldı. IPA bir gösterim sistemidir; telif konusu değildir. | Projeye ait |
| Örnek cümleler ve çevirileri | Her biri proje için özgün olarak yazıldı; başka bir kaynaktan alınmadı. | Projeye ait |
| Eş/zıt anlam ilişkileri | Proje için derlendi. | Projeye ait |
| Seviye tespit havuzu (`placement_pool.json`) | Proje için derlendi. | Projeye ait |

İçeriğin düzenlenen kaynağı `content/` klasöründedir (biçim:
[content/README.md](../content/README.md)). Türkçe çevirilerin bir insan
editör tarafından gözden geçirilmesi için `docs/content_review.csv` tablosu
kullanılır (CNT-7).

## Uygulamaya gömülü bileşenler

| Bileşen | Kullanım | Lisans |
|---|---|---|
| Lexend yazı tipi | Arayüz yazı tipi (`assets/fonts/`) | SIL Open Font License 1.1 (`assets/fonts/OFL.txt`) |
| Material Icons | Simgeler (Flutter ile gelir) | Apache License 2.0 |
| Kelime görselleri | Cihazın sistem emojisi kullanılır; uygulamaya görsel dosyası eklenmez | Cihaz üreticisinin yazı tipi lisansı |
| Seslendirme | Cihazın metin okuma (TTS) motoru kullanılır; uygulamaya ses dosyası eklenmez | Cihaz üreticisinin koşulları |
| Uygulama logosu | `assets/branding/logo_source.webp` | Proje sahibine ait |

Uygulamanın kullandığı Dart/Flutter paketlerinin lisansları, Flutter
tarafından otomatik olarak toplanır. Bunlar ve Lexend lisansı uygulamada
**Profil → Gizlilik ve yasal → Açık kaynak lisansları** ekranında listelenir.
