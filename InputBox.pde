boolean inputing = false;

void inputBox() {
  if (inputing && currentMode == MODE.create) {
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
  if (inputing && trackName.length() < 20)
    trackName += key;
}