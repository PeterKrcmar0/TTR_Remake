class Player {
  int score = 0;

  Player() {
  }

  void updateScore(int amount) {
    if(!animation)
    score += amount;
  }

  void display() {
    /*noStroke();
     fill(222,184,135);
     rectMode(CENTER);
     rect(centerPos, posY, width-100, 65);*/

    /*strokeWeight(5);
     //fill(255, 0, 0);
     //stroke(100, 0, 0);
     gradientRect(leftPos, posY, playerWidth, playerHeight, color(255, 0, 0), color(200, 50, 0));
     //ellipse(leftPos, posY, playerWidth, playerHeight);
     
     fill(0, 255, 0);
     stroke(0, 100, 0);
     ellipse(centerPos, posY, playerWidth, playerHeight);
     
     fill(0, 0, 255);
     stroke(0, 0, 100);
     ellipse(rightPos, posY, playerWidth, playerHeight);*/
  }
}