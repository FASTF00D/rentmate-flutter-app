import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:rentmate_flutter_app/components/input_field.dart';
import 'package:rentmate_flutter_app/components/register_login_button.dart';
import 'package:rentmate_flutter_app/home_page.dart';
import 'package:rentmate_flutter_app/quiz_or_home_page.dart';
import 'package:rentmate_flutter_app/register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginPage> {

  TextEditingController usernameLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  void loginUser(String email, password) async {
    Map data = {
      "login": email,
      "password": password,};

    var body = json.encode(data);
    try {
      http.Response response = await http.post(
          Uri.parse('https://deeonepostgres.herokuapp.com/api/auth/login'),
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', responseData['token']);
        QuizOrHomePage().checkQuizPage(context);
      }


      }catch (e) {
      print(e.toString());
    }
  }

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
                          child: Image.asset('assets/images/login.png', fit: BoxFit.fitWidth,)
                      )
                  ),
                  const SizedBox(height: 30),
                  const Text('Вхід',
                      style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 28,
                          fontWeight: FontWeight.w700)
                  ),

                  Form(
                      key: _loginFormKey,
                      child: Column(
                          children: [

                            const SizedBox(height: 20),

                            InputField(
                              controller: usernameLoginController,
                              hintText: "Введіть адресу електронної адреси",
                              obscureText: false,
                            ),

                            const SizedBox(height: 20),

                            InputField(
                              controller: passwordLoginController,
                              hintText: "Введіть пароль",
                              obscureText: true,
                            ),
                            const SizedBox(height: 20),

                            GestureDetector(
                                onTap: (){loginUser(usernameLoginController.text.toString(), passwordLoginController.text.toString());},
                                child: ConfButton(buttonText: "Вхід")),
                            SizedBox(height: 25,)
                          ]
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Не маєте акаунт?"),
                      SizedBox(width: 10),
                      GestureDetector(
                          onTap: (){Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );},
                          child: Text("Реєстрація", style: TextStyle(decoration: TextDecoration.underline,)))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
