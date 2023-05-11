import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:rentmate_flutter_app/components/flats_scroll_widget.dart';

import 'package:rentmate_flutter_app/components/group_scroll_widget.dart';
import 'package:rentmate_flutter_app/components/groups_list.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<Map<String, dynamic>> _groups = [];
  List<Map<String, dynamic>> _groupsList = [];

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

  Future<void> _fetchGroupsList() async {
    try {
      final response = await http.get(Uri.parse(
          'https://deeonepostgres.herokuapp.com/api/groups?page=0&per=50'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _groupsList = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Failed to fetch groups');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchGroups();
      _fetchGroupsList();
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

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text("Всі групи",style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    _groupsList.isNotEmpty
                        ? GroupList(groups_list: _groupsList)
                        : const CircularProgressIndicator(color: Colors.black,),
                    Padding(padding: EdgeInsets.only(bottom: 45))
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
