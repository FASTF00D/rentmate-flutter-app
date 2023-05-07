import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckBoxQuiz extends StatefulWidget {
  bool isChecked = false;
  bool additionalRegister = false;

  CheckBoxQuiz({Key? key}) : super(key: key);

  @override
  State<CheckBoxQuiz> createState() => _CheckBoxQuizState();
}

class _CheckBoxQuizState extends State<CheckBoxQuiz> {
  bool isChecked = false;
  bool additionalRegister = false;


  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.black;
      }
      return Colors.red;
    }

    return CheckboxListTile(
      title: const Text("Пройти швидке опитування"),
      activeColor: Colors.white,
      checkColor: const Color(0xFF7A8FC3),
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      controlAffinity: ListTileControlAffinity.leading,

      value: isChecked,
      onChanged: (bool? value) async {
        setState(() {
          isChecked = value!;
        });
        if (value == true) {
          additionalRegister = true;
        }
        else{
          additionalRegister = false;
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('needQuiz', additionalRegister);
      },
    );
}
}