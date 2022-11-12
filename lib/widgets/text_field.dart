import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget(
      {Key? key,
      required this.hintText,
      required this.textEditingController,
      this.isPass = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              width: 0.00000001, color: Color.fromARGB(255, 255, 255, 255)),
          color: Color.fromARGB(255, 249, 249, 249)),
      child: TextField(
        controller: textEditingController,
        obscureText: isPass ? true : false,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            hintText: hintText,
            fillColor: Color.fromARGB(255, 209, 206, 206)),
      ),
    );
  }
}
