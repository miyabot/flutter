import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> questions = [
    Question(text: "Flutter is developed by Google.", isCorrect: true),
    Question(text: "Dart is used to develop Flutter apps.", isCorrect: true),
    Question(text: "Flutter is only for mobile app development.", isCorrect: false),
  ];

  int currentQuestionIndex = 0;
  int score = 0;

  void checkAnswer(bool userAnswer) {
    if (userAnswer == questions[currentQuestionIndex].isCorrect) {
      score++;
    }

    setState(() {
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
      ),
      body: currentQuestionIndex < questions.length
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  questions[currentQuestionIndex].text,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => checkAnswer(true),
                  child: Text("True"),
                ),
                ElevatedButton(
                  onPressed: () => checkAnswer(false),
                  child: Text("False"),
                ),
              ],
            )
          : Center(
              child: Text(
                "Quiz Finished!\nYour Score: $score/${questions.length}",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}

class Question {
  String text;
  bool isCorrect;

  Question({required this.text, required this.isCorrect});
}
