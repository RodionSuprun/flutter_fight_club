import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/fight_club_icons.dart';
import 'package:flutter_fight_club/fight_club_images.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            textTheme:
                GoogleFonts.pressStart2pTextTheme(Theme.of(context).textTheme)),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
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
                            style: TextStyle(
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
            GoButton(
                text:
                    yourLives == 0 || enemyLives == 0 ? "Start new game" : "Go",
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
      setState(() {
        yourLives = maxLives;
        enemyLives = maxLives;
        resultText = "";
      });
    } else if (attackingBodyPart != null && defendingBodyPart != null) {
      setState(() {
        String enemyResult = "";
        String youResult = "";
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;
        if (enemyLoseLife) {
          enemyLives -= 1;
          youResult = "You hit enemy's ${attackingBodyPart?.name.toLowerCase()}.";
        } else {
          youResult = "Your attack was blocked.";
        }

        if (youLoseLife) {
          yourLives -= 1;
          enemyResult = "Enemy hit your ${whatEnemyAttacks.name.toLowerCase()}.";
        } else {
          enemyResult = "Enemy's attack was blocked.";
        }

        if (yourLives == 0 && enemyLives == 0) {
          resultText = "Draw";
        } else if (yourLives == 0) {
          resultText = "You lost";
        } else if (enemyLives == 0) {
          resultText = "You won";
        } else {
          resultText = youResult + "\n" + enemyResult;
        }

        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        attackingBodyPart = null;
        defendingBodyPart = null;
      });
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

class GoButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const GoButton(
      {Key? key, required this.text, required this.onTap, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: ColoredBox(
            color: color,
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: FightClubColors.whiteText,
                    fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
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
            children: [
              Expanded(
                  child: ColoredBox(
                color: FightClubColors.youBackground,
                child: SizedBox(height: 160),
              )),
              Expanded(
                  child: ColoredBox(
                color: FightClubColors.enemyBackground,
                child: SizedBox(height: 160),
              ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(height: 35),
                  LivesWidget(
                      overallLivesCount: maxLivesCount,
                      currentLivesCount: yourLivesCount),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    "You",
                    style: TextStyle(color: Color(0xff161616)),
                  ),
                  SizedBox(height: 12),
                  Image.asset(FightClubImages.youAvatar, width: 92, height: 92)
                ],
              ),
              ColoredBox(
                color: Colors.green,
                child: SizedBox(height: 44, width: 44),
              ),
              Column(
                children: [
                  SizedBox(height: 16),
                  Text("Enemy",
                      style: TextStyle(color: FightClubColors.darkGreyText)),
                  SizedBox(height: 12),
                  Image.asset(FightClubImages.enemyAvatar,
                      width: 92, height: 92)
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 35),
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
                  style: TextStyle(color: FightClubColors.darkGreyText)),
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
                  style: TextStyle(color: FightClubColors.darkGreyText)),
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
                index > 0 ? EdgeInsets.only(top: 4) : EdgeInsets.only(top: 0),
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
        child: ColoredBox(
          color: selected
              ? FightClubColors.blueButton
              : FightClubColors.greyButton,
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
