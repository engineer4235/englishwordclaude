import 'card_state.dart';
import 'review_state.dart';

/// Zorlanılan kelime (FR-66): öğrenilmiş sayılmayan ve en az iki kez
/// unutulmuş ya da kolaylık katsayısı belirgin şekilde düşmüş kart.
bool isDifficult(ReviewState s) =>
    s.state != CardState.mastered &&
    s.state != CardState.newCard &&
    (s.lapses >= 2 || s.easeFactor < 2.0);
