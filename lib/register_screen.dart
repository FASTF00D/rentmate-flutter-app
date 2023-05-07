
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:rentmate_flutter_app/components/checkbox_register.dart';
import 'package:rentmate_flutter_app/components/register_login_button.dart';
import 'package:rentmate_flutter_app/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/input_field.dart';


class RegisterScreen extends StatefulWidget {


  const RegisterScreen({Key? key,}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  //text editing controller
   final TextEditingController _usernameController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();
   final TextEditingController _passwordConfirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void register(String email, password, confirmPassword) async {
    if (password != confirmPassword) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Помилка",
        confirmBtnText: "Окей",
        confirmBtnColor: const Color(0xFF556FB9),
        text: 'Паролі не співпадають',
      );}
    else if(password == confirmPassword){
    Map data = {
      "email": email,
      "password": password,};

    var body = json.encode(data);
    try {

      http.Response response = await http.post(
          Uri.parse('https://deeonepostgres.herokuapp.com/api/users'),
          headers: {"Content-Type": "application/json"},
          body: body
      );
      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body.toString());
        print(responseData[1]['token']);
        print("acc created succesfully");
        QuickAlert.show(context: context,
          type: QuickAlertType.info,
          title: "Інфо",
          confirmBtnText: "Окей",
          confirmBtnColor: const Color(0xFF556FB9),
          onConfirmBtnTap: () async {
            await Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          text: 'Підтвердіть ваш аккаунт на пошті $email',
        );
      } else if (response.statusCode == 409) {
        QuickAlert.show(context: context,
            type: QuickAlertType.error,
            title: "Помилка",
            confirmBtnText: "Окей",
            confirmBtnColor: const Color(0xFF556FB9),
            text: 'Обліковий запис з такою поштою вже існує $email'
        );
      }
      else if (response.statusCode == 400) {
        var responseData = jsonDecode(response.body.toString());
        final field = responseData['fieldErrors'][0]['field'];
        if (field == 'email must be valid') {
          QuickAlert.show(context: context,
              type: QuickAlertType.error,
              title: "Помилка",
              confirmBtnText: "Окей",
              confirmBtnColor: const Color(0xFF556FB9),
              text: 'Введіть правильну електронну пошту'
          );
        }
        else if (field == 'password must be 8<length<30') {
          QuickAlert.show(context: context,
              type: QuickAlertType.error,
              title: "Помилка",
              confirmBtnText: "Окей",
              confirmBtnColor: const Color(0xFF556FB9),
              text: 'Пароль повинен містити більше 8 символів'
          );
        }
      }
      else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }
  }

  //singInuser method
  void singUserIn() async{
    // showDialog(
    //     context: context,
    //     builder: (context){
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child:
              SingleChildScrollView(
                child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.90,
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

                      Form(
                          key: _formKey,
                          child: Column(
                          children: [

                          const SizedBox(height: 20),

                          InputField(
                                controller: _usernameController,
                                hintText: "Введіть адресу електронної адреси",
                                obscureText: false,
                                        ),

                          const SizedBox(height: 10),

                          InputField(
                            controller: _passwordController,
                            hintText: "Введіть пароль",
                            obscureText: true,
                            ),
                          const SizedBox(height: 10),

                         InputField(
                             controller: _passwordConfirmController,
                             hintText: "Підтвердіть пароль",
                             obscureText: true,
                             ),
                          const SizedBox(height: 10),

                          GestureDetector(
                              onTap: (){register(_usernameController.text.toString(), _passwordController.text.toString(), _passwordConfirmController.text.toString());},
                              child: ConfButton(buttonText: "Зареєструватись",)),

                          Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: CheckBoxQuiz()
                          ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Маєте акаунт?"),
                          SizedBox(width: 10),
                          GestureDetector(
                              onTap: (){Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );},
                              child: Text("Логін", style: TextStyle(decoration: TextDecoration.underline,)))
                        ],
                      )
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
