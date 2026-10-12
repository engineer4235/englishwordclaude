# Yazılım Gereksinimleri Spesifikasyonu (SRS)
## EnglishWordLearning — İngilizce Kelime Öğrenme Uygulaması

| Alan | Değer |
|---|---|
| Sürüm | 1.0 (taslak) |
| Tarih | 12.10.2026 |
| Platformlar | Android, iOS |
| Teknoloji | Flutter (tek kod tabanı) |
| Arayüz dili | Türkçe (ileride çoklu dil) |

> Not: Bu dokümanda "SRS" kısaltması dokümanın kendisini ifade eder. Kelime tekrar sistemi için **"aralıklı tekrar"** (spaced repetition) terimi kullanılmıştır.

---

## 1. Giriş

### 1.1 Amaç
Bu doküman, Türkçe konuşan kullanıcıların İngilizce kelime dağarcığını seviye seviye geliştirmesini sağlayan mobil uygulamanın işlevsel ve işlevsel olmayan gereksinimlerini tanımlar. Geliştirme bu dokümana göre yürütülecektir.

### 1.2 Kapsam
Uygulama:
- Kelimeleri CEFR seviyelerine (A1 → C2) göre gruplar ve kullanıcıyı seviyeler arasında kademeli olarak ilerletir.
- Bilimsel temelli **aralıklı tekrar** algoritmasıyla öğrenilen kelimelerin kalıcılığını sağlar.
- Farklı alıştırma türleri (çoktan seçmeli, dinleme, yazma, eşleştirme, telaffuz) sunar.
- Oyunlaştırma (XP, seri, rozet) ile motivasyonu artırır.
- Çevrimdışı çalışır, hesap açılırsa ilerlemeyi cihazlar arasında eşitler.

### 1.3 Hedef Kullanıcılar
| Kullanıcı | Açıklama |
|---|---|
| Başlangıç seviyesi öğrenci | Hiç ya da çok az İngilizce bilen, A1'den başlayan kişi |
| Orta seviye öğrenen | Okul/kurs geçmişi olan, seviye tespitiyle B1–B2'den başlayan kişi |
| Sınava hazırlanan | YDS, YÖKDİL, IELTS, TOEFL gibi sınavlara çalışan kişi (ileri sürümde sınav paketleri) |

### 1.4 Tanımlar
| Terim | Açıklama |
|---|---|
| CEFR | Avrupa Ortak Dil Referans Çerçevesi: A1, A2, B1, B2, C1, C2 |
| Seviye | Bir CEFR basamağı (ör. A1) |
| Ünite | Bir seviye içindeki, ortak temalı yaklaşık 20 kelimelik grup |
| Aralıklı tekrar | Kelimenin, unutulmak üzereyken tekrar gösterildiği zamanlama yöntemi |
| Kelime durumu | Yeni → Öğreniliyor → Tekrarda → Öğrenildi (Ustalaşıldı) |
| XP | Deneyim puanı |
| Seri (streak) | Art arda günlük hedefin tamamlandığı gün sayısı |

---

## 2. Genel Tanım

### 2.1 Ürün Perspektifi
Bağımsız, çevrimdışı öncelikli bir mobil uygulama. Kelime içeriği uygulamayla birlikte gelir (yerel veritabanı). İsteğe bağlı bulut hesabı ilerleme eşitleme, yedekleme ve içerik güncellemeleri için kullanılır.

### 2.2 Temel Öğrenme Akışı
```
Uygulamayı aç
  → (ilk kez) Karşılama → Hedef seçimi → Seviye tespit sınavı → Başlangıç seviyesi atanır
  → Ana ekran: "Bugünkü tekrarlar" + "Yeni kelimeler" + günlük hedef
  → Ünite dersi: kelimeyi tanı (kart) → alıştırmalar → ünite sonu mini sınav
  → Seviyedeki tüm üniteler bitti → Seviye atlama sınavı → Sonraki seviye açılır
```

### 2.3 Kısıtlar
- Tek kod tabanı: Flutter (Dart).
- Minimum: Android 7.0 (API 24), iOS 15.
- Kelime ve örnek cümle içerikleri lisanslı ya da açık lisanslı kaynaklardan alınmalıdır (bkz. 7. bölüm).
- KVKK ve GDPR'a uygun kişisel veri işleme.

