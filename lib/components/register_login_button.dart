import 'package:flutter/material.dart';

class ConfButton extends StatelessWidget {
  final String buttonText;

   const ConfButton({Key? key,
     required this.buttonText
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration:  BoxDecoration(color: Color(0xFF6788DC),
              borderRadius: BorderRadius.circular(20)
          ),
            child:  Center(
              child: Text(
                  buttonText,
              style: const TextStyle(color: Colors.white,
              fontSize: 20,
              )
              )
            )
        );
  }
}
