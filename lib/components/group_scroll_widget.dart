import 'dart:convert';
import 'package:flutter/material.dart';

class GroupScroll extends StatelessWidget {
  final List<Map<String, dynamic>> groups;

  const GroupScroll({Key? key, required this.groups}) : super(key: key);

  String _getActivityText(String activity) {
    return activity == 'STUDENT'
        ? 'Студенти'
        : activity == 'EMPLOYED'
        ? 'Працюючі'
        : activity == 'UNEMPLOYED'
        ? 'Не працюючі'
        : activity == 'OTHER'
        ? 'Інше'
        : '';
  }

  String _getPetText(String pet) {
    return pet == 'YES'
        ? 'Є тварини'
        : pet == 'NO'
        ? 'Нема тварин'
        : pet == 'YESBUTMORE'
        ? 'Є декілька тварин'
        : '';
  }
  String _getGenderText(String gender) {
    return gender == 'MALE'
        ? 'Хлопці'
        : gender == 'FEMALE'
        ? 'Дівчата'
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final group in groups)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 110,
                    width: 340,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F7FF),
                        border: Border(
                          top: BorderSide(color: Color(0xFFA1BDFF)),
                          left: BorderSide(color: Color(0xFFA1BDFF)),
                          right: BorderSide(color: Color(0xFFA1BDFF)),
                          bottom: BorderSide(color: Color(0xFFA1BDFF)),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${group['min_price']} - ${group['max_price']} грн',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Expanded(child: SizedBox(height: 5)),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/rooms.png',
                                      fit: BoxFit.fitWidth,
                                    ),
                                    const SizedBox(width: 5),
                                    Text('${group['rooms_count']} кім.'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/size.png',
                                      fit: BoxFit.fitWidth,
                                    ),
                                    const SizedBox(width: 5),
                                    Text('${group['min_area']}-${group['max_area']} кв.м'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/location.png',
                                      fit: BoxFit.fitWidth,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(utf8.decode(group['city'].toString().codeUnits)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    Text('${group['max_flatmates']} жильця'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Color(0xFF536AA1)),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_getActivityText(group['activity'])),
                                Text(_getPetText(group['pets'])),
                                Text(_getGenderText(group['gender'])),
                                Text('${group['min_age']} - ${group['max_age']} р.',)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
