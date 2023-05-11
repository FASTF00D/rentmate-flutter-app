import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rentmate_flutter_app/my_rents_pages/my_flats_rent_page.dart';
import 'package:http/http.dart' as http;
import 'package:rentmate_flutter_app/my_rents_pages/my_groups_rent_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyRentsPage extends StatefulWidget {
  const MyRentsPage({Key? key}) : super(key: key);

  @override
  State<MyRentsPage> createState() => _MyRentsPageState();
}

class _MyRentsPageState extends State<MyRentsPage> {
  int _currentIndex = 0;
  final _pageController = PageController(initialPage: 0);


  List<Map<String, dynamic>> _groups = [];
  List<Map<String, dynamic>> _flats = [];
  List<Map<String, dynamic>> _flatsGroups = [];
  List<Map<String, dynamic>> _flatsGroupsData = [];
  List<ImageProvider> _images = [];
  List<ImageProvider> _profileImages = [];

  List<Map<String, dynamic>> _myGroups = [];
  List<Map<String, dynamic>> _mySelectedFlats = [];
  List<Map<String, dynamic>> _groupsSelectedFlatData = [];
  List<ImageProvider> _selectedFlatImages = [];
  List<ImageProvider> _groupProfileImages = [];

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


  Future<void> fetchDataForGroups() async {
    try {
      // get my groups
      final myGroupsResponse = await http.get(Uri.parse(
          'https://deeonepostgres.herokuapp.com/api/groups?page=0&per=50'));
      if (myGroupsResponse.statusCode == 200) {
        final List<dynamic> groupsData = jsonDecode(myGroupsResponse.body);
        final String? admin_uuid =
        await SharedPreferences.getInstance().then((prefs) => prefs.getString('uuid'));
        final myGroups = List<Map<String, dynamic>>.from(
            groupsData.where((group) => group['admin_id'] == admin_uuid));
        print(myGroups);

        // get flats, which are connected to my selected groups
        final selectedFlatsResponse = await http.get(Uri.parse(
            'https://deeonepostgres.herokuapp.com/api/flats?page=0&per=50'));
        if (selectedFlatsResponse.statusCode == 200) {
          final List<dynamic> selectedFlatsData = jsonDecode(selectedFlatsResponse.body);
          final selectedFlats = List<Map<String, dynamic>>.from(selectedFlatsData.where((flat) {
            return myGroups.any((group) {
              var selectedFlat = group['selected_flat'];
              return selectedFlat != null && selectedFlat.contains(flat['uuid']);
            });
          }));

          //get selected flat photos
          List<ImageProvider> selectedFlatImages = [];
          for (final flat in selectedFlats) {
            String photoUrl = flat['photos'][0];
            http.Response response = await http.get(Uri.parse(photoUrl));
            if (response.statusCode == 200) {
              selectedFlatImages.add(Image.memory(base64Decode(response.body)).image);
            }
          }



          List<Map<String, dynamic>> groupsSelectedFlatsData = [];
          for (final flat in selectedFlats) {
            String flat_uuid = flat['uuid'];
            final response = await http.get(Uri.parse(
                'https://deeonepostgres.herokuapp.com/api/flats/$flat_uuid'));
            if (response.statusCode == 200) {
              final Map<String, dynamic> data = jsonDecode(response.body);
              groupsSelectedFlatsData.add(data);
            } else {
              print('Failed to fetch group with $flat_uuid');
            }
          }

          List<ImageProvider> groupProfileImages = [];
          for (final group in myGroups) {
            final List<dynamic> users = group['users'];
            for (final user in users) {
              if (user['profile']['profile_photo'] != null) {
                String photoUrl = user['profile']['profile_photo'];


                // Use a regular expression to check if the photoUrl is in a URL format
                RegExp regExp = new RegExp(
                  r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$",
                  caseSensitive: false,
                  multiLine: false,
                );

                if (regExp.hasMatch(photoUrl)) {
                  http.Response response = await http.get(Uri.parse(photoUrl));
                  if (response.statusCode == 200) {
                    groupProfileImages.add(Image.memory(base64Decode(response.body)).image);
                  }
                } else {
                  // Add the icon to the profileImages list
                }
              }
              else {
                groupProfileImages.add(Image.asset("assets/images/profile.png").image);
              }
            }


            setState(() {
              _myGroups = myGroups;
              _mySelectedFlats = selectedFlats;
              _groupsSelectedFlatData = groupsSelectedFlatsData;
              _selectedFlatImages = selectedFlatImages;
              _groupProfileImages = groupProfileImages;
            });
          }
        } else {
          print('Failed to fetch groups');
      }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchDataForFlats() async {
    try {
      final flatsResponse = await http.get(Uri.parse(
          'https://deeonepostgres.herokuapp.com/api/flats?page=0&per=50'));
      if (flatsResponse.statusCode == 200) {
        final List<dynamic> flatsData = jsonDecode(flatsResponse.body);
        final String? admin_uuid =
        await SharedPreferences.getInstance().then((prefs) => prefs.getString('uuid'));

        final flats = List<Map<String, dynamic>>.from(
            flatsData.where((flat) => flat['admin_id'] == admin_uuid));

        List<ImageProvider> images = [];
        for (final flat in flats) {
          String photoUrl = flat['photos'][0];
          http.Response response = await http.get(Uri.parse(photoUrl));
          if (response.statusCode == 200) {
            images.add(Image.memory(base64Decode(response.body)).image);
          }
        }

        final groupsResponse = await http.get(Uri.parse(
            'https://deeonepostgres.herokuapp.com/api/groups?page=0&per=5'));
        if (groupsResponse.statusCode == 200) {
          final List<dynamic> groupsData = jsonDecode(groupsResponse.body);

          final List flatUUIDs = flats.map((flat) => flat['uuid']).toList();
          final groups = List<Map<String, dynamic>>.from(groupsData);
          final flatsGroups = List<Map<String, dynamic>>.from(groups.where(
                  (group) => flatUUIDs.contains(group['selected_flat'])));

          List<Map<String, dynamic>> flatsGroupsData = [];
          for (final group in flatsGroups) {
            String group_uuid = group['uuid'];
            final response = await http.get(Uri.parse(
                'https://deeonepostgres.herokuapp.com/api/groups/$group_uuid'));
            if (response.statusCode == 200) {
              final Map<String, dynamic> data = jsonDecode(response.body);
              flatsGroupsData.add(data);
            } else {
              print('Failed to fetch group with $group_uuid');
            }
          }

          List<ImageProvider> profileImages = [];
          for (final group in flatsGroupsData) {
            final List<dynamic> users = group['users'];
            for (final user in users) {
              if (user['profile']['profile_photo'] != null) {
                String photoUrl = user['profile']['profile_photo'];


                // Use a regular expression to check if the photoUrl is in a URL format
                RegExp regExp = new RegExp(
                  r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$",
                  caseSensitive: false,
                  multiLine: false,
                );

                if (regExp.hasMatch(photoUrl)) {
                  http.Response response = await http.get(Uri.parse(photoUrl));
                  if (response.statusCode == 200) {
                    String base64Image = response.body.replaceFirst('data:image/png;base64,', '');
                    profileImages.add(Image.memory(base64Decode(base64Image)).image);
                  }
                } else{
                  // Add the icon to the profileImages list
                }
              }
              else {
              profileImages.add(Image.asset("assets/images/profile.png").image);
              }
            }
          }


          setState(() {
            _flats = flats;
            _images = images;
            _groups = groups;
            _flatsGroups = flatsGroups;
            _flatsGroupsData = flatsGroupsData;
            _profileImages = profileImages;
          });
        } else {
          print('Failed to fetch groups');
        }
      } else {
        print('Failed to fetch flats');
      }
    } catch (e) {
      print('Error: $e');
    }
  }






  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchDataForFlats();
      fetchDataForGroups();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  List<String> pageVariables = ["групи", "квартири"];

  void _switchToGroupsPage() {
    _pageController.jumpToPage(1);
    setState(() {
      _currentIndex = 1;
    });
  }

  void _switchToFlatsPage() {
    _pageController.jumpToPage(0);
    setState(() {
      _currentIndex = 0;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            MyFlatsRentPage(
              flats: _flats,
              images: _images,
              flatsGroupsData: _flatsGroupsData,
              profileImages: _profileImages,
            ),
            MyGroupsRentPage(
              groups: _myGroups,
              flatImages: _selectedFlatImages,
              profileImages: _groupProfileImages,
              groupSelectedFlatData: _groupsSelectedFlatData,
              selectedFlat: _groupsSelectedFlatData,
            ),
          ],
        ),
          Container(
            alignment: Alignment(0, -0.9),


            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: const Color(0xFF4A5367),
                border: Border.all(
                    color: const Color(0xFFA1BDFF)),
                borderRadius: BorderRadius.circular(
                    20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (_currentIndex == 1)
                      Container(
                        width: 70,
                        child: GestureDetector(
                            onTap: () {
                              _pageController.previousPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                            child: Text("Квартири", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),)),
                      ),
                    if(_currentIndex == 0)
                      Container(
                        height: 10,
                        width: 70,
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 2,
                        effect:  SlideEffect(
                            spacing:  8.0,
                            radius:  4.0,
                            dotWidth:  16.0,
                            dotHeight:  16.0,
                            paintStyle:  PaintingStyle.stroke,
                            strokeWidth:  1.5,
                            dotColor:  Colors.white,
                            activeDotColor:  Color(0xFF8C9ED7)
                        ),
                      ),
                    ),

                    if (_currentIndex == 0)
                      Container(
                        width: 70,
                        child: GestureDetector(
                          onTap: () {
                            _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Text("Групи", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}
