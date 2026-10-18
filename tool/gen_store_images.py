"""Mağaza görsellerini üretir (REL-4).

Girdi:  test/store/raw/*.png  (store_screenshots_test.dart çıktısı, 1080x1920)
        assets/branding/logo.png, assets/fonts/Lexend-*.ttf
Çıktı:  docs/store/screenshots/*.png  1080x1920, üstte açıklama, mor zemin
        docs/store/feature_graphic.png  1024x500 (Google Play öne çıkan görsel)
        docs/store/icon_512.png  512x512 RGBA (Google Play uygulama simgesi)

    pip install pillow && python3 tool/gen_store_images.py
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / 'test/store/raw'
OUT = ROOT / 'docs/store'
FONT = ROOT / 'assets/fonts'
PURPLE = (108, 60, 233)
AMBER = (245, 165, 36)
WHITE = (255, 255, 255)

CAPTIONS = {
    '1_home': ('Her gün birkaç dakika', 'Günlük hedef, seri ve hatırlatmalarla düzenli çalış'),
    '2_map': ("A1'den C2'ye", 'Seviye seviye, ünite ünite ilerle'),
    '3_practice': ('Eğlenceli alıştırmalar', 'Seçmeli, dinleme, yazma ve eşleştirme'),
    '4_stats': ('İlerlemeni gör', 'Öğrendiğin kelimeler, doğruluk ve tekrar planı'),
    '5_profile': ('Rozetler kazan', 'Hedefini, temanı ve sesini kendin seç'),
    '6_home_dark': ('Tamamen çevrimdışı', 'İnternet gerekmez, verilerin cihazında kalır'),
}


def font(weight, size):
    return ImageFont.truetype(str(FONT / f'Lexend-{weight}.ttf'), size)


def rounded(img, radius):
    mask = Image.new('L', img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, *img.size), radius, fill=255)
    out = Image.new('RGBA', img.size)
    out.paste(img, (0, 0), mask)
    return out


def centered(draw, y, text, fnt, fill, width):
    w = draw.textlength(text, font=fnt)
    draw.text(((width - w) / 2, y), text, font=fnt, fill=fill)


def screenshot(name, title, subtitle):
    raw = Image.open(RAW / f'{name}.png').convert('RGB')
    canvas = Image.new('RGB', (1080, 1920), PURPLE)
    draw = ImageDraw.Draw(canvas)
    centered(draw, 110, title, font('ExtraBold', 74), WHITE, 1080)
    centered(draw, 215, subtitle, font('Medium', 38), (233, 225, 255), 1080)
    draw.rounded_rectangle((470, 290, 610, 300), 5, fill=AMBER)
    height = 1920 - 360
    width = round(raw.width * height / raw.height)
    phone = rounded(raw.resize((width, height), Image.LANCZOS), 48)
    canvas.paste(phone, ((1080 - width) // 2, 360), phone)
    canvas.save(OUT / 'screenshots' / f'{name}.png', optimize=True)


def feature_graphic():
    canvas = Image.new('RGB', (1024, 500), PURPLE)
    draw = ImageDraw.Draw(canvas)
    logo = rounded(
        Image.open(ROOT / 'assets/branding/logo.png').convert('RGB').resize((300, 300), Image.LANCZOS),
        66,
    )
    canvas.paste(logo, (70, 100), logo)
    draw.text((420, 150), 'Learn English', font=font('ExtraBold', 64), fill=WHITE)
    draw.text((420, 225), 'at Home', font=font('ExtraBold', 64), fill=AMBER)
    draw.text((422, 320), 'Seviye seviye İngilizce kelime öğren', font=font('Medium', 30), fill=(233, 225, 255))
    canvas.save(OUT / 'feature_graphic.png', optimize=True)


def icon():
    Image.open(ROOT / 'assets/branding/logo.png').convert('RGBA').resize((512, 512), Image.LANCZOS).save(
        OUT / 'icon_512.png', optimize=True
    )


def main():
    (OUT / 'screenshots').mkdir(parents=True, exist_ok=True)
    for name, (title, subtitle) in CAPTIONS.items():
        if (RAW / f'{name}.png').exists():
            screenshot(name, title, subtitle)
            print('docs/store/screenshots/%s.png' % name)
        else:
            print('eksik ham görüntü: %s (önce store_screenshots_test)' % name)
    feature_graphic()
    icon()
    print('docs/store/feature_graphic.png, docs/store/icon_512.png')


if __name__ == '__main__':
    main()
