# Yayın rehberi (REL-4)

Bu belge uygulamanın Google Play iç testine ve TestFlight'a çıkarılması için
gereken adımları sıralar. Kodla ilgili hazırlık depoda tamamdır; hesap açma,
ödeme ve mağaza konsolundaki onaylar yayıncının elindedir.

## 0. Yayından önce kontrol listesi

- [ ] `lib/core/legal/legal_texts.dart` içindeki `[Veri sorumlusunun adı soyadı / unvanı]` ve `[Adres]` dolduruldu, `dart run tool/gen_legal_pages.dart` çalıştırıldı.
- [ ] Yasal metinler bir hukukçuya gözden geçirtildi.
- [ ] GitHub Pages açık (Settings → Pages → Branch `main`, klasör `/docs`); https://engineer4235.github.io/englishwordclaude/gizlilik.html açılıyor.
- [ ] `pubspec.yaml` sürümü güncellendi (`version: 1.0.0+1` → ad + derleme numarası; CI derleme numarasını kendisi verir).
- [ ] Logo asıl çözünürlükte (`assets/branding/logo_source.webp` şu an 256 px) ve simgeler yeniden üretildi (`python3 tool/gen_icons.py`).

## 1. Android imza anahtarı (bir kez)

Mağazaya yüklenen paket bir "yükleme anahtarı" ile imzalanır. Anahtarı kaybetmek
güncelleme yayınlamayı zorlaştırır; dosyayı ve parolaları güvenli bir yerde
yedekleyin. Anahtar depoya **asla** eklenmez (`.gitignore` engeller).

```sh
keytool -genkey -v -keystore upload-keystore.jks -storetype JKS \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Yerelde imzalı derleme için `android/key.properties` (depoya girmez):

```properties
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=/tam/yol/upload-keystore.jks
```

`android/key.properties` ya da aşağıdaki ortam değişkenleri yoksa sürüm
derlemesi hata ayıklama anahtarıyla imzalanır (test APK'sı için yeterli,
mağazaya yüklenemez).

## 2. GitHub'da imzalı paket (.aab)

Depo → Settings → Secrets and variables → Actions → New repository secret:

| Sır | Değer |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 upload-keystore.jks` çıktısı (macOS: `base64 -i upload-keystore.jks`) |
| `ANDROID_KEYSTORE_PASSWORD` | anahtar deposu parolası |
| `ANDROID_KEY_ALIAS` | `upload` |
| `ANDROID_KEY_PASSWORD` | anahtar parolası |

Sonra Actions → **Yayın paketi (Android)** → Run workflow. Bittiğinde
çalıştırmanın sayfasındaki "Artifacts" bölümünden `app-release-N` indirilir;
içindeki `app-release.aab` Play Console'a yüklenecek dosyadır. Sürüm kodu
otomatik olarak çalıştırma numarasıdır, her yüklemede artar.

## 3. Google Play Console

1. https://play.google.com/console adresinde geliştirici hesabı açın (bir kerelik ücret, kimlik doğrulaması).
2. **Uygulama oluştur:** ad "Learn English at Home", varsayılan dil Türkçe, uygulama, ücretsiz.
3. **Mağaza girişi:** metinler ve görseller `docs/store/google_play_tr.md` içinde.
4. **Uygulama içeriği:** gizlilik politikası, reklam (yok), veri güvenliği (veri toplanmıyor), içerik derecelendirmesi, hedef kitle — yanıtlar aynı dosyada.
5. **Test → Dahili test → Yeni sürüm oluştur:** `app-release.aab` yükleyin. "Play Uygulama İmzalama" önerildiğinde kabul edin (Google sürüm anahtarını saklar, siz yükleme anahtarıyla imzalarsınız).
6. **Test kullanıcıları:** e-posta listesi oluşturun, katılım bağlantısını test edenlere gönderin.

Yeni hesaplarda üretime çıkmadan önce kapalı testte belirli sayıda test
kullanıcısı ve süre şartı olabilir; Play Console'un gösterdiği güncel şartı izleyin.

## 4. iOS / TestFlight

Gerekenler: Apple Developer Program üyeliği ve Xcode yüklü bir Mac (ya da
Codemagic gibi macOS derleme hizmeti).

1. App Store Connect → Uygulamalar → **+** → Bundle ID `com.engineer4235.englishWordLearning`, ad "Learn English at Home".
2. Mac'te: `flutter build ipa --release` → `build/ios/ipa/*.ipa`; Xcode'da imza ekibini seçin (Runner → Signing & Capabilities).
3. Yükleme: Transporter uygulaması ya da `xcrun altool`/Xcode Organizer.
4. TestFlight → İç test grubu oluşturun, sürümü ekleyin.
5. Mağaza metinleri ve gizlilik yanıtları: `docs/store/app_store_tr.md`.

## 5. Mağaza görsellerini yeniden üretmek

Tasarım değişince:

```sh
flutter test --update-goldens --dart-define=STORE_SHOTS=true test/store
flutter test --update-goldens --dart-define=STORE_SHOTS=true \
  --dart-define=STORE_DEVICE=ios test/store
pip install pillow && python3 tool/gen_store_images.py
```

Ham görüntüler `test/store/raw/` (depoya girmez), mağaza görselleri
`docs/store/` altındadır.