### 2.4 Varsayımlar
- Kullanıcıların çoğu ilk sürümde hesap açmadan kullanacaktır.
- Cihazda metinden sese (TTS) motoru bulunur. Bulunmazsa önceden kaydedilmiş ses dosyaları kullanılır.

---

## 3. İşlevsel Gereksinimler

Öncelikler: **M** = MVP'de zorunlu, **S** = 2. sürüm, **C** = ileride.

### 3.1 Karşılama ve Başlangıç (Onboarding)
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-01 | İlk açılışta 3 ekranlık tanıtım gösterilir, atlanabilir. | M |
| FR-02 | Kullanıcı öğrenme amacını seçer: Genel, Seyahat, İş, Sınav. | M |
| FR-03 | Kullanıcı günlük hedef seçer: 5 / 10 / 15 / 20 yeni kelime veya 5 / 10 / 20 dakika. | M |
| FR-04 | Kullanıcı bildirim saatini seçer, bildirim izni istenir. | M |
| FR-05 | Kullanıcı seviye tespit sınavına girer ya da "A1'den başla" seçeneğini kullanır. | M |

### 3.2 Seviye Tespit Sınavı
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-10 | Sınav uyarlanabilirdir: doğru cevapta zorluk artar, yanlışta azalır. En fazla 30 soru sürer. | M |
| FR-11 | Sorular A1–C2 havuzlarından seçilir, soru tipi "kelimenin Türkçe anlamını seç"tir. | M |
| FR-12 | Sonuçta önerilen seviye gösterilir, kullanıcı bunu kabul edebilir ya da daha düşük bir seviye seçebilir. | M |
| FR-13 | Kullanıcının atladığı seviyelerdeki kelimeler "biliniyor" sayılır ama ara sıra kontrol tekrarlarına dahil edilir. | S |
| FR-14 | Sınav Ayarlar'dan yeniden yapılabilir. | M |

### 3.3 Seviye ve Ünite Yapısı (Kademeli Geçiş)
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-20 | İçerik 6 seviyeye ayrılır: A1, A2, B1, B2, C1, C2. | M |
| FR-21 | Her seviye temalı ünitelerden oluşur (ör. A1: Aile, Renkler, Yiyecekler). Her ünitede yaklaşık 20 kelime bulunur. | M |
| FR-22 | Üniteler sırayla açılır. Bir ünite, önceki ünitenin mini sınavı %70 ve üzeri başarıyla geçildiğinde açılır. | M |
| FR-23 | **Seviye atlama koşulu:** Seviyedeki tüm üniteler tamamlanmış olmalı, seviye kelimelerinin en az %80'i "Tekrarda" veya "Öğrenildi" durumunda olmalı ve seviye atlama sınavından en az %80 alınmalıdır. | M |
| FR-24 | Seviye atlama sınavı 40 soruluk karma bir sınavdır. Başarısız olunursa yanlış kelimeler tekrar listesine eklenir, sınav 24 saat sonra tekrar edilebilir. | M |
| FR-25 | Seviye haritası ekranı tüm seviyeleri ve üniteleri kilitli / açık / tamamlandı durumlarıyla, ilerleme yüzdesiyle gösterir. | M |
| FR-26 | Seviye tamamlandığında kutlama ekranı ve seviye rozeti gösterilir. | M |
| FR-27 | Kilitli bir üniteye "Hızlı geçiş sınavı" ile atlanabilir: %90 başarı ünitenin tamamlanmasını sağlar. | S |

**Önerilen içerik büyüklüğü:**

| Seviye | Yaklaşık kelime | Ünite sayısı |
|---|---|---|
| A1 | 500 | 25 |
| A2 | 500 | 25 |
| B1 | 800 | 40 |
| B2 | 1.000 | 50 |
| C1 | 1.000 | 50 |
| C2 | 800 | 40 |

MVP'de A1 ve A2 seviyelerinin tamamı, B1'in ilk 10 ünitesi yer alır.

