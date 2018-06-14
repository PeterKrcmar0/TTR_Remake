void drawIntro() {
  if (animation) {
    noStroke();
    fill(0, 255-animationTime);
    rect(width/2, height/2, width, height);
    textSize(50);
    textAlign(CENTER);
    fill(255);
    text("TAP\nTAP\nREMAKE", width/2, max(height/2-100, height-animationTime*2));
    blinkMessage(200, 100, "PRESS SPACE", "", width/2, height-100);
  }
}

void blinkMessage(float start, float freq, String msg1, String msg2, float posX, float posY) {
  if (animationTime > start && currentTime%freq > freq/2)
    text(msg1, posX, posY);
  else
    text(msg2, posX, posY);
}

void blinkMessage(float freq, String msg1, String msg2, float posX, float posY) {
  blinkMessage(-1, freq, msg1, msg2, posX, posY);
}