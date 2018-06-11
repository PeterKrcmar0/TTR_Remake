String msgTopRight = "", msgTopLeft = "", msgBottomLeft = "", msgCenter = "", msgTopCenter = "";
int missTimer = 0;

// CONSTANTS
final int noteHeight = 30;
final int noteWidth = 40;

final int playerHeight = 35;
int playerWidth;
int playerY;

final int lineOffset = 90;
int triangleOffset;

int leftPos;
int centerPos;
int rightPos;

void drawMessages() {
  //TOP CENTER
  textSize(20);
  textAlign(CENTER);
  switch(currentMode) {
  case create:
    fill(0);
    //msgTopCenter = "";
    break;
  case play:
    fill(255);
    msgTopCenter = Integer.toString(player.score);
    break;
  }
  text(msgTopCenter, width/2, 20);

  fill(255);
  //TOP LEFT
  textSize(20);
  textAlign(LEFT);
  switch(currentMode) {
  case create:
    msgTopLeft = "CREATE MODE";
    break;
  case play:
    msgTopLeft = "";
    break;
  }
  text(msgTopLeft, 0, 20);

  //TOP RIGHT
  textSize(20);
  textAlign(RIGHT);
  switch(currentMode) {
  case create:
    msgTopRight = "Time: "+(int)currentTime;
    break;
  case play:
    msgTopRight = totalPassed == 0 ? 100+" % " : 100*(totalPassed-missed)/totalPassed+" % ";
    break;
  }
  text(msgTopRight, width, 20);

  //BOTTOM LEFT
  fill(255, missTimer-=2*speed);
  textSize(20);
  textAlign(LEFT);
  switch(currentMode) {
  case create:
    //msgBottomLeft = "";
    break;
  case play:
    //msgBottomLeft = "";
    break;
  }
  text(msgBottomLeft, 0, playerY);

  //CENTER
  textSize(50);
  textAlign(CENTER);
  switch(currentMode) {
  case create:
    fill(0);
    break;
  case play:
    fill(255);
    break;
  }
  msgCenter = paused ? "PAUSED" : "";
  text(msgCenter, width/2, height/2);
}

void drawGUI() {
  switch(currentMode) {
  case play:
    background(222, 184, 135);

    //shadow
    gradientRect(width/2, height/4, width, height/2, color(0), color(50, 0));
    //lines
    drawLines();
    //player
    rectMode(CENTER);
    noStroke();
    fill(0, 200);
    rect(width/2, playerY+5, width, playerHeight);
    fill(190, 0, 0);
    rect(leftPos, leftPressed ? playerY : playerY-3, playerWidth, playerHeight);
    fill(0, 190, 0);
    rect(centerPos, centerPressed ? playerY : playerY-3, playerWidth, playerHeight);
    fill(0, 0, 190);
    rect(rightPos, rightPressed ? playerY : playerY-3, playerWidth, playerHeight);
    //gradientRect(width/2, playerY+3, width, playerHeight, color(255, 0), color(0));
    //side triangles
    drawTriangles();
    break;
  case create:
    background(255);
    //lines
    drawLines();
    //player
    gradientRect(leftPos, playerY, playerWidth, playerHeight, color(255, 0, 0, leftPressed ? 255 : 100), color(0));
    gradientRect(centerPos, playerY, playerWidth, playerHeight, color(0, 255, 0, centerPressed ? 255 : 100), color(0));
    gradientRect(rightPos, playerY, playerWidth, playerHeight, color(0, 0, 255, rightPressed ? 255 : 100), color(0));
    //side triangles
    noStroke();
    fill(0);
    triangle(0, 0, leftPos, 0, 0, 2*height);
    triangle(rightPos, 0, width, 0, width, 2*height);
    break;
  }
}

void drawLines() {
  stroke(127, 70);
  strokeWeight(5);
  line(leftPos+lineOffset, 0, leftPos, height);
  line(centerPos, 0, centerPos, height);
  line(rightPos-lineOffset, 0, rightPos, height);
}

void drawTriangles() {
  noStroke();
  fill(0);
  //left triangle
  beginShape();
  vertex(0, 0);
  vertex(leftPos-playerWidth/2+triangleOffset, 0);
  vertex(leftPos-playerWidth/2, height);
  vertex(0, height);
  endShape();
  //right triangle
  beginShape();
  vertex(rightPos+playerWidth/2-triangleOffset, 0);
  vertex(width, 0);
  vertex(width, height);
  vertex(rightPos+playerWidth/2, height);
  endShape();
}

void drawIntro() {
  if (animation) {
    noStroke();
    fill(0, 255-animationTime);
    rect(width/2, height/2, width, height);
    textSize(50);
    textAlign(CENTER);
    fill(255);
    text("TAP\nTAP\nREVENGE", width/2, max(height/2-100, height-animationTime*2));
    blinkMessage(200, 100, "PRESS SPACE", "", width/2, height-100);
  }
}

void blinkMessage(float start, float freq, String msg1, String msg2, float posX, float posY) {
  map(freq, 0, freq, 0, 100);
  if (animationTime > start && animationTime%freq > freq/2)
    text(msg1, posX, posY);
  else
    text(msg2, posX, posY);
}

void gradientRect(int x, int y, int w, int h, color c1, color c2) {
  beginShape();
  noStroke();
  fill(c1);
  vertex(x-w/2, y-h/2);
  vertex(x+w/2, y-h/2);
  fill(c2);
  vertex(x+w/2, y+h/2);
  vertex(x-w/2, y+h/2);
  endShape();
}