import 'package:flutter/material.dart';


class InputField extends StatelessWidget {

  final controller;
  final bool obscureText;
  final String hintText;

  const InputField({Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
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
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: OutlineInputBorder(
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


