import 'package:flutter/material.dart';
import 'package:hackathon/base/base.dart';
import 'package:hackathon/pages/dice.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class HomePage extends BaseWidget {
  const HomePage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _HomePageState();
  }
}

class Ground {
  int index;
  GlobalKey key;
  String img;
  bool isLefttEnd;
  Color testColor;
  bool isGoingUp;
  bool isGoingDown;

  // bool isQuestion;
  Ground({
    required this.index,
    required this.key,
    required this.img,
    required this.testColor,
    this.isGoingUp = false,
    this.isGoingDown = false,
    this.isLefttEnd = false,
  });
}

class Car {
  Offset position;
  Ground ground;
  Direction direction;
  String image;
  int quarterTurns;

  Car(
      {required this.direction,
      required this.ground,
      required this.position,
      this.image = "voiture",
      this.quarterTurns = 1});
}

enum Direction {
  LEFT,
  RIGHT,
  TOP,
  BOTTOM,
}

class Battery {
  int pourcentage;
  String status;

  Battery({required this.pourcentage, required this.status});
}

class _HomePageState extends BaseWidgetState<HomePage> {
  List<Ground> list = [];
  late Car car;
  bool onTap = false;

  Battery battery = Battery(pourcentage: 100, status: "Charger"); //Battery

  genereteGround() {
    bool isNewLine = false;
    for (var i = 1; i <= 50; i++) {
      bool isLefttEnd = false;
      String img = "route";
      Color testColor = Colors.red;
      if (isNewLine) {
        testColor = Colors.green;
        img = "angle_hautgauche";
        if (i == 21 || i == 41) {
          img = "angle_basgauche";
        }
      }
      if (i % 10 == 0) {
        isLefttEnd = true;
        isNewLine = true;
        testColor = Colors.blue;
        img = "angle_hautdroit";
        if (i % 20 == 0) {
          img = "angle_basdroit";
        }
      } else {
        isNewLine = false;
      }
      if (i == 50) {
        img = "route";
      }
      Ground g = Ground(
        index: i,
        key: GlobalKey(),
        img: img,
        isLefttEnd: isLefttEnd,
        isGoingUp: i % 8 == 0,
        isGoingDown: i % 4 == 0,
        testColor: testColor,
      );
      list.add(g);
    }
    car = Car(
        direction: Direction.LEFT,
        ground: list[0],
        position: const Offset(0, 0));
  }

  Offset offset = const Offset(0, 0);

  @override
  void initState() {
    genereteGround();
    super.initState();
  }

