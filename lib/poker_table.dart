// poker_table.dart

import 'package:flutter/material.dart';
import 'deck.dart';
import 'card.dart' as poker;
import 'dart:math';

class PokerTable extends StatefulWidget {
  @override
  _PokerTableState createState() => _PokerTableState();
}

class _PokerTableState extends State<PokerTable> {
  Deck deck = Deck();
  List<poker.PokerCard> playerCards = [];
  List<poker.PokerCard> boardCards = [];
  List<poker.PokerCard> botCards = [];
  Bot bot = Bot(); // Create Bot instance

  bool gameStarted = false;

  void startGame() {
    setState(() {
      // Reset game state
      playerCards.clear();
      boardCards.clear();
      botCards.clear();
      gameStarted = true;

      // Deal 2 cards to player
      playerCards = deck.dealCards();

      // Deal 2 cards to bot (hide from view)
      botCards = deck.dealCards();

      // Deal board cards (Flop, Turn, River)
      if (boardCards.isEmpty) {
        boardCards = deck.dealFlop();
      } else if (boardCards.length < 5) {
        boardCards.add(deck.dealTurnOrRiver());
      }

      // Bot makes decision and takes action
      bot.takeAction(boardCards);

      // Determine winner and payout
      determineWinner();
    });
  }

  void determineWinner() {
    if (boardCards.length == 5) {
      // Get best hand for player and bot
      List<poker.PokerCard> playerBestHand = getBestHand([...playerCards, ...boardCards]);
      List<poker.PokerCard> botBestHand = getBestHand([...botCards, ...boardCards]);

      // Compare hands to determine winner
      int result = compareHands(playerBestHand, botBestHand);
      if (result > 0) {
        print('You win!');
        // Handle player winning logic
      } else if (result < 0) {
        print('Bot wins!');
        // Handle bot winning logic
      } else {
        print('It\'s a tie!');
        // Handle tie logic
      }
    }
  }

  List<poker.PokerCard> getBestHand(List<poker.PokerCard> cards) {
    // Implement logic to determine the best hand from the given cards
    // This could involve checking for different combinations like flush, straight, etc.
    // and returning the best combination
    // Example:
    // Sort cards by value
    cards.sort((a, b) => poker.PokerCard.getValueIndexForCard(b.value).compareTo(poker.PokerCard.getValueIndexForCard(a.value)));
    // Check for royal flush, straight flush, etc.
    // Implement more detailed logic based on poker hand rankings
    return cards.sublist(0, 5); // Placeholder implementation, assuming just top 5 cards for simplicity
  }

  int compareHands(List<poker.PokerCard> hand1, List<poker.PokerCard> hand2) {
    // Compare two poker hands and return:
    // >0 if hand1 is better, <0 if hand2 is better, 0 if they are tied
    // Implement comparison logic based on poker hand rankings
    // Example:
    // Compare hand rankings
    // Return result based on comparison
    return 0; // Placeholder implementation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poker Table'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Poker Table!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            if (!gameStarted)
              ElevatedButton(
                onPressed: startGame,
                child: Text('Start Game'),
              ),
            SizedBox(height: 20),
            Visibility(
              visible: gameStarted,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Fold logic
                      print('You chose to Fold.');
                    },
                    child: Text('Fold'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Check logic
                      print('You chose to Check.');
                    },
                    child: Text('Check'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Raise logic
                      print('You chose to Raise.');
                    },
                    child: Text('Raise'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (playerCards.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Your Cards:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var card in playerCards)
                        PokerCardWidget(card: card),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 20),
            if (boardCards.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Board:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var card in boardCards)
                        PokerCardWidget(card: card),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 20),
            if (botCards.isNotEmpty) // Display bot's cards
              Column(
                children: [
                  Text(
                    'Bot Cards:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var card in botCards)
                        PokerCardWidget(card: card, isHidden: true), // Show hidden cards for bot
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class PokerCardWidget extends StatelessWidget {
  final poker.PokerCard card;
  final bool isHidden;

  const PokerCardWidget({required this.card, this.isHidden = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          isHidden ? 'Hidden' : '${card.value} ${getSuitSymbol(card.suit)}',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  String getSuitSymbol(poker.Suit suit) {
    switch (suit) {
      case poker.Suit.clubs:
        return '♣';
      case poker.Suit.diamonds:
        return '♦';
      case poker.Suit.hearts:
        return '♥';
      case poker.Suit.spades:
        return '♠';
      default:
        return '';
    }
  }
}

class Bot {
  List<poker.PokerCard> cards = [];

  void takeAction(List<poker.PokerCard> boardCards) {
    Random random = Random();

    if (random.nextBool()) {
      // Bot chooses to Fold or end the betting
      // You can add other action conditions based on game rules
      print('Bot chooses to Fold.');
    } else {
      // Bot chooses to Call or Raise based on game rules
      // You can add other action conditions based on game rules
      print('Bot chooses to Call or Raise.');
    }
  }
}