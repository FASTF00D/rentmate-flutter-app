import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmate_flutter_app/quiz/QuizScreenAge.dart';
import 'package:rentmate_flutter_app/quiz/QuizScreenCity.dart';
import 'package:rentmate_flutter_app/quiz/QuizScreenJob.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

import '../home_page.dart';

class QuizScreen extends StatefulWidget {

   const QuizScreen({Key? key}) : super(key: key);
  @override
  _QuizScreenState createState() => _QuizScreenState();
}


class _QuizScreenState extends State<QuizScreen> {
  PageController _controller = PageController();
  TextEditingController cont1 = TextEditingController();
  int _currentPageIndex = 0;
  bool _isLastPage = false;

  void initState() {
    super.initState();
    _controller.addListener(_onPageChanged);
  }


  void dispose() {
    _controller.removeListener(_onPageChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    setState(() {
      _currentPageIndex = _controller.page!.round();
      _isLastPage = _currentPageIndex == 2;
    });
  }

  void _goToNextPage() {
    _controller.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void _goToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
  approveQuiz(List<String> userAnswer) async {
    final String? token = await SharedPreferences.getInstance().then((prefs) => prefs.getString('token'));
    String city_name = userAnswers[2];
    String activity = userAnswers[1];
    String age = userAnswers[0];
    String newSelectedActivity = "";

    if (activity == "Студент") {
      newSelectedActivity = "STUDENT";
    } else if (activity == "Працюю") {
      newSelectedActivity = "EMPLOYED";
    } else if (activity == "Не працюю") {
      newSelectedActivity = "UNEMPLOYED";
    } else if (activity == "Інше") {
      newSelectedActivity = "OTHER";
    }

    print(newSelectedActivity);

    Map data = {
      "city_name": city_name,
      "activity": newSelectedActivity,
      "age":  age
    };

    var body = json.encode(data);
    try {
      http.Response response = await http.put(
          Uri.parse('https://deeonepostgres.herokuapp.com/api/profiles'),
          headers: {"Content-Type": "application/json", 'Authorization': 'Bearer $token'},
          body: body
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
       Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      }


    }catch (e) {
      print(e.toString());
    }
  }

  List<String> pageVariables = ["", "", ""];

  void onPageChanged(int index, String value) {
    setState(() {
      pageVariables[index] = value;
    });
  }


  List<String> userAnswers = List.filled(3, ''); // replace 3 with the number of pages in PageView
  String? job;

  void onJobChanged(String? value) {
    job = value;
    // you can also save the data to SharedPreferences here if needed
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) => onPageChanged(index, ""),
            controller: _controller,
            children: [
              QuizScreenAge(onChanged: (value) {
                userAnswers[0] = value;},),
              QuizScreenJob(onChanged: (value) {
                  userAnswers[1] = value!;},),
              QuizScreenCity(onChanged: (value) {
                userAnswers[2] = value;}),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.8),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentPageIndex > 0)
                  GestureDetector(
                    onTap: () {
                      _controller.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: Icon(Icons.arrow_back_ios_new),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                  ),
                ),
                if (_isLastPage)
                  GestureDetector(
                    child: GestureDetector(
                        onTap: (){approveQuiz(userAnswers);},
                        child: Icon(Icons.done_outlined)),
                  )
                else
                  GestureDetector(
                    onTap: _goToNextPage,
                    child: Icon(Icons.arrow_forward_ios),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}