import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';

class FightResultWidget extends StatelessWidget {
  final FightResult fightResult;

  const FightResultWidget({Key? key, required this.fightResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: ColoredBox(color: FightClubColors.youBackground),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      FightClubColors.youBackground,
                      FightClubColors.enemyBackground
                    ]),
                  ),
                ),
              ),
              const Expanded(
                child: ColoredBox(color: FightClubColors.enemyBackground),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    "You",
                    style: TextStyle(
                        color: FightClubColors.darkGreyText,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    FightClubImages.youAvatar,
                    height: 92,
                    width: 92,
                  ),
                ],
              ),
              Container(
                height: 44,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: _getResultColor(),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  fightResult.result.toLowerCase(),
                  style: const TextStyle(
                      color: FightClubColors.whiteText,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    "Enemy",
                    style: TextStyle(
                        color: FightClubColors.darkGreyText,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    FightClubImages.enemyAvatar,
                    height: 92,
                    width: 92,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Color _getResultColor() {
    if (fightResult == FightResult.won) {
      return FightClubColors.winResult;
    } else if (fightResult == FightResult.lost) {
      return FightClubColors.lostResult;
    }
    return FightClubColors.drawResult;
  }
}