### 3.4 Kelime Kartı (Öğrenme)
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-30 | Kartta şunlar gösterilir: İngilizce kelime, okunuş (IPA), sözcük türü, Türkçe anlam(lar), en az 2 örnek cümle ve cümlelerin çevirisi. | M |
| FR-31 | Hoparlör düğmesi kelimeyi ve örnek cümleyi seslendirir (TTS). Amerikan ve İngiliz aksanı arasında seçim yapılabilir. | M |
| FR-32 | Kelimenin görseli gösterilir (somut kelimelerde). | S |
| FR-33 | Eş anlamlı, zıt anlamlı ve kelime ailesi bilgisi (ör. decide → decision, decisive) gösterilir. | S |
| FR-34 | "Bunu zaten biliyorum" düğmesi kelimeyi doğrudan uzun aralıklı tekrara alır. | M |
| FR-35 | Kelime favorilere / kişisel listeye eklenebilir. | M |
| FR-36 | Kullanıcı karta kendi notunu ekleyebilir (ör. akılda tutma ipucu). | S |

### 3.5 Alıştırma Türleri
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-40 | **Çoktan seçmeli (EN → TR):** İngilizce kelime gösterilir, 4 Türkçe seçenekten doğrusu seçilir. | M |
| FR-41 | **Çoktan seçmeli (TR → EN):** Türkçe anlam gösterilir, 4 İngilizce seçenekten doğrusu seçilir. | M |
| FR-42 | **Dinle ve seç:** Kelime seslendirilir, kullanıcı doğru yazımı seçer. | M |
| FR-43 | **Yaz:** Türkçe anlam verilir, kullanıcı İngilizcesini yazar. Küçük yazım hataları (1 harf) "neredeyse doğru" sayılır. | M |
| FR-44 | **Boşluk doldurma:** Örnek cümlede kelimenin yeri boş bırakılır, doğru kelime seçilir ya da yazılır. | M |
| FR-45 | **Eşleştirme:** 5 İngilizce kelime 5 Türkçe anlamla süre içinde eşleştirilir. | M |
| FR-46 | **Telaffuz:** Kullanıcı kelimeyi söyler, konuşma tanıma ile kontrol edilir. Bu adım isteğe bağlıdır ve atlanabilir. | S |
| FR-47 | **Harf karıştırma:** Karışık harflerden kelime oluşturulur. | S |
| FR-48 | Yanlış seçeneklerin (çeldiricilerin) aynı seviyeden ve aynı sözcük türünden seçilmesi gerekir. | M |
| FR-49 | Her cevaptan sonra anında geri bildirim verilir (doğru/yanlış, doğru cevap, ses). | M |
| FR-50 | Alıştırma türü, kelimenin durumuna göre zorlaşır: Yeni kelimede tanıma soruları sorulur, ileri aşamada yazma ve boşluk doldurma soruları gelir. | M |

