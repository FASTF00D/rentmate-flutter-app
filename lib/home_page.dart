import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:rentmate_flutter_app/components/flats_scroll_widget.dart';

import 'package:rentmate_flutter_app/components/group_scroll_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _groups = [];
  List<Map<String, dynamic>> _flats = [];
  List<ImageProvider> _images = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

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
      http.Response response = await http.get(Uri.parse(photoUrl));
      if (response.statusCode == 200) {
        images.add(Image
            .memory(base64Decode(response.body))
            .image);
      }
    }
    setState(() {
      _images = images;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchGroups();
      _fetchFlats();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.95,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.95,
              child: Column(
                children: [
                  const SizedBox(height: 65),
                  const Text(
                    "Знайди своїх ідеальних співмешканців у RentMate!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    "Разом з RentMate ви легко зможете створити або найти групу людей відповідно вашим потребам, або ж навпаки, виставити свою квартиру на оренду і знайти для неї хороших орендарів!",
                    style: TextStyle(fontWeight: FontWeight.w400),),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Text("Топ пропозиції", style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),),
                      SizedBox(width: 5,),
                      Text("Груп", style: TextStyle(fontSize: 24, color: Color(
                          0xFF536AA1), fontWeight: FontWeight.bold),)
                    ],
                  ),
                  _groups.isNotEmpty
                      ? GroupScroll(groups: _groups)
                      : const CircularProgressIndicator(color: Colors.black,),

                  const SizedBox(height: 40),

                  Row(
                    children: const [
                      Text("Топ пропозиції", style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),),
                      SizedBox(width: 5,),
                      Text("Квартир", style: TextStyle(fontSize: 24, color: Color(
                          0xFF536AA1), fontWeight: FontWeight.bold),)
                    ],
                  ),
                      _flats.isNotEmpty
                      ? FlatScroll(flats: _flats, images: _images)
                      : const CircularProgressIndicator(color: Colors.black,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
