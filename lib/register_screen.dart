import 'package:flutter/material.dart';

import 'components/input_field.dart';



class RegisterScreen extends StatelessWidget {
   RegisterScreen({Key? key}) : super(key: key);

  //text editing controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child:
              SizedBox(
              height: MediaQuery.of(context).size.height * 0.95,
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
                            child: Image.asset('assets/images/register.png', fit: BoxFit.fitWidth,)
                          )
                    ),
                    const SizedBox(height: 30),
                    const Text('Реєстрація',
                    style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 28,
                        fontWeight: FontWeight.w700)
                    ),

                    const SizedBox(height: 20),

                     InputField(
                      controller: usernameController,
                      hintText: "Введіть адрес електронної адреси",
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                      InputField(
                        controller: passwordController,
                        hintText: "Введіть пароль",
                        obscureText: true,
                        ),

                    const SizedBox(height: 10),

                     InputField(
                         controller: passwordController,
                         hintText: "Підтвердіть пароль",
                         obscureText: true,
                         ),
                ],
            ),
              ),
            ),
          ),
        ),
    );
  }
}
