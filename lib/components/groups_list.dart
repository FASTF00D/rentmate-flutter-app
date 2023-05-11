import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;

class GroupList extends StatelessWidget {
  final List<Map<String, dynamic>> groups_list;

  const GroupList({Key? key, required this.groups_list}) : super(key: key);

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

  Future<void> _redirectToGroupPage(BuildContext context, String uuid) async {
    QuickAlert.show(context: context,
        type: QuickAlertType.loading,
        title: "Завантаження",
        text: "",
        barrierDismissible: true,
        autoCloseDuration: null);
    try{
      http.Response response = await http.get(
          Uri.parse('https://deeonepostgres.herokuapp.com/api/groups/$uuid'));

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        var responseData = jsonDecode(response.body.toString());
        print(responseData);
      }


    }catch(e){Exception (e);}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          for (final group in groups_list)
            GestureDetector(
              onTap: () => _redirectToGroupPage(context, group['uuid']),
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
    );
  }
}
