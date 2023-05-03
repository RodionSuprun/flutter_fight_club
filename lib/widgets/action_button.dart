import 'package:flutter/material.dart';

import '../resources/fight_club_colors.dart';


class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const ActionButton(
      {Key? key, required this.text, required this.onTap, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: color,
          height: 40,
          alignment: Alignment.center,
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: FightClubColors.whiteText,
                fontSize: 16),
          )),
    );
  }
}