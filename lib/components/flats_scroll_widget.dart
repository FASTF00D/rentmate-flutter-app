import 'dart:convert';

import 'package:flutter/material.dart';

class FlatScroll extends StatelessWidget {
  final List<Map<String, dynamic>> flats;
  final List<ImageProvider> images;

  const FlatScroll({Key? key, required this.flats, required this.images})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < flats.length; i++)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: SizedBox(
                height: 300,
                width: 340,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F7FF),
                    border: Border.all(color: const Color(0xFFA1BDFF)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        images.isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                              child: SizedBox(
                                width: 340,
                                height: 200,
                                child: Image(
                                    image: images[i],
                                    fit: BoxFit.fill
                                    ),
                              ),
                            )
                              : const CircularProgressIndicator(color:Colors.black,),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                '${flats[i]['address']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10),
                              child: Text('м.'+
                                utf8.decode(flats[i]['city'].toString().codeUnits),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),

                            )
                          ],
                        ),


                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _FlatDetail(
                                icon: const AssetImage('assets/images/rooms.png'),
                                label: '${flats[i]['rooms_count']} кім.',
                              ),
                              _FlatDetail(
                                icon: const AssetImage('assets/images/size.png'),
                                label: '${flats[i]['size_in_m2']} кв.м',
                              ),
                              _FlatDetail(
                                icon:
                                    const AssetImage('assets/images/floors.png'),
                                label:
                                    '${flats[i]['floor']}/${flats[i]['floors_count']}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FlatDetail extends StatelessWidget {
  final ImageProvider icon;
  final String label;

  const _FlatDetail({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: icon,
          fit: BoxFit.fitWidth,
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 20),),
      ],
    );
  }
}
