import 'package:flutter/material.dart';

class DropDownList extends StatefulWidget {
  const DropDownList({Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,}) : super(key: key);

  final controller;
  final bool obscureText;
  final String hintText;

  @override
  _DropDownListState createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
   String? _selectedOption = null; // The selected option

  final List<String?> _options = [
    // Optional value
    'Студент',
    'Працюю',
    'Не працюю',
    'Інше'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: DropdownButtonFormField(
            value: _selectedOption, // selected option, initialized to null
            items: _options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option.toString()),
              );
            }).toList(), // list of options to display in the dropdown
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: widget.hintText,
            ),
            onChanged: (value) {
              // update the selected option when the user chooses a new option
              setState(() {
                _selectedOption = value.toString();

              });
            },
          ),
        ),
      ),
    );

  }
}
