import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreenJob extends StatelessWidget {
  final Function(String?) onChanged;
    QuizScreenJob({Key? key,
     required this.onChanged,
  }) : super(key: key);

  final List<String?> _options = [
    // Optional value
    'Студент',
    'Працюю',
    'Не працюю',
    'Інше'
  ];
  String? _selectedOption;
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child:
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFA1BDFF)),
                    left: BorderSide(color: Color(0xFFA1BDFF)),
                    right: BorderSide(color: Color(0xFFA1BDFF)),
                    bottom: BorderSide(color: Color(0xFFA1BDFF)),
                  ),
                  color: Color(0xFFF3F7FF),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        child: Container(
                            margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                            child: Image.asset('assets/images/activityQuiz.png', fit: BoxFit.fitWidth,)
                        )
                    ),
                    const SizedBox(height: 30),
                    const Text('Вид зайнятості',
                        style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 28,
                            fontWeight: FontWeight.w700)
                    ),

                    const SizedBox(height: 30),

                    Form(
                        child: Column(
                            children: [
                              const SizedBox(height: 20),
                        SizedBox(
                          height: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: DropdownButtonFormField(
                                value: _selectedOption, // selected option, initialized to null
                                items: _options.map((option) {
                                  return DropdownMenuItem(
                                    value: option,
                                    child: Text(option.toString()),
                                  );
                                }).toList(), // list of options to display in the dropdown
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  hintText: "Вид зайнятості",
                                ),
                                onChanged: onChanged// invoke the callback function with the selected option
                              ),
                            ),
                          ),
                        ),

                              const SizedBox(height: 40),

                              const SizedBox(height: 30),
                            ]
                        )
                    ),

                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Text(
                          "Задля кращої персоналізації, пройдіть коротке опитувавння, яке займе не більше 2 хвилин, але значно покращить ваш досвід користування.",
                          style: TextStyle(fontSize: 14, color: Color(0xFF7A8FC3)),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
