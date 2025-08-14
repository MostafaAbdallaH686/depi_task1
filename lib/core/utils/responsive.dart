import 'package:flutter/widgets.dart';

class Breakpoints {
  Breakpoints._();
  static const double mobileMax = 600;
  static const double tabletMax = 1024;
}

class Responsive {
  Responsive._();

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= Breakpoints.mobileMax;
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width > Breakpoints.mobileMax &&
      MediaQuery.sizeOf(context).width <= Breakpoints.tabletMax;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width > Breakpoints.tabletMax;
}