import 'dart:math';

import 'package:flutter_app/models/sentence.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Sentence> _details = [Sentence("How are you?", "Hogy vagy?"),
    Sentence("I wish I were pretty.", "Bárcsak csinos lennék."),
    Sentence("We went to the cinema yesterday.", "Tegnap moziba mentünk."),
    Sentence("Tom was working when the telephone rang.", "Tom éppen dolgozott amikor a telefon csengett."),
    Sentence("Before I married her we had bought a new house.", "Mielőtt elvettem feleségül, vettünk egy lakást."),
    Sentence("We had been dancing for half an hour when they arrived.", "Már félórája táncoltunk, amikor megérkeztek."),
    Sentence("We were very tired because we had been studying since the morning.", "Nagyon fáradtak voltunk, mert reggel óta tanultunk."),
    Sentence("I go to bed early every day.", "Minden nap korán fekszem le."),
    Sentence("Dad isn't working, he is having lunch now.", "Apu most éppen nem dolgozik hanem ebédel."),
    Sentence("I've already mailed the package.", "Már feladtam a csomagot."),
    Sentence("How long have you been learning to drive?", "Mióta tanulsz vezetni?"),
    Sentence("By this time next year I will have got my driver's license.", "Jövő ilyenkorra már letettem a jogsit."),
  ];
  final myController = TextEditingController();
  String answer = "";
  bool? isRight = null;
  int _points = 0;
  int _nextElement = Random().nextInt(12);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (isRight == true) {
        _details.removeAt(_nextElement);
      }
      _counter++;
      isRight = null;
      myController.text = "";
      _nextElement = Random().nextInt(_details.length);
    });
  }

  String removeDiacritics(String str) {
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  void _checkSentence() {
    setState(() {
      answer = myController.text;
      isRight = removeDiacritics(answer.toLowerCase()) == removeDiacritics(_details[_nextElement].english.toLowerCase());
      if (isRight == true) {
        _points = _points+1;
      }

      if (_details.length == 0) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('You lose'),
            content: const Text('Sorry!'),
            actions: <Widget>[
              TextButton(
                onPressed:() {
                  Navigator.pop(context); // Dismisses dialog
                  Navigator.pop(context); // Navigates back to previous screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      if (isRight == false) {
        _points = 0;
      }

      if(_points == 5) {
        _points = 0;
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('You win'),
            content: const Text('Congratulation!'),
            actions: <Widget>[
              TextButton(
                onPressed:() {
                  Navigator.pop(context); // Dismisses dialog
                  Navigator.pop(context); // Navigates back to previous screen

                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }

      myController.text = "";
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    String _hungarian = _details[_nextElement].hungarian;
    String _english = _details[_nextElement].english;
    int number = _counter+1;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Your points", style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('$_points', style: Theme.of(context).textTheme.headline4),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("This is your $number. sentence", style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("$_hungarian", style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                      ),
                      Visibility(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextField(
                                controller: myController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Translation in english',
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ElevatedButton(
                                    onPressed: _checkSentence,
                                    child: Text('CHECK ANSWER'),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _incrementCounter,
                                  child: Text('NEXT QUESTION'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        visible: isRight == null,
                      ),
                      Visibility(child:
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 42.0,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text("Your answer was bad.",
                                style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),

                          ],
                        ),
                      ),
                        visible: isRight == false,
                      ),
                      Visibility(child:
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 42.0,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text("Your answer was good!",
                                style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                        visible: isRight == true,
                      ),
                      Visibility(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text("Your answer: $answer",
                                style: TextStyle(fontSize: 15, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text("Right answer: $_english",
                                style: TextStyle(fontSize: 15, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                onPressed: _incrementCounter,
                                child: Text('NEXT QUESTION'),
                              ),
                            ),
                          ],
                        ),
                        visible: isRight != null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
