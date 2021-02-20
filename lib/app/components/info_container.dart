import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String info;

  InfoCard(this.info);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical:8.0),
      child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(child: Text(info))),
    );
  }
}
