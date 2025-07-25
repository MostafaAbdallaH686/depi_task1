import 'package:first_ui/my_colors.dart';
import 'package:first_ui/my_coulmns.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Mostafa AbdallaH",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FirstCoulmn(
                  color1: MyColors.purple1,
                  color2: MyColors.purple2,
                  color3: MyColors.purple3,
                  color4: MyColors.purple4,
                ),
                Spacer(),
                FirstCoulmn(
                  color1: MyColors.green1,
                  color2: MyColors.green2,
                  color3: MyColors.green3,
                  color4: MyColors.green4,
                ),
                Spacer(),
                FirstCoulmn(
                  color1: MyColors.blue1,
                  color2: MyColors.blue2,
                  color3: MyColors.blue3,
                  color4: MyColors.blue4,
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                SecondCoulmn(
                  color1: MyColors.purple1,
                  color2: MyColors.purple2,
                  color3: MyColors.purple3,
                  color4: MyColors.purple4,
                  cross: CrossAxisAlignment.start,
                ),
                Spacer(),
                SecondCoulmn(
                  color1: MyColors.green1,
                  color2: MyColors.green2,
                  color3: MyColors.green3,
                  color4: MyColors.green4,
                  cross: CrossAxisAlignment.center,
                ),
                Spacer(),
                SecondCoulmn(
                  color1: MyColors.blue1,
                  color2: MyColors.blue2,
                  color3: MyColors.blue3,
                  color4: MyColors.blue4,
                  cross: CrossAxisAlignment.end,
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                ThirdCoulmn(
                  color1: MyColors.purple1,
                  color2: MyColors.purple2,
                  color3: MyColors.purple3,
                  color4: MyColors.purple4,
                  cross: CrossAxisAlignment.start,
                ),
                Spacer(),
                ThirdCoulmn(
                  color1: MyColors.green1,
                  color2: MyColors.green2,
                  color3: MyColors.green3,
                  color4: MyColors.green4,
                  cross: CrossAxisAlignment.center,
                ),
                Spacer(),
                ThirdCoulmn(
                  color1: MyColors.blue1,
                  color2: MyColors.blue2,
                  color3: MyColors.blue3,
                  color4: MyColors.blue4,
                  cross: CrossAxisAlignment.end,
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FourthCoulmn(
                  color1: MyColors.purple1,
                  color2: MyColors.purple2,
                  color3: MyColors.purple3,
                  color4: MyColors.purple4,
                ),
                Spacer(),
                FourthCoulmn(
                  color1: MyColors.green1,
                  color2: MyColors.green2,
                  color3: MyColors.green3,
                  color4: MyColors.green4,
                ),
                Spacer(),
                FourthCoulmn(
                  color1: MyColors.blue1,
                  color2: MyColors.blue2,
                  color3: MyColors.blue3,
                  color4: MyColors.blue4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
