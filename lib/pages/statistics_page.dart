import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StatisticsPage();
  }
}

class _StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FightClubColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 24),
                child: const Text(
                  "Statistics",
                  style: TextStyle(
                      color: FightClubColors.darkGreyText,
                      fontSize: 24,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const Expanded(child: SizedBox()),
              FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const SizedBox();
                  }
                  return Column(
                    children: [
                      Text(
                        "Won: ${snapshot.data!.getInt("stats_won") ?? 0}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: FightClubColors.darkGreyText),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Draw: ${snapshot.data!.getInt("stats_draw") ?? 0}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: FightClubColors.darkGreyText),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Lost: ${snapshot.data!.getInt("stats_lost") ?? 0}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: FightClubColors.darkGreyText),
                      )
                    ],
                  );
                },
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SecondaryActionButton(
                    text: "Back",
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
              ),
            ],
          ),
        ));
  }
}
