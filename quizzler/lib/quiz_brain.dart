import 'question.dart';

class QuizBrain {
  List<Question> _questionBank = [
    Question(i: '1.', q: 'Japan has square watermelons', a: true),
    Question(i: '2.', q: 'Broccoli was once banned from the White House.', a: true),
    Question(i: '3.', q: 'There are 100 dimples on a golf ball', a: false),
    Question(i: '4.', q: 'Cows sleep standing up.', a: true),
    Question(i: '5.', q: 'The name of Batman\s butler is Albert.', a: false),
    Question(i: '6.', q: 'It\s illegal in Georgia to eat fried chicken with a knife and fork.', a: true),
    Question(i: '7.', q: 'The unicorn is the national animal of Scotland', a: true),
  ];

  String getQuestionNumber() {
    return
        _questionBank[_questionNumber].questionNumber;
  }

  String getQuestionText() {
    return
        _questionBank[_questionNumber].questionText;
  }

  bool getCorrectAnswer() {
    return
        _questionBank[_questionNumber].questionAnswer;
  }

  bool isFinished() {
    if (_questionNumber >= _questionBank.length - 1) {
      print('returning true');
      return true;
    } else {
      return false;
    }
  }

  void nextQuestion() {
    if (_questionNumber < _questionBank.length - 1) {
      _questionNumber++;
    }
  }

  void reset() {
    _questionNumber = 0;
  }

  int _questionNumber = 0;
}