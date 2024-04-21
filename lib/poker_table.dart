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
  Bot bot = Bot();

  int playerChips = 10000;
  int playerBetAmount = 0;
  int tempBetAmount = 0;

  bool gameStarted = false;

  void handleBet(int amount) {
    setState(() {
      if (playerChips >= amount) {
        tempBetAmount += amount;
        playerChips -= amount;
      }
    });

    // Bot starts its turn after player confirms bet
    bot.takeAction(boardCards); // Bot makes decision and takes action
  }

  void handleReduceBet(int amount) {
    setState(() {
      if (tempBetAmount >= amount) {
        tempBetAmount -= amount;
        playerChips += amount;
      }
    });
  }

  void confirmBet() {
    setState(() {
      playerBetAmount = tempBetAmount;
      gameStarted = true;
    });

    // Bot starts its turn after player confirms bet
    bot.takeAction(boardCards); // Bot makes decision and takes action
  }

  void startGame() {
    setState(() {
      playerCards.clear();
      boardCards.clear();
      botCards.clear();
      playerBetAmount = 0;
      tempBetAmount = 0;
      gameStarted = true;

      playerCards = deck.dealCards();

      botCards = deck.dealCards();

      if (boardCards.isEmpty) {
        boardCards = deck.dealFlop();
      } else if (boardCards.length < 5) {
        boardCards.add(deck.dealTurnOrRiver());
      }

      bot.takeAction(boardCards);

      determineWinner();
    });
  }

  void determineWinner() {
    if (boardCards.length == 5) {
      List<poker.PokerCard> playerBestHand = getBestHand([...playerCards, ...boardCards]);
      List<poker.PokerCard> botBestHand = getBestHand([...botCards, ...boardCards]);

      int result = compareHands(playerBestHand, botBestHand);
      if (result > 0) {
        print('You win!');
      } else if (result < 0) {
        print('Bot wins!');
      } else {
        print('It\'s a tie!');
      }
    }
  }

  List<poker.PokerCard> getBestHand(List<poker.PokerCard> cards) {
    cards.sort((a, b) => poker.PokerCard.getValueIndexForCard(b.value).compareTo(poker.PokerCard.getValueIndexForCard(a.value)));
    return cards.sublist(0, 5);
  }

  int compareHands(List<poker.PokerCard> hand1, List<poker.PokerCard> hand2) {
    return 0; // Placeholder implementation
  }

  void fold() {
    setState(() {
      print('You folded.');
      // Bot takes its turn after player folds
      bot.takeAction(boardCards); // Bot makes decision and takes action
    });
  }

  void check() {
    setState(() {
      print('You checked.');
      // Bot takes its turn after player checks
      bot.takeAction(boardCards); // Bot makes decision and takes action
    });
  }

  void raise(int amount) {
    setState(() {
      handleBet(amount);
      print('You raised by $amount.');
      // Bot takes its turn after player raises
      bot.takeAction(boardCards); // Bot makes decision and takes action
    });
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
              child: Column(
                children: [
                  if (botCards.isNotEmpty)
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
                              PokerCardWidget(card: card, isHidden: true),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text('Bot Chips: ${bot.botChips}'),
                        SizedBox(height: 10),
                        Text('Bot Bet: ${bot.botBet}'),
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
                        SizedBox(height: 20),
                        Text('Your Chips: $playerChips'),
                        SizedBox(height: 10),
                        Text('Your Bet: $playerBetAmount'),
                      ],
                    ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: playerBetAmount == 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => handleBet(100),
                          child: Text('Bet 100'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => handleBet(1000),
                          child: Text('Bet 1000'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => handleReduceBet(100),
                          child: Text('Reduce 100'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => handleReduceBet(1000),
                          child: Text('Reduce 1000'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: tempBetAmount > 0,
                    child: ElevatedButton(
                      onPressed: confirmBet,
                      child: Text('Confirm Bet'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: playerBetAmount > 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: fold,
                          child: Text('Fold'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: check,
                          child: Text('Check'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => raise(100),
                          child: Text('Raise 100'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
  int _botBet = 0;
  int _botChips = 10000; // Initial bot chips

  int get botBet => _botBet;

  int get botChips => _botChips;

  void takeAction(List<poker.PokerCard> boardCards) {
    Random random = Random();

    if (random.nextBool()) {
      print('Bot chooses to Fold.');
    } else {
      int raiseAmount = random.nextInt(1000) + 100;
      _botBet += raiseAmount;
      _botChips -= raiseAmount;
      print('Bot chooses to Raise by $raiseAmount.');
    }
  }
}
