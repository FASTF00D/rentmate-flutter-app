import 'package:flutter/material.dart';
import 'package:rentmate_flutter_app/quiz/QuizScreenAge.dart';
import 'package:rentmate_flutter_app/quiz/QuizScreenCity.dart';
import 'package:rentmate_flutter_app/quiz/QuizScreenJob.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../home_page.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index){
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              QuizScreenAge(),
              QuizScreenJob(),
              QuizScreenCity(),
            ],
          ),

          Container(
            alignment: Alignment(0,0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      _controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                    },
                    child: Text("back")
                ),

                SmoothPageIndicator(controller: _controller, count: 3),

                onLastPage ?
                GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) {
                                return const HomePage();
                              },
                          ),
                      );
                    },
                  child: Text("done"),
                      )
                    :
                GestureDetector(
                    onTap: (){
                      _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);},
                    child: Text("next"))
              ],
            ),
          )
        ],
      )
    );
  }
}
