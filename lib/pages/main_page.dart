import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/pages/statistics_page.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:flutter_fight_club/widgets/fight_result_widget.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/fight_club_colors.dart';
import 'fight_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MainPageContent();
  }
}

class _MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FightClubColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              const Center(
                child: Text(
                  "THE\nFIGHT\nCLUB",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: FightClubColors.darkGreyText, fontSize: 30),
                ),
              ),
              const Expanded(child: SizedBox()),
              FutureBuilder<String?>(
                future:
                    SharedPreferences.getInstance().then((sharedPreferences) {
                  return sharedPreferences.getString("last_fight_result");
                }),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const SizedBox();
                  } else {
                    FightResult? result;
                    if (snapshot.data == FightResult.won.result) {
                      result = FightResult.won;
                    } else if (snapshot.data == FightResult.lost.result) {
                      result = FightResult.lost;
                    } else {
                      result = FightResult.draw;
                    }
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text("Last fight result", style: TextStyle(color: FightClubColors.darkGreyText, fontWeight: FontWeight.w400, fontSize: 14),),
                        ),
                        FightResultWidget(fightResult: result),
                      ],
                    );
                  }
                },
              ),
              const Expanded(child: SizedBox()),
              SecondaryActionButton(text: "Statistics", onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const StatisticsPage())
                );
              }),
              const SizedBox(height: 12),
              ActionButton(
                  text: "Start".toUpperCase(),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FightPage(),
                    ));
                  },
                  color: FightClubColors.blackButton),
              const SizedBox(
                height: 16,
              )
            ],
          ),
        ));
  }
}
