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
    int newScore;
    if(abs(distance) < maxImprecision/3) newScore = maxHit; // if green get 100% of points
    else if(abs(distance) < 2*maxImprecision/3) newScore = 8*maxHit/10; // if orange get 80%
    else newScore = 6*maxHit/10; // if red get 60%
    updateScore(newScore);
    lastHit = distance;
  }
}