class Player {
  int score = 0;
  int maxHit = 100;
  int lastHit;

  Player() {
    lastHit = 0;
  }

  void updateScore(int amount) {
    if (!animation)
      score += amount;
  }
  
  void updateLastHit(int distance) {
    int newScore = maxHit-abs((int)map(distance, 0, maxImprecision, 0, player.maxHit));
    updateScore(newScore);
    lastHit = distance;
  }
}