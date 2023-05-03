import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/fight_club_colors.dart';
import '../resources/fight_club_icons.dart';
import '../resources/fight_club_images.dart';
import '../widgets/action_button.dart';

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);

  @override
  State<FightPage> createState() => FightPageState();
}

class FightPageState extends State<FightPage> {
  static const maxLives = 5;
  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  String resultText = "";

  BodyPart whatEnemyDefends = BodyPart.random();
  BodyPart whatEnemyAttacks = BodyPart.random();

  int yourLives = maxLives;
  int enemyLives = maxLives;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
                maxLivesCount: maxLives,
                yourLivesCount: yourLives,
                enemysLivesCount: enemyLives),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: ColoredBox(
                      color: FightClubColors.enemyBackground,
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            resultText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: FightClubColors.darkGreyText,
                                fontSize: 10),
                          ),
                        )),
                      ))),
            ),
            ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart),
            const SizedBox(height: 14),
            ActionButton(
                text: yourLives == 0 || enemyLives == 0 ? "Back" : "Go",
                onTap: onGoButtonClick,
                color: getButtonGoColor()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemyLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemyLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }

  void onGoButtonClick() {
    if (yourLives == 0 || enemyLives == 0) {
      Navigator.of(context).pop();
    } else if (attackingBodyPart != null && defendingBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;
        if (enemyLoseLife) {
          enemyLives -= 1;
        }

        if (youLoseLife) {
          yourLives -= 1;
        }

        final FightResult? fightResult = FightResult.calculateFightResult(yourLives, enemyLives);

        if (fightResult != null) {
          SharedPreferences.getInstance().then((sharedPreferences) {
              sharedPreferences.setString("last_fight_result", fightResult.result);
              if (fightResult == FightResult.won) {
                final int? statsWon = sharedPreferences.getInt("stats_won");
                sharedPreferences.setInt("stats_won", (statsWon ?? 0) + 1);
              } else if (fightResult == FightResult.lost) {
                final int? statsLost = sharedPreferences.getInt("stats_lost");
                sharedPreferences.setInt("stats_lost", (statsLost ?? 0) + 1);
              } else {
                final int? statsDraw = sharedPreferences.getInt("stats_draw");
                sharedPreferences.setInt("stats_draw", (statsDraw ?? 0) + 1);
              }
          });
        }

        resultText = _calculateResultText(youLoseLife, enemyLoseLife);

        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        attackingBodyPart = null;
        defendingBodyPart = null;
      });
    }
  }

  String _calculateResultText( final bool youLoseLife,
      final bool enemyLoseLife) {
    if (yourLives == 0 && enemyLives == 0) {
      return "Draw";
    } else if (yourLives == 0) {
      return "You lost";
    } else if (enemyLives == 0) {
      return "You won";
    } else {
      String youResult = enemyLoseLife
          ? "You hit enemy's ${attackingBodyPart?.name.toLowerCase()}."
          : "Your attack was blocked.";
      String enemyResult = youLoseLife
          ? "Enemy hit your ${whatEnemyAttacks.name.toLowerCase()}."
          : "Enemy's attack was blocked.";
      return youResult + "\n" + enemyResult;
    }
  }

  Color getButtonGoColor() {
    if (yourLives == 0 || enemyLives == 0) {
      return FightClubColors.blackButton;
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      return FightClubColors.greyButton;
    }
    return FightClubColors.blackButton;
  }
}

class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemysLivesCount;

  const FightersInfo(
      {Key? key,
      required this.maxLivesCount,
      required this.yourLivesCount,
      required this.enemysLivesCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Expanded(child: ColoredBox(color: FightClubColors.youBackground)),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      FightClubColors.youBackground,
                      FightClubColors.enemyBackground
                    ]),
                  ),
                ),
              ),
              Expanded(
                  child: ColoredBox(color: FightClubColors.enemyBackground))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const SizedBox(height: 35),
                  LivesWidget(
                      overallLivesCount: maxLivesCount,
                      currentLivesCount: yourLivesCount),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "You",
                    style: TextStyle(color: Color(0xff161616)),
                  ),
                  const SizedBox(height: 12),
                  Image.asset(FightClubImages.youAvatar, width: 92, height: 92)
                ],
              ),
              const SizedBox(
                height: 44,
                width: 44,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FightClubColors.blueButton),
                    child: Center(
                      child: Text(
                        "VS",
                        style: TextStyle(
                            color: FightClubColors.whiteText, fontSize: 16),
                      ),
                    )),
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Text("Enemy",
                      style: TextStyle(color: FightClubColors.darkGreyText)),
                  const SizedBox(height: 12),
                  Image.asset(FightClubImages.enemyAvatar,
                      width: 92, height: 92)
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 35),
                  LivesWidget(
                      overallLivesCount: maxLivesCount,
                      currentLivesCount: enemysLivesCount),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class ControlsWidget extends StatelessWidget {
  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget(
      {Key? key,
      required this.defendingBodyPart,
      required this.selectDefendingBodyPart,
      required this.attackingBodyPart,
      required this.selectAttackingBodyPart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text("Defend".toUpperCase(),
                  style: const TextStyle(color: FightClubColors.darkGreyText)),
              const SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
              )
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Text("Attack".toUpperCase(),
                  style: const TextStyle(color: FightClubColors.darkGreyText)),
              const SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
              )
            ],
          ),
        ),
        const SizedBox(width: 16)
      ],
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget(
      {Key? key,
      required this.overallLivesCount,
      required this.currentLivesCount})
      : assert(overallLivesCount > 0),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(overallLivesCount, (index) {
        Image? image;
        if (index < currentLivesCount) {
          image = Image.asset(FightClubIcons.heartFull, width: 18, height: 18);
        } else {
          image = Image.asset(FightClubIcons.heartEmpty, width: 18, height: 18);
        }

        return Padding(
            padding:
                index > 0 ? const EdgeInsets.only(top: 4) : const EdgeInsets.only(top: 0),
            child: image);
      }),
    );
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> values = [head, torso, legs];

  static BodyPart random() {
    return values[Random().nextInt(values.length)];
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton(
      {Key? key,
      required this.bodyPart,
      required this.selected,
      required this.bodyPartSetter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? FightClubColors.blueButton : Colors.transparent,
            border: !selected
                ? Border.all(color: FightClubColors.darkGreyText, width: 2)
                : null,
          ),
          child: Center(
              child: Text(
            bodyPart.name.toUpperCase(),
            style: TextStyle(
                color: selected
                    ? FightClubColors.whiteText
                    : FightClubColors.darkGreyText),
          )),
        ),
      ),
    );
  }
}
