# Uygulama simgelerini assets/branding/logo_source.webp dosyasından üretir (EWL-328).
# Kullanım: python3 tool/gen_icons.py   (Pillow gerekir)
import json, os
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
src = Image.open(os.path.join(ROOT, 'assets/branding/logo_source.webp')).convert('RGB')
res = os.path.join(ROOT, 'android/app/src/main/res')

# Kenar rengi: uyarlanabilir simgenin arka planı.
w, h = src.size
edge = [src.getpixel((x, 0)) for x in range(w)] + [src.getpixel((x, h - 1)) for x in range(w)]
bg = tuple(sum(c[i] for c in edge) // len(edge) for i in range(3))

legacy = {'mdpi': 48, 'hdpi': 72, 'xhdpi': 96, 'xxhdpi': 144, 'xxxhdpi': 192}
for d, s in legacy.items():
    out = os.path.join(res, f'mipmap-{d}')
    os.makedirs(out, exist_ok=True)
    src.resize((s, s), Image.LANCZOS).save(os.path.join(out, 'ic_launcher.png'), optimize=True)
    # Uyarlanabilir simge ön yüzü: 108dp tuval, logo güvenli alana (72dp) sığar.
    canvas = int(s * 108 / 48)
    inner = int(s * 72 / 48)
    fg = Image.new('RGBA', (canvas, canvas), (0, 0, 0, 0))
    fg.paste(src.resize((inner, inner), Image.LANCZOS), ((canvas - inner) // 2,) * 2)
    fg.save(os.path.join(out, 'ic_launcher_foreground.png'), optimize=True)

anydpi = os.path.join(res, 'mipmap-anydpi-v26')
os.makedirs(anydpi, exist_ok=True)
with open(os.path.join(anydpi, 'ic_launcher.xml'), 'w') as f:
    f.write('<?xml version="1.0" encoding="utf-8"?>\n'
            '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
            '    <background android:drawable="@color/ic_launcher_background"/>\n'
            '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
            '</adaptive-icon>\n')
with open(os.path.join(res, 'values', 'ic_launcher_background.xml'), 'w') as f:
    f.write('<?xml version="1.0" encoding="utf-8"?>\n<resources>\n'
            '    <color name="ic_launcher_background">#%02X%02X%02X</color>\n</resources>\n' % bg)

ios = os.path.join(ROOT, 'ios/Runner/Assets.xcassets/AppIcon.appiconset')
contents = json.load(open(os.path.join(ios, 'Contents.json')))
for img in contents['images']:
    if 'filename' not in img:
        continue
    px = round(float(img['size'].split('x')[0]) * int(img['scale'][0]))
    src.resize((px, px), Image.LANCZOS).save(os.path.join(ios, img['filename']), optimize=True)

# Uygulama içinde kullanılacak logo.
src.resize((512, 512), Image.LANCZOS).save(os.path.join(ROOT, 'assets/branding/logo.png'), optimize=True)
print('icons ok, background #%02X%02X%02X' % bg)
