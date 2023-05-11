import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class MyGroupsRentPage extends StatelessWidget {
  final List<Map<String, dynamic>> groups;
  final List<Map<String, dynamic>> selectedFlat;
  final List<ImageProvider> flatImages;
  final List<ImageProvider> profileImages;
  final List<Map<String, dynamic>> groupSelectedFlatData;

  const MyGroupsRentPage(
      {Key? key,
        required this.groups,
        required this.flatImages,
        required this.profileImages,
        required this.groupSelectedFlatData,
        required this.selectedFlat})
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

  String _getHeatingText(String heating) {
    return heating == 'INDIVIDUAL'
        ? 'Індивідуальне опалення'
        : heating == 'CENTRAL'
            ? 'Центральне опалення'
            : heating == 'AUTONOMOUS'
              ? 'Автономне опалення'
                : '';
  }

  String _getGenderText(String gender) {
    return gender == 'MALE'
        ? 'Для хлопців'
        : gender == 'FEMALE'
        ? 'Для дівчат'
        : '';
  }

  String _getActivityText(String activity) {
    return activity == 'STUDENT'
        ? 'Для студентів'
        : activity == 'EMPLOYED'
        ? 'Для працюючих'
        : activity == 'UNEMPLOYED'
        ? 'Для не працюючих'
        : activity == 'OTHER'
        ? '' : '';
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
                            "Ваші групи",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    for (var i = 0; i < groups.length; i++)
                      GestureDetector(
                        onTap: () => _redirectToGroupPage(context, groups[i]['uuid']),
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
                                       final int usersLength = groups.isNotEmpty ? groups[i]['users'].length : 0;
                                       final double minHeight = usersLength > 0 ? 380.0 : 400.0;
                                       final double additionalHeight = (usersLength - 2) * 110.0;
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
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('${groups[i]['min_price']}-${groups[i]['max_price']} грн',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight
                                                            .w900,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('м.' +  utf8.decode(groups[i]['city'].toString().codeUnits),
                                                      style: const TextStyle(
                                                        fontSize: 16
                                                      ),),
                                                    Text('${groups[i]['rooms_count']} кімнат'),
                                                    Text('${groups[i]['min_area']}-${groups[i]['max_area']}кв.м'),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(_getHeatingText('${groups[i]['type_of_heating']}')),
                                                    Text(_getGenderText('${groups[i]['gender']}')),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(_getActivityText('${groups[i]['activity']}')),
                                                    Text('${groups[i]['min_age']}-${groups[i]['max_age']}р.'),
                                                    Text('${groups[i]['min_flatmates']}-${groups[i]['max_flatmates']} мешканці'),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(_getPetText('${groups[i]['pets']}')),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                //group block column

                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("Учасники групи", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                                                        Text('${groups[i]['users'].length}/${groups[i]['max_flatmates']}',style: const TextStyle(
                                                          fontSize: 22, color: Color(0xFF7A8FC3), fontWeight: FontWeight.bold,
                                                        ),)
                                                      ],
                                                    ),
                                                      for (var n = 0; n < (groups.isNotEmpty ? groups[i]['users'].length : 0); n++)
                                                        Row(children: [
                                                            if (profileImages.length > n)
                                                              SizedBox(
                                                                height: 40,
                                                                width: 40,
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      10.0),
                                                                  child:
                                                                  Image(
                                                                    image: profileImages[n],
                                                                    height: 40,
                                                                    width: 40,
                                                                  ),
                                                                ),
                                                              ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 5),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text((utf8.decode(groups[i]['users'][n]['profile']['firstname'].toString().codeUnits)) + " " + utf8.decode(groups[i]['users'][n]['profile']['lastname'].toString().codeUnits), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                                                                        n == 0 ? const Text("  Створив групу", style: TextStyle(color: Color(
                                                                            0xFF7A8FC3),)) : const Text("")
                                                                      ],
                                                                    ),
                                                                    Text(groups[i]['users'][n]['profile']['phone'] ?? "", style: const TextStyle(
                                                                        fontSize: 12
                                                                    ),)
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                    for(var f = 0; f < flatImages.length; f++)
                                                    for(final flat in selectedFlat)
                                                      groups[i]['selected_flat'] ==
                                                          flat['uuid'] ?
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 8),
                                                        child: Column(
                                                          children: [
                                                            Row(children: const [
                                                              Padding(
                                                                padding: EdgeInsets.only(bottom: 8),
                                                                child: Text("Прикріплена квартира за групою", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                                              )
                                                            ],),
                                                              flatImages.isNotEmpty
                                                              ? Container(
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
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(5.0),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius: BorderRadius.circular(15),
                                                                          child: SizedBox(
                                                                            width: 180,
                                                                            height: 130,
                                                                          child: Image(
                                                                            image: flatImages[f],
                                                                            fit: BoxFit.fill),
                                                                      ),
                                                                      ),
                                                                      Expanded(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 4, left: 8),
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text('${groupSelectedFlatData[f]['address']}',style: TextStyle(fontSize: 14),),
                                                                              Text('м.' + utf8.decode(groupSelectedFlatData[f]['city'].toString().codeUnits), style: TextStyle(fontWeight: FontWeight.bold),),
                                                                              SizedBox(height: 7),
                                                                              Row(children: [
                                                                                Image.asset('assets/images/rooms.png'),
                                                                                const SizedBox(width: 4),
                                                                                Text('${groupSelectedFlatData[f]['rooms_count']} кім.',style: TextStyle(fontWeight: FontWeight.bold))
                                                                              ],),
                                                                              SizedBox(height: 7),
                                                                              Row(children: [
                                                                                Image.asset('assets/images/size.png'),
                                                                                const SizedBox(width: 4),
                                                                                Text('${groupSelectedFlatData[f]['size_in_m2']} кв.м',style: TextStyle(fontWeight: FontWeight.bold))
                                                                              ],),
                                                                              SizedBox(height: 7),
                                                                              Row(children: [
                                                                                Image.asset('assets/images/floors.png'),
                                                                                const SizedBox(width: 4),
                                                                                Text('${groupSelectedFlatData[f]['floor']}/${groupSelectedFlatData[f]['floors_count']} пов.', style: TextStyle(fontWeight: FontWeight.bold),)
                                                                              ],),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                                  : const CircularProgressIndicator(
                                                              color: Colors.black,)
                                                          ],
                                                        ),
                                                      )
                                                          :
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(top: 10),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: const [
                                                            Text(
                                                                "Закріпленої квартири немає",
                                                                style:
                                                                TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight
                                                                        .bold)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                )
                                                      ],
                                                    ),
                                            )
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
                             child: Text("Створити групу", style: TextStyle(color: Colors.white),)))
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