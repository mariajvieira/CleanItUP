import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../JsonModels/users.dart';

class QuizScreen extends StatefulWidget {
  final Users user;

  const QuizScreen({Key? key, required this.user}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> _quizQuestions = [
    {
      'question': 'What is the primary cause of global warming?',
      'options': ['Deforestation', 'Greenhouse gases', 'Ocean pollution', 'None of the above'],
      'answer': 'Greenhouse gases'
    },
    {
      'question': 'Which gas is most responsible for the greenhouse effect?',
      'options': ['Oxygen', 'Hydrogen', 'Carbon dioxide', 'Nitrogen'],
      'answer': 'Carbon dioxide'
    },
  ];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizFinished = false;

  void _checkAnswer(String selectedOption) {
    if (selectedOption == _quizQuestions[_currentQuestionIndex]['answer']) {
      setState(() {
        _score += 10; //  10 points for each correct answer
      });
    }

    if (_currentQuestionIndex == _quizQuestions.length - 1) {
      setState(() {
        _isQuizFinished = true;
        _updateUserScore();
      });
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  Future<void> _updateUserScore() async {
    try {
      var userDoc = FirebaseFirestore.instance.collection('users').doc(widget.user.id);
      await userDoc.update({
        'points': FieldValue.increment(_score)
      });
    } catch (e) {
      print('Error updating score: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        backgroundColor: Colors.teal,
      ),
      body: _isQuizFinished
          ? Center(
        child: Text('Quiz Finished! Your score: $_score',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _quizQuestions[_currentQuestionIndex]['question'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            ..._quizQuestions[_currentQuestionIndex]['options'].map((option) {
              return ElevatedButton(
                onPressed: () => _checkAnswer(option),
                child: Text(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
