String msgTopRight = "", msgTopLeft = "", msgBottomLeft = "", msgCenter = "", msgTopCenter = "";
int missTimer = 0;

// CONSTANTS
final int noteHeight = 30;
final int noteWidth = 40;

final int playerHeight = 35;
int playerWidth;
int playerY;

final int lineOffset = 150;
int triangleOffset;

int precisionBarHeight = 150;
int precisionBarWidth = 30;

int leftPos;
int centerPos;
int rightPos;

void drawMessages() {
  //TOP CENTER
  textSize(20);
  textAlign(CENTER, TOP);
  fill(255);
  switch(currentMode) {
  case create:
    //msgTopCenter = "";
    break;
  case play:
    msgTopCenter = Integer.toString(player.score);
    break;
  case menu:
    if (!animation) {
      textSize(50);
      msgTopCenter = "SELECT TRACK";
    } else {
      msgTopCenter = "";
    }
    break;
  }
  text(msgTopCenter, width/2, 0);

  fill(255);
  //TOP LEFT
  textSize(20);
  textAlign(LEFT, TOP);
  switch(currentMode) {
  case create:
    msgTopLeft = "CREATE MODE";
    break;
  case play:
    msgTopLeft = "";
    break;
  case menu:
    msgTopLeft = "";
    break;
  }
  text(msgTopLeft, 0, 0);

  //TOP RIGHT
  textSize(20);
  textAlign(RIGHT, TOP);
  switch(currentMode) {
  case create:
    msgTopRight = "Time: "+(int)currentTime;
    break;
  case play:
    msgTopRight = totalPassed == 0 ? 100+" % " : 100*(totalPassed-missed)/totalPassed+" % ";
    break;
  case menu:
    msgTopRight = "";
    break;
  }
  text(msgTopRight, width, 0);

  //BOTTOM LEFT
  fill(255, missTimer-=2*speed);
  textSize(20);
  textAlign(LEFT);
  switch(currentMode) {
  case create:
    msgBottomLeft = "";
    break;
  case play:
    //msgBottomLeft = "";
    break;
  case menu:
    msgBottomLeft = "";
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
  case menu:
    break;
  }
  msgCenter = paused ? "PAUSED" : "";
  text(msgCenter, width/2, height/2);
}

void drawGUI() {
  switch(currentMode) {
  case play:
    background(222, 184, 135);
    drawLines(); //lines
    drawPlayer(); //player
    drawNotes(); //notes 
    gradientRect(width/2, height/4, width, height/2, color(0), color(50, 0)); //shadow
    drawTriangles(); //side triangles
    drawMessages(); //messages
    drawPrecisionBar(); //precision bar
    break;
  case create:
    background(255);    
    drawLines(); //lines   
    drawPlayer(); //player
    drawNotes(); //notes
    gradientRect(width/2, height/4, width, height/2, color(0), color(50, 0)); //shadow
    drawTriangles(); //side triangles
    drawMessages(); //messages
    inputBox(); //input box
    break;
  case menu:
    background(222, 184, 135);
    drawLines(); //lines   
    drawPlayer(); //player
    drawNotes(); //notes
    drawTriangles(); //side triangles
    drawMenu(); //track boxes
    gradientRect(width/2, height/6, width, height/3, color(0), color(50, 0)); //shadow (shorter)
    drawMessages(); //messages
    break;
  }
}

void drawPlayer() {
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

  /* OTHER VERSION
   gradientRect(leftPos, playerY, playerWidth, playerHeight, color(255, 0, 0, leftPressed ? 255 : 100), color(0));
   gradientRect(centerPos, playerY, playerWidth, playerHeight, color(0, 255, 0, centerPressed ? 255 : 100), color(0));
   gradientRect(rightPos, playerY, playerWidth, playerHeight, color(0, 0, 255, rightPressed ? 255 : 100), color(0));
   */
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

void drawPrecisionBar() {
  if (!animation) {
    noStroke();
    fill(255, 150);
    rect(width-precisionBarWidth, height/2, precisionBarWidth, precisionBarHeight, precisionBarWidth/2);
    color c;
    if (abs(player.lastHit) < maxImprecision/3) c = color(0, 255, 0, 150); // set green if was good
    else if (abs(player.lastHit) < 2*maxImprecision/3) c = color(255, 150, 0, 150); // set orange if was ok
    else c = color(255, 0, 0, 150); // set red if was bad
    fill(c);
    float y = map(player.lastHit, 0, maxImprecision, 0, precisionBarHeight/2-precisionBarWidth/2);
    ellipse(width-precisionBarWidth, height/2+y, precisionBarWidth-4, precisionBarWidth-4);
  }
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