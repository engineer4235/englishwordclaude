import '../models/word.dart';

/// Somut kelimelerin görselleri (FR-32).
///
/// Görsel olarak cihazın sistem emojisi kullanılır: uygulamaya dosya
/// eklemez (NFR-04), çevrimdışı çalışır ve lisans gerektirmez. Eski
/// cihazlarda kutu görünmemesi için yalnızca Emoji 11 (2018) ve öncesindeki,
/// birleşik (ZWJ) olmayan karakterler seçildi. Soyut ya da tek bir emojiyle
/// anlamı karışacak kelimelerin görseli yoktur.
const wordImages = <String, String>{
  // İnsanlar
  'baby': '👶', 'family': '👪', 'man': '👨', 'woman': '👩', 'boy': '👦',
  'girl': '👧', 'child': '🧒', 'person': '🧑', 'people': '👥',
  'police officer': '👮', 'student': '🎓',
  // Vücut
  'eye': '👁️', 'ear': '👂', 'mouth': '👄', 'hand': '✋', 'foot': '🦶',
  'arm': '💪', 'leg': '🦵',
  // Yiyecek ve içecek
  'bread': '🍞', 'water': '💧', 'milk': '🥛', 'apple': '🍎', 'egg': '🥚',
  'cheese': '🧀', 'tea': '🍵', 'rice': '🍚', 'honey': '🍯', 'dinner': '🍽️',
  'tomato': '🍅', 'potato': '🥔', 'carrot': '🥕', 'cucumber': '🥒',
  'pepper': '🌶️', 'salad': '🥗', 'dessert': '🍨', 'soup': '🍲',
  'vegetable': '🥦', 'banana': '🍌', 'grape': '🍇', 'lemon': '🍋',
  'strawberry': '🍓', 'peach': '🍑', 'cherry': '🍒', 'watermelon': '🍉',
  'cake': '🍰',
  // Ev ve eşyalar
  'house': '🏠', 'door': '🚪', 'bed': '🛏️', 'sofa': '🛋️', 'lamp': '💡',
  'clock': '🕒', 'watch': '⌚', 'knife': '🔪', 'fork': '🍴', 'spoon': '🥄',
  'plate': '🍽️', 'cup': '☕', 'bowl': '🥣', 'pan': '🍳', 'bag': '👜',
  'basket': '🧺', 'bottle': '🍾', 'packet': '📦', 'soap': '🧼',
  'shower': '🚿', 'trash': '🗑️', 'candle': '🕯️', 'gift': '🎁',
  'phone': '📱', 'computer': '💻', 'printer': '🖨️', 'camera': '📷',
  'screen': '🖥️', 'battery': '🔋', 'password': '🔑',
  // Okul
  'school': '🏫', 'book': '📖', 'pen': '🖊️', 'pencil': '✏️',
  'homework': '📝', 'ruler': '📏', 'notebook': '📓', 'paper': '📄',
  'scissors': '✂️', 'library': '📚', 'list': '📋', 'research': '🔬',
  'experiment': '🧪',
  // Hayvanlar
  'dog': '🐶', 'cat': '🐱', 'bird': '🐦', 'fish': '🐟', 'horse': '🐴',
  'cow': '🐄', 'sheep': '🐑', 'chicken': '🐔', 'bee': '🐝',
  'butterfly': '🦋', 'ant': '🐜', 'spider': '🕷️', 'mosquito': '🦟',
  'frog': '🐸', 'snake': '🐍',
  // Doğa ve hava
  'morning': '🌅', 'night': '🌙', 'sun': '☀️', 'rain': '🌧️', 'snow': '❄️',
  'wind': '🌬️', 'cloud': '☁️', 'mountain': '⛰️', 'sea': '🌊',
  'island': '🏝️', 'beach': '🏖️', 'flower': '🌸', 'tree': '🌳',
  'forest': '🌲', 'desert': '🏜️', 'spring': '🌱', 'summer': '🌞',
  'autumn': '🍂', 'winter': '⛄', 'storm': '⛈️', 'world': '🌍',
  'temperature': '🌡️', 'energy': '⚡', 'pollution': '🏭',
  // Şehir ve yerler
  'bank': '🏦', 'park': '🏞️', 'hospital': '🏥', 'shop': '🏪',
  'restaurant': '🍽️', 'supermarket': '🛒', 'office': '🏢', 'bridge': '🌉',
  'hotel': '🏨', 'museum': '🏛️', 'station': '🚉', 'traffic': '🚦',
  // Ulaşım ve seyahat
  'bus': '🚌', 'train': '🚆', 'bicycle': '🚲', 'car': '🚗', 'plane': '✈️',
  'boat': '⛵', 'taxi': '🚕', 'airport': '🛫', 'ticket': '🎫',
  'passport': '🛂', 'luggage': '🧳', 'map': '🗺️', 'emergency': '🚑',
  // Alışveriş ve para
  'price': '🏷️', 'receipt': '🧾', 'bill': '🧾', 'cash': '💵',
  'salary': '💰', 'currency': '💱', 'job': '💼',
  // Sağlık
  'headache': '🤕', 'fever': '🤒', 'medicine': '💊', 'appointment': '📅',
  // Giysiler
  'shirt': '👕', 'dress': '👗', 'shoe': '👟', 'jacket': '🧥', 'coat': '🧥',
  'hat': '👒',
  // Eğlence ve spor
  'toy': '🧸', 'game': '🎲', 'puzzle': '🧩', 'robot': '🤖',
  'balloon': '🎈', 'guitar': '🎸', 'chess': '♟️', 'birthday': '🎂',
  'party': '🎉', 'ball': '🏀', 'football': '⚽', 'gym': '🏋️', 'race': '🏁',
  'music': '🎵', 'song': '🎶', 'singer': '🎤', 'film': '🎬', 'actor': '🎭',
  'cinema': '🎦', 'competition': '🏆', 'champion': '🥇', 'festival': '🎪',
  'painting': '🖼️', 'author': '✍️',
  // İletişim ve toplum
  'message': '💬', 'letter': '✉️', 'email': '📧', 'language': '🗣️',
  'flag': '🚩', 'news': '📰', 'advertisement': '📢', 'channel': '📺',
  'deadline': '⏰', 'alarm': '🚨', 'election': '🗳️', 'law': '⚖️',
  // Güncelleme: A1–A2 genişlemesiyle gelen somut kelimeler (EWL-15)
  'grandmother': '👵', 'grandfather': '👴', 'meat': '🍖', 'salt': '🧂',
  'pasta': '🍝', 'chocolate': '🍫', 'sandwich': '🥪', 'bathroom': '🛁',
  'wall': '🧱', 'key': '🔑', 'toilet': '🚽', 'television': '📺',
  'home': '🏡', 'nose': '👃', 'tooth': '🦷', 'heart': '❤️',
  'evening': '🌆', 'calendar': '📅', 'fog': '🌫️', 'umbrella': '☂️',
  'star': '⭐', 'moon': '🌙', 'rainbow': '🌈', 'exam': '📝',
  'question': '❓', 'math': '➗', 'mouse': '🐭', 'rabbit': '🐰',
  'duck': '🦆', 'lion': '🦁', 'elephant': '🐘', 'monkey': '🐒',
  'bear': '🐻', 'tiger': '🐯', 'goat': '🐐', 'artist': '🎨',
  'mechanic': '🔧', 'pancake': '🥞', 'biscuit': '🍪', 'post office': '🏤',
  'mosque': '🕌', 'bus stop': '🚏', 'hairdresser': '💈', 'church': '⛪',
  'city': '🏙️', 'factory': '🏭', 'alarm clock': '⏰', 'teddy bear': '🧸',
  'dice': '🎲', 'crayon': '🖍️', 'card': '🃏', 'corn': '🌽',
  'mushroom': '🍄', 'eggplant': '🍆', 'broccoli': '🥦', 'pumpkin': '🎃',
  'lettuce': '🥬', 'globe': '🌐', 'page': '📃', 'folder': '📁',
  'snail': '🐌', 'lizard': '🦎', 'turtle': '🐢', 'caterpillar': '🐛',
  'ladybird': '🐞', 'grasshopper': '🦗', 'sound': '🔊', 'backpack': '🎒',
  'credit card': '💳', 'wallet': '👛', 'shopping mall': '🏬', 'injection': '💉',
  'trousers': '👖', 'jeans': '👖', 't-shirt': '👕', 'sock': '🧦',
  'boot': '👢', 'scarf': '🧣', 'glove': '🧤', 'piano': '🎹',
  'violin': '🎻', 'camping': '⛺', 'fishing': '🎣', 'hiking': '🥾',
  'broom': '🧹', 'leaf': '🍃', 'ocean': '🌊', 'field': '🌾',
  'steak': '🥩', 'kebab': '🥙', 'ship': '🚢', 'motorbike': '🏍️',
  'subway': '🚇', 'tram': '🚊', 'truck': '🚚', 'ferry': '⛴️',
  'helicopter': '🚁', 'road': '🛣️', 'bathtub': '🛁', 'envelope': '📨',
  'video call': '📹', 'internet': '🌐', 'snowman': '⛄', 'sunglasses': '🕶️',
  'swimsuit': '👙', 'wedding': '💒', 'firework': '🎆', 'bride': '👰',
  'present': '🎁', 'tennis': '🎾', 'basketball': '🏀', 'volleyball': '🏐',
  'goal': '🥅', 'stadium': '🏟️', 'skiing': '🎿', 'drum': '🥁',
  'theater': '🎭', 'album': '💿', 'pear': '🍐', 'pineapple': '🍍',
  'melon': '🍈', 'kiwi': '🥝', 'mango': '🥭', 'mug': '☕',
  'frying pan': '🍳', 'trolley': '🛒', 'box': '📦', 'lotion': '🧴',
  'sponge': '🧽', 'toilet paper': '🧻', 'makeup': '💄', 'nail': '💅',
  'bath': '🛀',
  // Şekiller ve zaman
  'circle': '⚪', 'square': '⬛', 'triangle': '🔺', 'noon': '🕛',
};

/// [word] somut bir isimse görselini döner; yoksa `null`.
String? wordImage(Word word) =>
    word.partOfSpeech == 'noun' ? wordImages[word.lemma.toLowerCase()] : null;