  moveCar({required int moveCase}) async {
    if (car.ground.index == 50) {
      return;
    }
    if (car.quarterTurns == 1) {
      int add = car.ground.index + moveCase;
      if (add <= 10 || (add > 20 && add <= 30) || (add > 40 && add <= 60)) {
        if (add > 50) {
          add = 50;
        }
        Ground g = list.firstWhere((element) => element.index == add);
        car.position = getOffsetsPositionsLocal(g.key);
        car.ground = g;
        setState(() {});
      } else {
        int a = 10;
        int b = 20;
        if (car.ground.index > 20) {
          a = 30;
          b = 40;
        }
        int rest = a - car.ground.index;
        rest = moveCase - rest;
        Ground g = list.firstWhere((element) => element.index == a);
        car.position = getOffsetsPositionsLocal(g.key);
        car.ground = g;

        setState(() {});
        await Future.delayed(const Duration(seconds: 1));
        car.quarterTurns = 2;
        g = list.firstWhere((element) => element.index == b);
        car.position = getOffsetsPositionsLocal(g.key);
        car.ground = g;

        setState(() {});
        await Future.delayed(const Duration(seconds: 1));
        g = list.firstWhere((element) => element.index == (b - rest));
        car.position = getOffsetsPositionsLocal(g.key);
        car.quarterTurns = 3;
        car.ground = g;

        setState(() {});
      }
    } else if (car.quarterTurns == 3) {
      int m = car.ground.index - moveCase;
      if ((m >= 11 || (m >= 30 && m <= 11))) {
        if (car.ground.index == 31) {
          int a = 31;
          int b = 41;
          int rest = a - car.ground.index;

          rest = moveCase - rest;

          Ground g = list.firstWhere((element) => element.index == a);
          car.position = getOffsetsPositionsLocal(g.key);
          car.ground = g;

          setState(() {});
          await Future.delayed(const Duration(seconds: 1));
          car.quarterTurns = 2;
          g = list.firstWhere((element) => element.index == b);
          car.position = getOffsetsPositionsLocal(g.key);
          car.ground = g;
          setState(() {});
          await Future.delayed(const Duration(seconds: 1));
          g = list.firstWhere((element) => element.index == (b + rest.abs()));
          car.position = getOffsetsPositionsLocal(g.key);
          car.quarterTurns = 1;
          car.ground = g;
          setState(() {});
        } else {
          Ground g = list.firstWhere((element) => element.index == m);
          car.position = getOffsetsPositionsLocal(g.key);
          car.ground = g;
          setState(() {});
        }
      } else {
        int a = 10;
        int b = 20;

        int rest = a - car.ground.index;

        rest = moveCase - rest;

        Ground g = list.firstWhere((element) => element.index == a);
        car.position = getOffsetsPositionsLocal(g.key);
        car.ground = g;

        setState(() {});
        await Future.delayed(const Duration(seconds: 1));
        car.quarterTurns = 2;
        g = list.firstWhere((element) => element.index == b);
        car.position = getOffsetsPositionsLocal(g.key);
        car.ground = g;
        setState(() {});
        await Future.delayed(const Duration(seconds: 1));
        g = list.firstWhere((element) => element.index == (b + rest));
        car.position = getOffsetsPositionsLocal(g.key);
        car.quarterTurns = 1;
        car.ground = g;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: sh(),
            width: sw(),
            // color: Colors.red,
            child: GridView.count(
              crossAxisCount: 10,
              children: List.generate(list.length, (index) {
                Ground g = list[index];
                return GestureDetector(
                  onTap: () {
                    // offset = getOffsetsPositionsLocal(g.key);
                    // setState(() {});
                    moveCar(moveCase: 4);
                  },
                  child: Container(
                      key: g.key,
                      color: g.testColor,
                      child: Stack(
                        children: [
                          aimg(g.img),
                          Text("${g.isGoingDown}"),
                        ],
                      )
                      //

                      ),
                );
              }),
            ),
          ),
        ),
        AnimatedPositioned(
            top: car.position.dy,
            left: car.position.dx,
            duration: const Duration(seconds: 1),
            child: RotatedBox(
              quarterTurns: car.quarterTurns,
              child: SizedBox(
                height: yy(150),
                width: xx(150),
                child: aimg(car.image),
              ),
            )),
        Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            height: yy(320),
            width: xx(350),
            // color: Colors.blue,
            child: LiquidCircularProgressIndicator(
              value: battery.pourcentage / 100, // Defaults to 0.5.
              valueColor: const AlwaysStoppedAnimation(
                  Colors.green), // Defaults to the current Theme's accentColor.
              backgroundColor: Colors
                  .white, // Defaults to the current Theme's backgroundColor.
              borderColor: Colors.green,
              borderWidth: 5.0,
              direction: Axis
                  .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${battery.pourcentage}%"),
                  Text(battery.status),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            bottom: yy(0),
            left: xx(700),
            child: SizedBox(
              height: yy(320),
              width: xx(350),
              // color: Colors.black,
              child: Dice(
                onTap: onTap,
                callback: (i) {
                  onTap = false;
                  setState(() {});
                  moveCar(moveCase: i);
                },
              ),
            )),
        Positioned(
            bottom: yy(0),
            right: xx(200),
            child: SizedBox(
              height: yy(320),
              width: xx(350),
              // color: Colors.orange,
              child: GestureDetector(
                onTap: () {
                  if (!onTap) {
                    onTap = true;
                  }
                  setState(() {});
                },
                child: Center(
                  child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0xFF757575),
                                offset: Offset(4.0, 4.0),
                                blurRadius: 15.0,
                                spreadRadius: 1.0),
                            BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4.0, -4.0),
                                blurRadius: 15.0,
                                spreadRadius: 1.0),
                          ],
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFEEEEEE),
                                Color(0xFFE0E0E0),
                                Color(0XFFBDBDBD),
                                Color(0xFF9E9E9E),
                              ],
                              stops: [
                                0.1,
                                0.3,
                                0.8,
                                0.9
                              ])),
                      child: Center(
                          child: Text(
                        "Launcer le de",
                        style: TextStyle(
                          color: onTap ? Colors.red : Colors.black,
                        ),
                      ))),
                ),
              ),
            )),
      ]),
    );
  }
}
