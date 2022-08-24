import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'X&O game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyAppGame(title: 'X&O game Home Page'),
    );
  }
}

class MyAppGame extends StatefulWidget {
  const MyAppGame({Key? key, required String title}) : super(key: key);

  @override
  State<MyAppGame> createState() => _MyAppState();
}

class _MyAppState extends State<MyAppGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 8, 4, 63),
          centerTitle: true,
          title: const Text(
            "X&O",
            style: TextStyle(color: Colors.white, fontSize: 32),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 31, 191, 220),
          ),
          child: const MyGame(),
        ));
  }
}

class MyGame extends StatefulWidget {
  const MyGame({Key? key}) : super(key: key);

  @override
  State<MyGame> createState() => _MyGameState();
}

List<List<String>> _matrix = [
  ["", "", ""],
  ["", "", ""],
  ["", "", ""]
];
int count = 0;
int oScore = 0, xScore = 0;

class _MyGameState extends State<MyGame> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.rectangle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 165,
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    _char == "O" ? Icons.radio_button_unchecked : Icons.close,
                    size: 50,
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildElement(0, 0),
              buildElement(0, 1),
              buildElement(0, 2)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildElement(1, 0),
              buildElement(1, 1),
              buildElement(1, 2)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildElement(2, 0),
              buildElement(2, 1),
              buildElement(2, 2)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              width: 200,
              height: 120,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 8, 4, 63),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "O score : $oScore",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("X score : $xScore",
                      style: const TextStyle(fontSize: 20, color: Colors.white))
                ],
              )),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 8, 4, 63))),
              onPressed: (() {
                setState(() {
                  oScore = 0;
                  xScore = 0;
                  count = 0;
                  _matrix = [
                    ["", "", ""],
                    ["", "", ""],
                    ["", "", ""]
                  ];
                });
              }),
              child: const Text("Reset"))
        ],
      ),
    );
  }

  String _char = "X";
  Container buildElement(int row, int col) {
    String ele = _matrix[row][col];
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 39, 16, 15), width: 2)),
      child: TextButton(
          onPressed: () {
            //this part is resposible for showing the Xs and Os in its player tern if he pressed on empty box
            if (_matrix[row][col].isEmpty) {
              setState(() {
                _matrix[row][col] = _char;
                _char = _char == "X" ? "O" : "X";
                count++;
              });
            }
            checkWinner(row, col);
          },
          child: Text(
            ele,
            style: const TextStyle(
                fontSize: 60, color: Color.fromARGB(255, 8, 4, 63)),
          )),
    );
  }

//this function used to checkif there were a winner after each player plays
  void checkWinner(int x, int y) {
    int col = 0, row = 0, mdiag = 0, sdiag = 0;
    int n = _matrix.length - 1;
    String play = _matrix[x][y];
    for (int i = 0; i < _matrix.length; i++) {
      if (play == _matrix[x][i]) row++;
      if (play == _matrix[i][y]) col++;
      if (play == _matrix[i][i]) mdiag++;
      if (play == _matrix[i][n - i]) sdiag++;
    }
    if (row == n + 1 || col == n + 1 || mdiag == n + 1 || sdiag == n + 1) {
      {
        play == "O" ? oScore++ : xScore++;
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Winner", style: TextStyle(fontSize: 14)),
                  content:
                      Text("$play won", style: const TextStyle(fontSize: 20)),
                ));
        _matrix = [
          ["", "", ""],
          ["", "", ""],
          ["", "", ""]
        ];
        count = 0;
      }
    } else if (count == 9) {
      showDialog(
          context: context,
          builder: (ctx) => const AlertDialog(
                content: Text("Draw", style: TextStyle(fontSize: 20)),
              ));
      _matrix = [
        ["", "", ""],
        ["", "", ""],
        ["", "", ""]
      ];
      count = 0;
    }
  }
}
