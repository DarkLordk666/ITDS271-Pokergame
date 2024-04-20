// deck.dart

import 'dart:math';
import 'card.dart' as poker;

class Deck {
  List<poker.PokerCard> cards = [];
  Random random = Random();

  Deck() {
    final List<String> values = [
      '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'
    ];

    for (var suit in poker.Suit.values) {
      for (var value in values) {
        cards.add(poker.PokerCard(suit: suit, value: value));
      }
    }
  }

  List<poker.PokerCard> dealCards() {
    List<poker.PokerCard> dealtCards = [];

    for (int i = 0; i < 2; i++) {
      int index = random.nextInt(cards.length);
      dealtCards.add(cards[index]);
      cards.removeAt(index);
    }

    return dealtCards;
  }

  List<poker.PokerCard> dealFlop() {
    List<poker.PokerCard> flopCards = [];

    for (int i = 0; i < 3; i++) {
      int index = random.nextInt(cards.length);
      flopCards.add(cards[index]);
      cards.removeAt(index);
    }

    return flopCards;
  }

  poker.PokerCard dealTurnOrRiver() {
    int index = random.nextInt(cards.length);
    poker.PokerCard turnOrRiverCard = cards[index];
    cards.removeAt(index);
    return turnOrRiverCard;
  }
}