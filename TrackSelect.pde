import java.util.Arrays;

ArrayList<Track> tracks = new ArrayList<Track>();
ArrayList<String> trackToAdd;

int trackSelectHeight = 100;
int trackSelectWidth = 400;
int trackSelectOffset = 50;

boolean inTrackSelect = false;

void drawTrackSelect() {
  if (inTrackSelect) {
    for (int i = 0; i < tracks.size(); ++i) {
      Track t = tracks.get(i);
      noStroke();
      //rectMode(CENTER);
      float y = trackSelectOffset+(trackSelectHeight+10)*(i+1);
      boolean b = mouseInsideRect(width/2, y, trackSelectWidth, trackSelectHeight);
      fill(255, b ? 220 : 180);
      rect(width/2, y, trackSelectWidth, trackSelectHeight);
      textSize(20);
      textAlign(LEFT);
      fill(0);
      text(t.name, width/2-trackSelectWidth/2+10, y-trackSelectHeight/2+20);
      text("Total notes: "+t.totalNotes, width/2-trackSelectWidth/2+10, y-trackSelectHeight/2+50);
      text("Duration: "+t.duration, width/2-trackSelectWidth/2+10, y-trackSelectHeight/2+70);
      text("Max score: "+t.maxScore, width/2-trackSelectWidth/2+10, y-trackSelectHeight/2+90);
      if (b && mousePressed && mouseButton == LEFT) {
        reset();
        currentTrack = t;
        notes = t.getNotes();
        inTrackSelect = false;
      }
    }
  }
}

void addTrack(Track t) {
  if (t.totalNotes != 0)
    tracks.add(t);
}

void addTrack(String name) {
  addTrack(new Track(name));
}

boolean mouseInsideRect(float centerX, float centerY, float w, float h) {
  return mouseX >= centerX-w/2 && mouseX <= centerX+w/2 && mouseY >= centerY-h/2 && mouseY <= centerY+h/2;
}

void mouseWheel(MouseEvent e) {
  if (inTrackSelect)
    trackSelectOffset -= e.getCount()*50;
}