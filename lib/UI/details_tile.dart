import 'package:flutter/material.dart';

class DetailsTile extends StatelessWidget {
  final String imgUrl;
  final String text;
  DetailsTile({this.imgUrl, this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          imgUrl,
          height: 70,
        ),
        Text(text,style: TextStyle(color: Colors.grey[900],fontSize: 20),)
      ],
    );
  }
}
