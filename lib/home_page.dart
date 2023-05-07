import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:rentmate_flutter_app/components/group_scroll_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _groups = [];
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
      final response = await http.get(Uri.parse('https://deeonepostgres.herokuapp.com/api/groups?page=0&per=5'));
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

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      _fetchGroups();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Column(
              children: [
                const Text(
                  "Знайди своїх ідеальних співмешканців у RentMate!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                _groups.isNotEmpty
                    ? GroupScroll(groups: _groups)
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
