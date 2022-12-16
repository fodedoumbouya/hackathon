import 'package:flutter/material.dart';

typedef IntCallback = void Function(int i);

abstract class BaseWidget extends StatefulWidget {
  const BaseWidget({Key? key}) : super(key: key);

  @override
  BaseWidgetState createState() {
    return getState();
  }

  BaseWidgetState getState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  Image aimg(String name,
      {double? width, double? height, BoxFit? fit, Rect? r, Color? color}) {
    return Image.asset(
      'images/$name.png',
      scale: 368 / sw(),
      width: width,
      height: height,
      fit: fit,
      centerSlice: r,
      color: color,
    );
  }

  Offset getOffsetsPositionsLocal(GlobalKey key) {
    RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);

    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: pageColor,
      body: baseBuild(context),
    );
  }

  double sw() {
    return MediaQuery.of(context).size.width;
  }

  double sh() {
    return MediaQuery.of(context).size.height;
  }

  double xx(double x) {
    return sw() / 1920.0 * x;
  }

  double yy(double y) {
    return sh() / 1200 * y;
  }

  baseBuild(BuildContext context) {}
}
