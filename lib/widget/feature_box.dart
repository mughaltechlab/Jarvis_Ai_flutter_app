import 'package:flutter/material.dart';
import 'package:jarvis/pallete.dart';

class FeatureBox extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  const FeatureBox({
    super.key,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // title
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                color: Pallete.mainFontColor,
                fontSize: 18,
                fontFamily: 'Cera Pro',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // description
          Text(
            description,
            style: const TextStyle(
              color: Pallete.mainFontColor,
              // fontSize: 20,
              fontFamily: 'Cera Pro',
            ),
          ),
        ],
      ),
    );
  }
}
