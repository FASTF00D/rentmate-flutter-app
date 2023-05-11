import 'package:flutter/material.dart';


class InputFieldQuiz extends StatelessWidget {

  final controller;
  final bool obscureText;
  final String hintText;
  final onChanged;

  const InputFieldQuiz({Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: TextFormField(
            onChanged: onChanged,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: hintText,
            ),
          ),
        ),
      ),
    );
  }
}
