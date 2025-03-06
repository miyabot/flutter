import 'package:flutter/material.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: JankenGame());
  }
}

class JankenGame extends StatefulWidget {
  const JankenGame({super.key});

  @override
  State<JankenGame> createState() => _JankenGameState();
}

class _JankenGameState extends State<JankenGame> {
  List<Widget> hands = [
    Image.network('https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiusq_ptNOOC9XkVvWTa88nhB6I7n12fsf95zdnS-n269HpN9dVRd0JCCV0iL2u_tWrDU5XySM8-i9u38-tXp0Wgu6qRF4p-5A1djjVskwkB0SQFxULDss8Uj1o7CYfbMNRpT-kfn3cG4E/s800/janken_gu.png'),
    Image.network('https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhSYYvy3_ZU5FYb8Jug1Gssh483SEIn8hSwWO33rp-7j9m5AFsn9Fyis9oT1DKvykpCEMV6bJGMAaTtABep-1qqr9ZPtiI_aQQsJVWNL6H_i-b6I3O_1-dgwmavPoEI9HHMsuHHPQCHj90/s800/janken_choki.png'),
    Image.network('https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhQhsfUvWhhVJej7FEqYsQbe0EwLCOHYxKU4KnrF026nnfJkiM3yQO2NFmnnX0nD4P2IdCmg8qFQpZMW8vtbs-K7sLpoCqXwO0fkTT7UL5VkM-E2MOUNXpikYfspDKaxidAehqcuQoIrcM/s800/janken_pa.png')
  ];
  late Widget hand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
          onPressed: () {
          hands.shuffle();
          hand = hands[0];
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    actionsAlignment: MainAxisAlignment.start,
                    title: const Text('ロボットくん'),
                    actions: [
                      hand
                    ],
                  );
                });
          },
          child: const Text('じゃんけんするぜよ')),
    ));
  }
}
