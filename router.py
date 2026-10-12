"""
Maliyet odaklı model router'ı (Claude API).

Strateji:
  1. Önce ücretsiz anahtar kelime kurallarıyla karar vermeye çalış (LLM çağrısı yok).
  2. Kurallar karar veremezse en ucuz modelle (Haiku) sınıflandır.
  3. Belirsiz durumda bir alt seviyeden başla; cevap yetersizse bir üst modele yükselt.

Kurulum:  pip install anthropic
Kullanım: ANTHROPIC_API_KEY ortam değişkenini ayarla, sonra:
          python router.py "login fonksiyonundaki yazım hatasını düzelt"
"""

import sys
import anthropic

client = anthropic.Anthropic()

# Ucuzdan pahalıya sıralı
TIERS = ["simple", "medium", "complex"]
MODELS = {
    "simple": "claude-haiku-5-5",
    "medium": "claude-sonnet-5-5",
    "complex": "claude-opus-5-5",
}
MAX_TOKENS = {"simple": 1024, "medium": 4096, "complex": 8192}

SIMPLE_KEYWORDS = [
    "typo", "yazım", "format", "lint", "rename", "yeniden adlandır",
    "yorum ekle", "docstring", "özetle", "import", "basit",
]
COMPLEX_KEYWORDS = [
    "mimari", "architecture", "refactor tüm", "güvenlik", "security",
    "performans analizi", "tasarla", "migration", "race condition",
]


def rule_based(task: str) -> str | None:
    """Ücretsiz ön filtre. Karar veremezse None döner."""
    t = task.lower()
    if any(k in t for k in COMPLEX_KEYWORDS):
        return "complex"
    if any(k in t for k in SIMPLE_KEYWORDS) and len(task) < 300:
        return "simple"
    return None


def llm_classify(task: str) -> str:
    """En ucuz modelle, çok kısa çıktıyla sınıflandır."""
    r = client.messages.create(
        model=MODELS["simple"],
        max_tokens=5,
        system=(
            "Yazılım görevini sınıflandır. Sadece tek kelime yaz: "
            "simple, medium veya complex. Emin değilsen daha ucuz olanı seç."
        ),
        messages=[{"role": "user", "content": task[:2000]}],
    )
    label = r.content[0].text.strip().lower()
    return label if label in MODELS else "simple"


def classify(task: str) -> str:
    return rule_based(task) or llm_classify(task)


def ask(tier: str, task: str) -> str:
    r = client.messages.create(
        model=MODELS[tier],
        max_tokens=MAX_TOKENS[tier],
        system=(
            "Kısa ve net cevap ver. Görev senin seviyen için fazla zorsa "
            "sadece 'ESCALATE' yaz."
        ),
        messages=[{"role": "user", "content": task}],
    )
    return r.content[0].text


def run(task: str) -> tuple[str, str]:
    """Seçilen seviyeden başlar, gerekirse bir üst seviyeye yükselir."""
    tier = classify(task)
    for t in TIERS[TIERS.index(tier):]:
        answer = ask(t, task)
        if answer.strip() != "ESCALATE":
            return MODELS[t], answer
    return MODELS["complex"], answer


if __name__ == "__main__":
    task = " ".join(sys.argv[1:]) or "Bu fonksiyondaki yazım hatasını düzelt."
    model, answer = run(task)
    print(f"[Kullanılan model: {model}]\n\n{answer}")
