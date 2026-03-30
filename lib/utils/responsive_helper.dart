import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  double get width => MediaQuery.of(context).size.width;

  double get height => MediaQuery.of(context).size.height;

  bool get isTablet => width >= 600;

  double get scale => isTablet ? (width / 500) : (width / 375);
}
