import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmate_flutter_app/User.dart';
import 'package:rentmate_flutter_app/home_page.dart';
import 'package:rentmate_flutter_app/login_page.dart';
import 'package:rentmate_flutter_app/quiz/QuizScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class QuizOrHomePage {
    Future<void> checkQuizPage(BuildContext context) async {
      final String? token = await SharedPreferences.getInstance().then((prefs) => prefs.getString('token'));
      if (token == null) {
        // User not logged in, show login page
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        // User is logged in, fetch details
        final response = await http.get(
          Uri.parse('https://deeonepostgres.herokuapp.com/api/auth/me'),
          headers: {'Authorization': 'Bearer $token'},
        );
        if (response.statusCode == 200) {
          // Successfully fetched user details
          final data = json.decode(response.body);
          if (data['profile']['city_name'] == null || data['profile']['activity'] == null || data['profile']['age'] == null) {
            // Required data missing, show quiz page if necessary
            final prefs = await SharedPreferences.getInstance();
            final needQuiz = prefs.getBool('needQuiz') ?? false;
            if (needQuiz) {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  QuizScreen()));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            }
          } else {
            // All required data is present, show home page
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          }
        } else {
          // Failed to fetch user details, show login page
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      }
    }
  }





