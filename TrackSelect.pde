import java.util.Arrays;

ArrayList<TrackBox> tracks = new ArrayList<TrackBox>();
ArrayList<String> trackToAdd;

final int classicOffset = 200;
int trackSelectHeight = 100;
int trackSelectWidth = 400;
int trackSelectOffset = classicOffset;
int trackSelectSpace = 10;

void drawMenu() {
  for (TrackBox tb : tracks) {
    tb.display();
  }
}

void addTrack(Track t) {
  if (t == null)
    tracks.add(new TrackBox(t, tracks.size()));
  else if (t.totalNotes != 0)
    tracks.add(new TrackBox(t, tracks.size()));
}

void addTrack(String name) {
  addTrack(new Track(name));
}

boolean mouseInsideRectCorner(float x, float y, float w, float h) {
  return mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h;
}

boolean mouseInsideRect(float centerX, float centerY, float w, float h) {
  return mouseX >= centerX-w/2 && mouseX <= centerX+w/2 && mouseY >= centerY-h/2 && mouseY <= centerY+h/2;
}

void mouseWheel(MouseEvent e) {
  /* if you want scrolling
   if (currentMode == MODE.menu)
   trackSelectOffset = limit(trackSelectOffset-e.getCount()*50, -(tracks.size())*(trackSelectHeight+10), classicOffset); 
   */
}

int limit(int val, int min, int max) {
  return max(min(max, val), min);
}