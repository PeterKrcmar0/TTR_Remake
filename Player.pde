class Player {
  float posY = height-50;
  int score = 0;
  
  Player() {
  }

  void display() {
    displayScore();
    
    /*noStroke();
    fill(222,184,135);
    rectMode(CENTER);
    rect(width/2, posY, width-100, 65);*/
    
    strokeWeight(5);
    fill(255, 0, 0);
    stroke(100,0,0);
    ellipse(width/4+5, posY, 45, 35);
    
    fill(0, 255, 0);
    stroke(0,100,0);
    ellipse(width/2, posY, 45, 35);
    
    fill(0, 0, 255);
    stroke(0,0,100);
    ellipse(3*width/4-5, posY, 45, 35);
  }
  
  void displayScore() {
    fill(0);
    textAlign(CENTER);
    textSize(20);
    text(score, width/2, 20);
  }
}