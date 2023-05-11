import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:rentmate_flutter_app/components/flats_list.dart';
import 'package:rentmate_flutter_app/components/flats_scroll_widget.dart';

import 'package:rentmate_flutter_app/components/group_scroll_widget.dart';
import 'package:rentmate_flutter_app/components/groups_list.dart';

class FlatsPage extends StatefulWidget {
  const FlatsPage({Key? key}) : super(key: key);

  @override
  _FlatsPageState createState() => _FlatsPageState();
}

class _FlatsPageState extends State<FlatsPage> {
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



  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchFlats();
      _fetchImages();
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
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      children: const [
                        Text("Всі пропозиції", style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text("Квартир", style: TextStyle(fontSize: 24, color: Color(
                            0xFF536AA1), fontWeight: FontWeight.bold),)
                      ],
                    ),
                    _flats.isNotEmpty
                        ? FlatList(flats: _flats, images: _images)
                        : const CircularProgressIndicator(color: Colors.black,),
                    const Padding(padding: EdgeInsets.only(bottom: 45))
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
