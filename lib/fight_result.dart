class FightResult {
  final String result;

  const FightResult._(this.result);

  static const won = FightResult._("Won");
  static const lost = FightResult._("Lost");
  static const draw = FightResult._("Draw");

  static FightResult? calculateFightResult(final int yourLives, final int enemysLives) {
    if (yourLives == 0 && enemysLives == 0) {
      return FightResult.draw;
    } else if (yourLives == 0) {
      return FightResult.lost;
    } else if (enemysLives == 0) {
      return FightResult.won;
    }

    return null;
  }

  @override
  String toString() {
    return 'FightResult{result: $result}';
  }
}