import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hackathon/base/base.dart';

class Dice extends BaseWidget {
  IntCallback callback;
  bool onTap;
  Dice({required this.callback, required this.onTap, super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _DiceState();
  }
}

class _DiceState extends BaseWidgetState<Dice> {
  int dice_no = 1;
  void update() async {
    for (var i = 0; i < 4; i++) {
      dice_no = Random().nextInt(6) + 1;
      setState(() {});

      await Future.delayed(const Duration(milliseconds: 500));
    }
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      widget.callback(dice_no);
    });
  }

  @override
  void didUpdateWidget(covariant Dice oldWidget) {
    if (oldWidget.onTap != widget.onTap) {
      if (widget.onTap) {
        update();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: GestureDetector(
        child: aimg("dice$dice_no"),

        /// Image.asset('images/.png'),
        onTap: () {
          update();
        },
      ),
    );
  }
}
