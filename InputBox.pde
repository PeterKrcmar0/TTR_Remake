boolean inputing = false;

float createModeButtonX = 50;
float createModeButtonY = 700;
float createModeButtonR = 50;

void createModeButton() {
  if (!animation) {
    float y = trackSelectOffset+(trackSelectHeight+10)*(tracks.size()+1);
    boolean b = mouseInsideRect(width/2, y, trackSelectWidth, trackSelectHeight);
    fill(255, b ? 220 : 180);
    rectMode(CENTER);
    rect(width/2, y, trackSelectWidth, trackSelectHeight);
    fill(0,200,0, b ? 100 : 80);
    ellipse(width/2, y, createModeButtonR, createModeButtonR);
    fill(255);
    textAlign(CENTER);
    textSize(createModeButtonR);
    text("+", width/2,y+createModeButtonR/2-10);
    if (b && mousePressed && mouseButton == LEFT)
      toggleCreateMode();
  }
}

void inputBox() {
  if (inputing) {
    fill(0, 150);
    rect(width/2, height/2, trackSelectWidth, trackSelectHeight);
    fill(255);
    textSize(30);
    textAlign(LEFT);
    text("Name:", width/2-trackSelectWidth/2, height/2);
    textAlign(RIGHT);
    text(trackName, width/2+trackSelectWidth/2, height/2);
  }
}

void keyTyped() {
  if (inputing && trackName.length() < 20) {
    println("_"+key+"_");
    trackName += key;
  }
}

boolean isFocused(float centerX, float centerY, float r) {
  float dX = mouseX-centerX;
  float dY = mouseY-centerY;
  return sqrt((dX*dX)+(dY*dY)) <= r;
}