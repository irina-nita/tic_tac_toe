import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToe());
}

/// Picks an image based on the player's value.
Image checkValue({required bool x, required bool o}) {
  if (x) {
    return Image.asset('assets/images/x.png');
  } else {
    return Image.asset('assets/images/o.png');
  }
}

/// Checks the winner based on the players' positions.
String checkWinner(List<String?> game) {
  for (int i = 0; i <= 6; i++) {
    if (game[i] != null && game[i] == game[i + 1] && game[i + 1] == game[i + 2]) {
      return game[i]!;
    }
  }
  for (int i = 0; i < 3; i++) {
    if (game[i] != null && game[i] == game[i + 3] && game[i + 3] == game[i + 6]) {
      return game[i]!;
    }
  }
  if (game[0] != null && game[0] == game[4] && game[0] == game[8]) {
    return game[0]!;
  }
  if (game[2] != null && game[2] == game[4] && game[2] == game[6]) {
    return game[2]!;
  }
  return '';
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: const Color(0xffcad2c5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff52796f),
        ),
        fontFamily: 'Montserrat',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Image?> img = List<Image?>.filled(9, null);

  bool hasTappedX = false;
  bool hasTappedO = false;

  List<String?> game = List<String?>.filled(9, null);

  String winner = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GridView.builder(
            itemCount: 9,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    /// Checks the player's turn.
                    if (!hasTappedX && !hasTappedO && img[index] == null) {
                      img[index] = checkValue(x: true, o: false);
                      game[index] = 'x';
                      hasTappedX = true;
                    } else if (hasTappedX && img[index] == null) {
                      img[index] = checkValue(x: false, o: true);
                      game[index] = '0';
                      hasTappedO = true;
                      hasTappedX = false;
                    } else if (hasTappedO && img[index] == null) {
                      img[index] = checkValue(x: true, o: false);
                      game[index] = 'x';
                      hasTappedO = false;
                      hasTappedX = true;
                    }
                  });

                  winner = checkWinner(game);

                  /// Pop up message if someone has won.
                  if (winner != '') {
                    Timer(const Duration(seconds: 1), () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              '$winner won!⭐️',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                                color: Color(0xff000000),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    /// Resets game from start.
                                    img = List<Image?>.filled(9, null);
                                    hasTappedX = false;
                                    hasTappedO = false;
                                    game = List<String?>.filled(9, null);
                                  });
                                  Navigator.pop(context, 'Cancel');
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.lightBlue),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    });
                  }
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff52796f)),
                  ),
                  child: img[index],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () {
                /// Resets game from start.
                setState(() {
                  img = List<Image?>.filled(9, null);
                  hasTappedX = false;
                  hasTappedO = false;
                  game = List<String?>.filled(9, null);
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xff333d29), width: 1.4),
              ),
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 25,
                  color: Color(0xff333d29),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
