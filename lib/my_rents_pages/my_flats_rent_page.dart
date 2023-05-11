import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class MyFlatsRentPage extends StatelessWidget {
  final List<Map<String, dynamic>> flats;
  final List<ImageProvider> images;
  final List<ImageProvider> profileImages;
  final List<Map<String, dynamic>> flatsGroupsData;

  const MyFlatsRentPage(
      {Key? key,
      required this.flats,
      required this.images,
      required this.flatsGroupsData,
      required this.profileImages})
      : super(key: key);

  String _getPetText(String pet) {
    return pet == 'YES'
        ? 'Домашні тварини дозволено'
        : pet == 'NO'
            ? 'Без домашніх тварин'
            : pet == 'YESBUTMORE'
                ? 'Домашні тварини дозволено'
                : '';
  }

  String _getGenderText(String gender) {
    return gender == 'MALE'
        ? 'Для хлопців'
        : gender == 'FEMALE'
            ? 'Для дівчат'
            : '';
  }

  Future<void> _redirectToFlatPage(BuildContext context, String uuid) async {
    QuickAlert.show(context: context,
        type: QuickAlertType.loading,
        title: "Завантаження",
        text: "",
        barrierDismissible: true,
        autoCloseDuration: null);
    try{
      http.Response response = await http.get(
          Uri.parse('https://deeonepostgres.herokuapp.com/api/flats/$uuid'));

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        var responseData = jsonDecode(response.body.toString());
        print(responseData);
      }


    }catch(e){Exception (e);}
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Padding(
              padding: const EdgeInsets.only(top:40.0, left: 10, right: 10, bottom: 10),
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: const [
                          Text(
                            "Ваші квартири",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    for (var i = 0; i < flats.length; i++)
                      GestureDetector(
                        onTap: () => _redirectToFlatPage(context, flats[i]['uuid']),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF3F7FF),
                                  border: Border(
                                    top: BorderSide(color: Color(0xFFA1BDFF)),
                                    left: BorderSide(color: Color(0xFFA1BDFF)),
                                    right: BorderSide(color: Color(0xFFA1BDFF)),
                                    bottom: BorderSide(color: Color(0xFFA1BDFF)),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                  child: LayoutBuilder(
                                    builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                      final double availableWidth = constraints.maxWidth;
                                      final int usersLength = flatsGroupsData
                                          .where((flat) => flat['selected_flat'] == flats[i]['uuid'])
                                          .map((flat) => flat['users'].length)
                                          .firstWhere((length) => true, orElse: () => 0);
                                      final double minHeight = usersLength > 0 ? 420.0 : 420.0;
                                      final double additionalHeight = (usersLength - 2) * 40.0;
                                      final double height = minHeight + additionalHeight;

                                      return SizedBox(
                                        height: height,
                                        width: availableWidth,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F7FF),
                                            border: Border.all(
                                                color: const Color(0xFFA1BDFF)),
                                            borderRadius: BorderRadius.circular(
                                                15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                images.isNotEmpty
                                                    ? ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(15),
                                                  child: SizedBox(
                                                    width: 340,
                                                    height: 200,
                                                    child: Image(
                                                        image: images[i],
                                                        fit: BoxFit.fill),
                                                  ),
                                                )
                                                    : const CircularProgressIndicator(
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left: 10.0),
                                                      child: Text(
                                                        utf8.decode(
                                                            flats[i]['address']
                                                                .toString()
                                                                .codeUnits),
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                        '${flats[i]['price']} грн',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 18))
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 10,
                                                      left: 10,
                                                      top: 7),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'м.' + utf8.decode(
                                                            flats[i]['city']
                                                                .toString()
                                                                .codeUnits),
                                                      ),
                                                      Text(
                                                          '${flats[i]['rooms_count']} кімнати.'),
                                                      Text(
                                                          '${flats[i]['floor']}/${flats[i]['floors_count']} пов'),
                                                      Text(
                                                          '${flats[i]['size_in_m2']} кв.м')
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 10.0,
                                                      right: 10.0,
                                                      top: 7),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(_getGenderText(
                                                          '${flats[i]['gender']}')),
                                                      Text(_getPetText(
                                                          '${flats[i]['pets']}'))
                                                    ],
                                                  ),
                                                ),
                                                for(final flat in flatsGroupsData)
                                                  flats[i]['uuid'] ==
                                                      flat['selected_flat']
                                                      ? Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 10, top: 10, left: 10),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Закріплена група за квартирою',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            flatsGroupsData
                                                                .isNotEmpty
                                                                ? Text(
                                                              '${flat['users']
                                                                  .length}/${flat['max_flatmates']}',
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xFF7A8FC3),
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                              ),
                                                            )
                                                                : const CircularProgressIndicator(),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(left: 0.0),
                                                        child: Column(
                                                          children: [
                                                            for (var n = 0; n < (flat.isNotEmpty ? flat['users'].length : 0); n++)
                                                              Row(
                                                                children: [
                                                                  if (profileImages
                                                                      .length > n)
                                                                    SizedBox(
                                                                      height: 40,
                                                                      width: 40,
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            10.0),
                                                                        child: Image(
                                                                          image: profileImages[n],
                                                                          height: 40,
                                                                          width: 40,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  Expanded(
                                                                    child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text((flat['users'][n]['profile']['firstname'] ?? flat['users'][n]['email']) + (flat['users'][n]['profile']['lastname'] ?? ''), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                                                                              n == 0 ? const Text("  Створив групу", style: TextStyle(color: Color(
                                                                                  0xFF7A8FC3),)) : const Text("")
                                                                          ],
                                                                        ),
                                                                        Text(flat['users'][n]['profile']['phone'] ?? "", style: const TextStyle(
                                                                          fontSize: 12
                                                                        ),)
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                      : Padding(
                                                    padding: const EdgeInsets
                                                        .only(top: 10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: const [
                                                        Text(
                                                            "Закріпленої групи немає",
                                                            style:
                                                            TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight
                                                                    .bold)),
                                                      ],
                                                    ),
                                                  ),

                                              ],
                                            ),
                                          ),
                                        ),

                                      );
                                    }
                                  )
                                ),
                            ],
                          ),
                        ),
                      ),
                     SizedBox(
                       height: 5,
                     ),
                     Container(
                         decoration: const BoxDecoration(
                           color: Color(0xFF7A8FC3),
                           border: Border(
                             top: BorderSide(color: Color(0xFFA1BDFF)),
                             left: BorderSide(color: Color(0xFFA1BDFF)),
                             right: BorderSide(color: Color(0xFFA1BDFF)),
                             bottom: BorderSide(color: Color(0xFFA1BDFF)),
                           ),
                           borderRadius:
                           BorderRadius.all(Radius.circular(15)),
                         ),
                         height: 40,
                         width: 180,
                         child: Center(
                             child: Text("Створити квартиру", style: TextStyle(color: Colors.white),)))
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