### 3.6 Aralıklı Tekrar Sistemi
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-60 | Her kelime-kullanıcı çifti için tekrar zamanlaması tutulur. MVP'de SM-2 algoritması kullanılır, 2. sürümde FSRS'e geçilebilecek şekilde soyutlanır. | M |
| FR-61 | Cevap kalitesi otomatik hesaplanır: doğru ve hızlı = 5, doğru ve yavaş = 4, neredeyse doğru = 3, yanlış = 1. | M |
| FR-62 | Yeni bir kelime aynı oturumda kısa aralıklarla (1 dk, 10 dk) en az 2 kez tekrar edilir, sonra günlük takvime geçer. | M |
| FR-63 | Kelime durumu geçişleri: Yeni → Öğreniliyor (ilk doğru) → Tekrarda (aralık ≥ 1 gün) → Öğrenildi (aralık ≥ 21 gün). Yanlış cevapta kelime "Öğreniliyor" durumuna döner. | M |
| FR-64 | Ana ekranda "Bugün tekrar edilecek X kelime" gösterilir. Tekrarlar yeni kelimelerden önce gelir. | M |
| FR-65 | Günlük tekrar sayısı çok birikirse (ör. 100'ü aşarsa) yeni kelime sunumu otomatik azaltılır ve kullanıcı uyarılır. | M |
| FR-66 | Zorlanılan kelimeler ("sızıntı": 4'ten fazla yanlış) ayrı bir listede toplanır ve özel alıştırmaya alınır. | S |

### 3.7 Oyunlaştırma ve Motivasyon
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-70 | Her doğru cevap XP kazandırır: tekrar 10, yeni kelime 15, sınav sorusu 20 XP. | M |
| FR-71 | Günlük hedef tamamlanınca seri 1 artar. Bir gün kaçırılırsa seri sıfırlanır. | M |
| FR-72 | Seri dondurma: Haftada 1 kez, kazanılan XP ile bir günlük seri koruması alınabilir. | S |
| FR-73 | Rozetler verilir: ilk 100 kelime, 7/30/100 günlük seri, her seviye tamamlama gibi. | M |
| FR-74 | Haftalık lig / arkadaş sıralaması (hesap gerekir). | C |
| FR-75 | Günün kelimesi ana ekranda ve bildirimde gösterilir. | S |

### 3.8 İstatistikler ve İlerleme
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-80 | Toplam öğrenilen kelime sayısı ve durumlara göre dağılım gösterilir. | M |
| FR-81 | Son 7 ve 30 günün günlük aktivite grafiği gösterilir (yeni kelime, tekrar, süre). | M |
| FR-82 | Seviye bazında ilerleme yüzdesi gösterilir. | M |
| FR-83 | Doğruluk oranı ve alıştırma türüne göre başarı gösterilir. | S |
| FR-84 | Aktivite takvimi (ısı haritası) gösterilir. | S |
| FR-85 | Gelecek 7 günde beklenen tekrar yükü tahmini gösterilir. | S |

### 3.9 Kişisel Listeler ve Arama
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-90 | Tüm kelimelerde İngilizce ve Türkçe arama yapılabilir. Seviye ve durum filtresi vardır. | M |
| FR-91 | Kullanıcı kendi listelerini oluşturabilir ve listeye kelime ekleyip çıkarabilir. | S |
| FR-92 | Kullanıcı sözlükte olmayan kendi kelimesini ekleyebilir. Eklenen kelime aralıklı tekrara dahil olur. | S |
| FR-93 | Kişisel liste tek başına alıştırma olarak çalışılabilir. | S |

### 3.10 Bildirimler
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-100 | Kullanıcının seçtiği saatte günlük hatırlatma gönderilir (yerel bildirim). | M |
| FR-101 | Gün içinde hedef tamamlanmadıysa akşam seri uyarısı gönderilir. | M |
| FR-102 | Bildirimler Ayarlar'dan tek tek kapatılabilir. Sessiz saatler tanımlanabilir. | M |
| FR-103 | Ana ekran widget'ı: günün kelimesi ve bekleyen tekrar sayısı. | C |

### 3.11 Hesap ve Eşitleme
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-110 | Uygulama hesapsız (misafir) olarak tam işlevli kullanılabilir. | M |
| FR-111 | Giriş seçenekleri: Google ile giriş, Apple ile giriş (iOS'ta zorunlu), e-posta. | S |
| FR-112 | Misafir ilerlemesi hesap açıldığında kayıpsız olarak buluta taşınır. | S |
| FR-113 | İlerleme cihazlar arasında eşitlenir. Çakışmada en son güncellenen kayıt geçerli olur (kelime bazında). | S |
| FR-114 | Kullanıcı hesabını ve tüm verilerini uygulama içinden silebilir (App Store ve Google Play zorunluluğu). | S |

### 3.12 Ayarlar
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-120 | Günlük hedef, bildirim saati, aksan (US/UK) ve konuşma hızı ayarlanabilir. | M |
| FR-121 | Açık / koyu / sistem teması seçilebilir. | M |
| FR-122 | Ses efektleri ve titreşim açılıp kapatılabilir. | M |
| FR-123 | İlerleme sıfırlanabilir (onaylı). | M |
| FR-124 | Verileri dışa aktarma (JSON/CSV). | C |

### 3.13 Gelir Modeli (Opsiyonel)
| No | Gereksinim | Öncelik |
|---|---|---|
| FR-130 | Freemium model: A1–A2 ücretsiz, B1 ve üzeri premium abonelikle açılır. | C |
| FR-131 | Abonelik yönetimi mağaza içi satın alma ile yapılır (ör. RevenueCat). | C |
| FR-132 | Ücretsiz sürümde reklam gösterilecekse ders ortasında gösterilmez, yalnızca ders sonunda gösterilir. | C |

---

## 4. İşlevsel Olmayan Gereksinimler

| No | Kategori | Gereksinim |
|---|---|---|
| NFR-01 | Performans | Soğuk açılış orta segment cihazda 2 saniyenin altında olmalıdır. |
| NFR-02 | Performans | Alıştırma ekranları arası geçiş 100 ms'nin altında olmalı, animasyonlar 60 fps'te çalışmalıdır. |
| NFR-03 | Çevrimdışı | Öğrenme, tekrar, sınav ve istatistik işlevleri internetsiz çalışmalıdır. Eşitleme bağlantı gelince arka planda yapılır. |
| NFR-04 | Boyut | İlk yükleme boyutu 60 MB'ın altında olmalıdır. Ses ve görsel paketler isteğe bağlı olarak sonradan indirilir. |
| NFR-05 | Güvenilirlik | Uygulama beklenmedik şekilde kapanırsa ilerleme kaybolmamalıdır. Her cevap anında yerel veritabanına yazılır. |
| NFR-06 | Kullanılabilirlik | Yeni kullanıcı ilk dersine 90 saniye içinde başlayabilmelidir. |
| NFR-07 | Erişilebilirlik | Ekran okuyucu (TalkBack/VoiceOver) desteklenmeli, sistem yazı boyutuna uyulmalı, renk kontrastı WCAG AA'yı sağlamalı, renk tek bilgi taşıyıcısı olmamalıdır. |
| NFR-08 | Güvenlik | Bulut verisine yalnızca sahibi erişebilmelidir (Firestore güvenlik kuralları). İletişim HTTPS ile yapılır. |
| NFR-09 | Gizlilik | KVKK aydınlatma metni ve gizlilik politikası uygulamada yer almalıdır. Analitik verisi anonim olmalı, kullanıcı analitiği kapatabilmelidir. |
| NFR-10 | Bakım | Kod katmanlı mimaride yazılmalı, iş mantığı birim testleriyle en az %70 oranında kapsanmalıdır. |
| NFR-11 | Taşınabilirlik | Tek kod tabanı Android ve iOS'ta aynı davranışı göstermelidir. Platforma özgü kod en aza indirilmelidir. |
| NFR-12 | Yerelleştirme | Tüm arayüz metinleri ARB dosyalarında tutulmalıdır (ileride başka ana diller eklenebilsin diye). |
| NFR-13 | İzlenebilirlik | Çökme raporları (Crashlytics) ve temel kullanım olayları (ders başladı/bitti, seviye atladı) kaydedilmelidir. |

---

## 5. Teknik Mimari

### 5.1 Teknoloji Seçimleri
| Katman | Seçim | Gerekçe |
|---|---|---|
| UI | Flutter 3.x, Material 3 | Tek kod tabanı, yüksek performans |
| Durum yönetimi | Riverpod | Test edilebilir, ölçeklenebilir |
| Yönlendirme | go_router | Derin bağlantı desteği |
| Yerel veritabanı | Drift (SQLite) | İlişkisel sorgular, tip güvenliği, migration desteği |
| Basit ayarlar | shared_preferences | Tema, bildirim saati gibi küçük ayarlar için |
| Seslendirme | flutter_tts + önceden kaydedilmiş ses (opsiyonel paket) | Çevrimdışı çalışma |
| Konuşma tanıma | speech_to_text | Telaffuz alıştırması (2. sürüm) |
| Bildirim | flutter_local_notifications | Zamanlanmış yerel bildirimler |
| Bulut | Firebase Auth, Cloud Firestore, Crashlytics, Analytics, Remote Config | Hızlı kurulum, iki platform desteği |
| Grafik | fl_chart | İstatistik ekranları |
| Test | flutter_test, mocktail, integration_test | |
| CI/CD | GitHub Actions + Fastlane | Otomatik derleme ve mağaza dağıtımı |

### 5.2 Katmanlı Mimari (feature-first)
```
lib/
  core/            # tema, sabitler, yardımcılar, hata yönetimi
  data/
    db/            # Drift tabloları, DAO'lar, migration'lar
    repositories/  # kelime, ilerleme, kullanıcı, istatistik
    remote/        # Firebase servisleri (2. sürüm)
  domain/
    models/        # Word, Unit, Level, ReviewCard, UserStats
    srs/           # SM-2 algoritması (FSRS'e geçilebilecek arayüz)
  features/
    onboarding/
    placement_test/
    home/
    level_map/
    lesson/        # kelime kartı + alıştırma motoru
    review/
    exam/          # ünite ve seviye sınavları
    stats/
    word_lists/
    settings/
  l10n/            # ARB çeviri dosyaları
assets/
  content/         # seed veritabanı veya JSON kelime paketleri
  audio/           # opsiyonel ses dosyaları
```

### 5.3 Veri Modeli (yerel veritabanı)
| Tablo | Alanlar |
|---|---|
| `levels` | id, code (A1..C2), order, title |
| `units` | id, level_id, order, title_tr, theme, icon |
| `words` | id, unit_id, lemma, ipa, pos, meaning_tr, frequency_rank, image_path, audio_path |
| `examples` | id, word_id, sentence_en, sentence_tr |
| `word_relations` | word_id, related_word_id, type (synonym/antonym/family) |
| `review_cards` | word_id, state, ease_factor, interval_days, repetitions, due_at, lapses, last_reviewed_at, updated_at |
| `review_logs` | id, word_id, exercise_type, quality, response_ms, created_at |
| `unit_progress` | unit_id, status (locked/open/completed), best_score, completed_at |
| `level_progress` | level_id, status, exam_best_score, exam_last_attempt_at |
| `daily_stats` | date, new_words, reviews, correct, xp, minutes, goal_met |
| `user_profile` | goal_type, daily_target, notify_time, accent, current_level_id, streak, longest_streak, total_xp |
| `badges` | id, code, earned_at |
| `custom_lists` / `custom_list_items` | Kişisel listeler (2. sürüm) |

İçerik tabloları (`levels`, `units`, `words`, `examples`, `word_relations`) uygulamaya hazır SQLite dosyası olarak gömülür ve yalnızca okunur. Kullanıcı tabloları ayrı tutulur. Böylece içerik güncellemesi kullanıcı ilerlemesini bozmaz.

### 5.4 Aralıklı Tekrar Algoritması (SM-2, özet)
```
q: cevap kalitesi (0–5)
q < 3 ise:  repetitions = 0, interval = 1 gün, lapses += 1, state = learning
q ≥ 3 ise:
  repetitions == 0 → interval = 1
  repetitions == 1 → interval = 6
  diğer           → interval = round(interval * ease_factor)
  repetitions += 1
ease_factor = max(1.3, ease_factor + 0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
due_at = şimdi + interval
```
Algoritma `SpacedRepetitionScheduler` arayüzünün arkasında tutulur. Böylece ileride FSRS'e veritabanı değişmeden geçilebilir.

---

## 6. Ekranlar

| # | Ekran | İçerik |
|---|---|---|
| 1 | Açılış / Karşılama | Logo, tanıtım kaydırmaları |
| 2 | Hedef ve günlük hedef seçimi | Kartlar halinde seçim |
| 3 | Seviye tespit sınavı | İlerleme çubuğu, soru, 4 seçenek |
| 4 | Ana ekran | Seri, XP, günlük hedef halkası, "Tekrarlara başla", "Yeni kelimeler", günün kelimesi |
| 5 | Seviye haritası | Seviyeler ve ünitelerden oluşan dikey yol, kilit durumları |
| 6 | Kelime kartı | Kelime, IPA, ses, anlam, örnek cümleler, "biliyorum" düğmesi |
| 7 | Alıştırma | Soru türüne göre dinamik gövde, anında geri bildirim |
| 8 | Ders / sınav sonucu | Doğru sayısı, kazanılan XP, yanlış kelimeler |
| 9 | Seviye atlama sınavı | Zamanlayıcısız 40 soru, sonuç ve kutlama |
| 10 | İstatistikler | Grafikler, durum dağılımı, seviye ilerlemesi |
| 11 | Kelimelerim / Arama | Liste, filtreler, kelime detayı |
| 12 | Rozetler | Kazanılan ve kilitli rozetler |
| 13 | Ayarlar / Profil | Hedef, bildirim, aksan, tema, hesap |

Alt menü: **Ana Sayfa · Harita · Kelimelerim · İstatistik · Profil**

---

## 7. İçerik Kaynakları ve Lisans

- Kelime listeleri ve seviye eşlemeleri lisansı uygun kaynaklardan derlenmelidir. Örnekler: New General Service List (NGSL, CC BY-SA), açık lisanslı frekans listeleri, Wiktionary (CC BY-SA), örnek cümleler için Tatoeba (CC BY 2.0 FR). Her kaynağın lisansı kullanmadan önce doğrulanmalı ve uygulama içinde "Hakkında" ekranında atıf yapılmalıdır.
- Ticari sözlüklerin (Oxford, Cambridge vb.) seviyeli listeleri ve tanımları izinsiz kopyalanmamalıdır.
- Türkçe çeviriler ve örnek cümle çevirileri insan editör tarafından kontrol edilmelidir. Yapay zekâ ile ön çeviri yapılabilir ama yayından önce gözden geçirilmelidir.
- İçerik, sürüm numaralı bir JSON/SQLite paketi olarak tutulur. Bir içerik derleme script'i (`tools/build_content.dart` veya Python) ham listelerden bu paketi üretir.

---

## 8. Sürüm Planı

### Faz 0 — Altyapı (1 hafta)
Proje iskeleti, mimari klasörleri, tema, yönlendirme, Drift kurulumu, CI.

### Faz 1 — MVP (6–8 hafta)
- Onboarding, seviye tespit sınavı (FR-01..05, FR-10..12, FR-14)
- Seviye/ünite yapısı ve kademeli geçiş (FR-20..26)
- Kelime kartı ve TTS (FR-30, 31, 34, 35)
- Alıştırmalar: FR-40..45, FR-48..50
- Aralıklı tekrar (FR-60..65)
- XP, seri, temel rozetler (FR-70, 71, 73)
- Temel istatistikler (FR-80..82), arama (FR-90)
- Yerel bildirimler (FR-100..102), ayarlar (FR-120..123)
- İçerik: A1, A2 tamamı ve B1'in ilk 10 ünitesi

### Faz 2 — Hesap ve zenginleştirme (4–6 hafta)
Firebase hesap ve eşitleme (FR-111..114), telaffuz alıştırması, kişisel listeler, görseller, kelime ailesi, seri dondurma, günün kelimesi, gelişmiş istatistikler, B1–B2 içeriği.

### Faz 3 — Büyüme
Lig/sıralama, widget, sınav paketleri (YDS/IELTS), C1–C2 içeriği, premium abonelik, FSRS'e geçiş.

---

## 9. Kabul Kriterleri (MVP)

1. Yeni kullanıcı uygulamayı kurup seviye tespit sınavını bitirdiğinde doğru seviyenin ilk ünitesi açılmış olarak gelir.
2. Ünite mini sınavından %70 altı alınınca sonraki ünite kilitli kalır, %70 ve üzeri alınınca açılır.
3. FR-23'teki üç koşul sağlanmadan seviye atlama sınavı başlatılamaz. Koşullar sağlanınca sınav açılır, %80 ve üzeri alınınca sonraki seviye açılır.
4. Bir kelime doğru cevaplandığında `due_at` SM-2 formülüne göre ileri, yanlış cevaplandığında 1 gün sonraya ayarlanır (birim testle doğrulanır).
5. Uçak modunda ders, tekrar ve sınav sorunsuz tamamlanır.
6. Uygulama ders ortasında kapatılıp açıldığında cevaplanmış soruların ilerlemesi korunur.
7. Günlük hedef tamamlanınca seri 1 artar. Ertesi gün hedef tamamlanmazsa seri sonraki gün 0 görünür.
8. Belirlenen saatte günlük hatırlatma bildirimi gelir.
9. Uygulama Android ve iOS'ta aynı ekran akışıyla çalışır.

---

## 10. Riskler

| Risk | Etki | Önlem |
|---|---|---|
| İçerik hazırlığı yazılımdan uzun sürer | Yüksek | İçerik üretimini Faz 0'da paralel başlat, MVP'yi A1–A2 ile sınırla |
| Lisans sorunu olan kelime listesi | Yüksek | Yalnızca açık lisanslı veya kendi derlenen listeler kullanılır, kaynaklar belgelenir |
| Tekrar yığılması kullanıcıyı bıktırır | Orta | FR-65: yeni kelime miktarı otomatik azaltılır |
| TTS kalitesi cihazdan cihaza değişir | Orta | Sık kullanılan kelimeler için kayıtlı ses paketi |
| Mağaza reddi (hesap silme, Apple ile giriş) | Orta | FR-111 ve FR-114 hesap özelliğiyle birlikte zorunlu olarak gelir |
