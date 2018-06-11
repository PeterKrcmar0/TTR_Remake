class Player {
  int score = 0;

  Player() {
  }

  void updateScore(int amount) {
    if (!animation)
      score += amount;
  }
}