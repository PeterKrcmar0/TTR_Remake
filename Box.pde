class TrackBox {
  boolean selected;
  int w;
  int h;
  int x;
  int y;
  Track t;
  color lightGreen = color(0, 230, 0, 0);

  TrackBox(Track t, int i) {
    this.t = t;
    this.h = trackSelectHeight;
    this.w = trackSelectWidth;
    this.x = width/2;
    this.y = (trackSelectHeight+trackSelectSpace)*(i+1);
    if (i == 0)
      selected = true; //TODO: remove if want only mouse control
  }

  TrackBox(int i) {
    this(null, i);
  }

  void display() {
    int y = this.y+trackSelectOffset;
    noStroke();
    fill(255, isSelected() ? 255 : 150);
    rectMode(CENTER);
    rect(x, y, w, h);
    lightGreen = color(0, green(lightGreen), 0, min(alpha(lightGreen)+(isSelected() ? 4*speed : -255), 150));
    w = limit((int)(w+(isSelected() ? speed : -2*speed)), trackSelectWidth, trackSelectWidth+10);
    fill(lightGreen);
    if (t == null) {
      float r = map(w, trackSelectWidth, trackSelectWidth+10, createModeButtonR/2, createModeButtonR);
      ellipse(width/2, y, r, r);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(createModeButtonR);
      text("+", width/2, y-textDescent());
    } else {
      int slide = (int)map(w, trackSelectWidth, trackSelectWidth+10, x+w/2-100, x+w/2-50);
      triangle(30+slide, y, slide, y+20, slide, y-20);
      textSize(20);
      textAlign(LEFT);
      fill(0);
      text(t.name, x-trackSelectWidth/2+10, y-trackSelectHeight/2+20);
      text("TOTAL NOTES: "+t.totalNotes, x-trackSelectWidth/2+10, y-trackSelectHeight/2+50);
      text("DURATION: "+t.duration, x-trackSelectWidth/2+10, y-trackSelectHeight/2+70);
      text("MAX SCORE: "+t.maxScore, x-trackSelectWidth/2+10, y-trackSelectHeight/2+90);
    }
  }

  boolean isSelected() {
    /*boolean b = true;
     for (TrackBox tb : tracks)
     if (tb != this)
     if (tb.hovered()) b = false;*/
    boolean b = mouseInsideRect(x, (tracks.get(tracks.size()-1).y+tracks.get(0).y)/2+trackSelectOffset, trackSelectWidth, tracks.get(tracks.size()-1).y);
    return hovered() || (selected && !b);
  }

  boolean hovered() {
    return mouseInsideRect(x, y+trackSelectOffset, w, h);
  }

  void keyPressed() {
    switch(keyCode) {
    case ENTER:
    case RETURN:
      if (selected) {
        if (t != null) {
          reset();
          currentTrack = t;
          notes = t.getNotes();
          currentMode = MODE.play;
        } else {
          toggleCreateMode();
        }
      }
      break;
    }
  }

  void mousePressed() {
    if (hovered() && mouseButton == LEFT) {
      if (t != null) {
        reset();
        currentTrack = t;
        notes = t.getNotes();
        currentMode = MODE.play;
      } else {
        toggleCreateMode();
      }
    }
  }
}

void findSelectedTrackBoxAndUpdate(boolean down) {
  for (int i = 0; i < tracks.size(); ++i) {
    TrackBox curr = tracks.get(i);
    if (curr.selected) {
      curr.selected = false;
      int newI = limit(i+(down?1:-1), 0, tracks.size()-1);
      TrackBox t = tracks.get(newI);
      t.selected = true;
      if(t != curr /*&& (t.y+trackSelectOffset > playerY || t.y+trackSelectOffset < 50)*/) trackSelectOffset -= (down ? 1 : -1)*(trackSelectHeight+trackSelectSpace);
      break;
    }
  }
}

boolean inputing = false;

float createModeButtonR = 50;

/*void createModeButton() {
 if (!animation) {
 //float y = trackSelectOffset+(trackSelectHeight+trackSelectSpace)*(tracks.size()+1);
 //boolean b = mouseInsideRect(width/2, y, trackSelectWidth, trackSelectHeight);
 //fill(255, b ? 220 : 180);
 //rectMode(CENTER);
 //rect(width/2, y, trackSelectWidth, trackSelectHeight);
 lightGreen = color(0, green(lightGreen), 0, min(alpha(lightGreen)+(b ? 2*speed : -4*speed), 150));
 fill(lightGreen);
 ellipse(width/2, y, createModeButtonR, createModeButtonR);
 fill(255);
 textAlign(CENTER, CENTER);
 textSize(createModeButtonR);
 text("+", width/2, y-textDescent());
 if (b && mousePressed && mouseButton == LEFT)
 toggleCreateMode();
 }
 }*/

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