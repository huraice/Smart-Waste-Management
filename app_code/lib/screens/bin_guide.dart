import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:splash_screen/reusable_widget/reusable_widget.dart';
import 'package:splash_screen/screens/home_screen.dart';

// ignore: camel_case_types
class binGuide extends StatefulWidget {
  const binGuide({super.key});

  @override
  State<binGuide> createState() => _binGuideState();
}

// ignore: camel_case_types
class _binGuideState extends State<binGuide> {
  final PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 5);
            });
          },
          children: [
            binPage1(),
            binPage2(),
            binPage3(),
            binPage4(),
            binPage5(),
            binPage6(),
          ],
        ),
        Container(

            //ges
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: const Text('Skip'),
                ),
                SmoothPageIndicator(controller: _controller, count: 6),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        child: const Text("Done"),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: const Text("Next"),
                      ),
              ],
            ))
      ]),
    );
  }
}
