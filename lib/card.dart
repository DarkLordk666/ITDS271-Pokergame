// card.dart

enum Suit {
  clubs,
  diamonds,
  hearts,
  spades,
}

class PokerCard {
  final Suit suit;
  final String value;

  PokerCard({required this.suit, required this.value});

  static int getValueIndexForCard(String value) {
    final List<String> values = [
      '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'
    ];
    return values.indexOf(value);
  }
}