import 'package:flutter/material.dart';

class FirstCoulmn extends StatelessWidget {
  const FirstCoulmn({
    super.key,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
  });

  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth * 0.22;
    final boxHeight = MediaQuery.of(context).size.height * 0.025;

    return Column(
      children: [
        Container(width: boxWidth, height: boxHeight, color: color1),
        Container(width: boxWidth, height: boxHeight, color: color2),
        Container(width: boxWidth, height: boxHeight, color: color3),
        Container(width: boxWidth, height: boxHeight, color: color4),
      ],
    );
  }
}

class SecondCoulmn extends StatelessWidget {
  const SecondCoulmn({
    super.key,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
    required this.cross,
  });

  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;
  final CrossAxisAlignment cross;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height * 0.025;

    return Column(
      crossAxisAlignment: cross,
      children: [
        Container(width: screenWidth * 0.22, height: height, color: color1),
        Container(width: screenWidth * 0.17, height: height, color: color2),
        Container(width: screenWidth * 0.12, height: height, color: color3),
        Container(width: screenWidth * 0.07, height: height, color: color4),
      ],
    );
  }
}

class ThirdCoulmn extends StatelessWidget {
  const ThirdCoulmn({
    super.key,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
    required this.cross,
  });

  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;
  final CrossAxisAlignment cross;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.05;
    final screenHeight = MediaQuery.of(context).size.height;

    return Row(
      crossAxisAlignment: cross,
      children: [
        Container(width: width, height: screenHeight * 0.10, color: color1),
        Container(width: width, height: screenHeight * 0.08, color: color2),
        Container(width: width, height: screenHeight * 0.06, color: color3),
        Container(width: width, height: screenHeight * 0.04, color: color4),
      ],
    );
  }
}

class FourthCoulmn extends StatelessWidget {
  const FourthCoulmn({
    super.key,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
  });

  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.05;
    final height = MediaQuery.of(context).size.height * 0.10;

    return Row(
      children: [
        Container(width: width, height: height, color: color1),
        Container(width: width, height: height, color: color2),
        Container(width: width, height: height, color: color3),
        Container(width: width, height: height, color: color4),
      ],
    );
  }
}
