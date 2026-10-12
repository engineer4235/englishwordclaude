# Model seçimi (maliyet öncelikli)

Görevleri her zaman yapabilecek EN UCUZ agent'a ver:

1. **quick-fixer** (Haiku) — varsayılan. Önce bunu dene.
2. **coder** (Sonnet) — quick-fixer yetmezse veya görev birden çok dosyaya yayılıyorsa.
3. **architect** (Opus) — sadece mimari karar, büyük refactor veya diğerlerinin çözemediği zor hatalar için.

Kurallar:
- Emin değilsen bir alt seviyeden başla; gerekirse yükselt.
- Bir agent "devredilmeli" derse bir üst seviyeye geç, aynı agent'ı tekrar çağırma.
- Gereksiz dosya okuma, uzun açıklama ve tekrar eden araç çağrılarından kaçın.

# Proje

İngilizce kelime öğrenme uygulaması (Flutter, Android + iOS).
Tüm geliştirmeler `docs/SRS.md` dokümanına göre yapılır. Gereksinim numaralarına (FR-xx, NFR-xx) atıf yap; dokümanla çelişen bir karar gerekirse önce sor.

# Git ve Jira kuralları

- Her iş bir Jira kaydına bağlıdır (proje anahtarı: EWL).
- Branch adı: `EWL-<no>-<kisa-aciklama>` (ör. `EWL-18-flutter-iskelet`).
- Commit mesajı Jira anahtarıyla başlar: `EWL-18: Flutter projesini oluştur`.
- PR başlığı da anahtarla başlar; açıklamada ilgili FR/NFR numaraları ve kabul kriterleri yer alır.
- `main` dalına doğrudan commit yapılmaz; değişiklikler PR ile gelir.
