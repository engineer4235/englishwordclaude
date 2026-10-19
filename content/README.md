# İçerik kaynakları

Uygulamanın kelime içeriği bu klasördeki düz metin dosyalarında tutulur ve
`tool/build_content.dart` ile `assets/content/seed_content.json` paketine
derlenir (CNT-5):

```sh
dart run tool/build_content.dart          # paketi yeniden üretir
dart run tool/build_content.dart --check  # paket güncel mi?
```

Paket güncel değilse `test/tool/build_content_test.dart` testi başarısız olur.

## Dosyalar

| Dosya | İçerik |
|---|---|
| `meta.json` | Paket sürümü, not ve seviye listesi. İçerik her değiştiğinde `version` artırılır. |
| `A1.txt` … `C2.txt` | Seviyenin üniteleri ve kelimeleri |
| `relations.txt` | Eş anlam, zıt anlam ve kelime ailesi ilişkileri |

## Seviye dosyası biçimi

```text
# Yorum satırı
## Ünite başlığı | tema | Material simge adı
kelime|/okunuş/|tür|Türkçe anlam|örnek cümle|çevirisi|örnek cümle|çevirisi
```

- `tür`: `noun`, `verb`, `adjective`, `adverb`, `number`, `interjection`.
- Her kelimenin en az iki örnek cümlesi olur (FR-30); daha fazlası satırın
  sonuna çift olarak eklenebilir.
- Bir kelime bütün seviyelerde yalnızca bir kez geçebilir.
- Okunuş boş bırakılabilir; diğer alanlar zorunludur.

Yeni kelime ve üniteler, uygulama güncellendiğinde mevcut kurulumlara da
eklenir; kullanıcının ilerlemesi korunur.

## Çeviri denetimi (CNT-7)

Türkçe anlamlar ve cümle çevirileri yayından önce bir insan editör tarafından
gözden geçirilmelidir. Düzeltmeler doğrudan bu dosyalarda yapılır.
