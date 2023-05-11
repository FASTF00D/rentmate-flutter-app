import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentmate_flutter_app/entry_pages/entry_point.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  List<Map<String, dynamic>> _groups = [];

  List<Map<String, dynamic>> _flats = [];

  List<ImageProvider> _images = [];

  Future<void> _fetchGroups() async {
    try {
      final response = await http.get(Uri.parse(
          'https://deeonepostgres.herokuapp.com/api/groups?page=0&per=5'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _groups = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Failed to fetch groups');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchFlats() async {
    try {
      final response = await http.get(Uri.parse(
          'https://deeonepostgres.herokuapp.com/api/flats?page=0&per=5'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _flats = List<Map<String, dynamic>>.from(data);
        });
        await _fetchImages();
      } else {
        print('Failed to fetch flats');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchImages() async {
    List<ImageProvider> images = [];
    for (final flat in _flats) {
      String photoUrl = flat['photos'][0];
      print('photo url:   ' + photoUrl);
      http.Response response = await http.get(Uri.parse(photoUrl));
      print('reponsebody:    ' +response.body);
      if (response.statusCode == 200) {
        // Remove the prefix from the base64-encoded data
        String base64Image = response.body.replaceFirst('data:image/png;base64,', '');
        images.add(Image.memory(base64Decode(base64Image)).image);
      }
    }
    setState(() {
      _images = images;
    });
  }

  void initState() {
    super.initState();
    _fetchGroups();
    _fetchFlats();
    _fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RentMate',
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasData) {
            String? token = snapshot.data?.getString('token');
            if (token != null) {
              return EntryPoint(groups: _groups, flats: _flats, images: _images,);
            } else {
              return const LoginPage();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
