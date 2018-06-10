enum NOTE_TYPE {
  left, 
    center, 
    right
};

class Note {
  NOTE_TYPE o;
  float x;
  float posX;
  float finalX;
  float posY = 0;
  color c;
  float l = 0;
  boolean selected;
  String s;

  Note(NOTE_TYPE o, float l, float start) {
    switch(o) {
    case left:
      posX = leftPos+lineOffset;
      finalX = leftPos;
      c = color(200, 0, 0);
      s = "L";
      break;
    case center:
      posX = centerPos;
      finalX = centerPos;
      c = color(0, 200, 0);
      s = "C";
      break;
    case right:
      posX = rightPos-lineOffset;
      finalX = rightPos;
      c = color(0, 0, 200);
      s = "R";
      break;
    }
    if (l > 40)
      this.l = l;
    this.posY = -start;
    this.o = o;
    this.s = s+" "+l+" "+start;
  }

  Note(NOTE_TYPE o, float l) {
    this(o, l, -l);
  }

  void display() {
    noStroke();
    if (l != 0) {
      fill(selected ? color(c, 150) : color(c, 100));
      triangle(x-noteWidth/2, posY, f(posY-l), posY-l, x+noteWidth/2, posY);
    }
    fill(color(0));
    ellipse(x, posY+3, noteWidth, noteHeight);
    fill(selected ? c : color(c, 200));
    ellipse(x, posY, noteWidth, noteHeight);
  }

  void updatePos() {
    if (selected) {
      l -= speed;
    } else {
      posY += speed;
      x = f(posY);
    }
  }

  float f(float y) {
    return ((finalX-posX)/height)*(y) + posX; // x = a*y + b
  }

  boolean isInsideCircle() {
    return posY >= playerY-30 && posY <= playerY+30;
  }

  boolean isCorrectPressed() {
    return ((leftPressed && o == NOTE_TYPE.left) || (centerPressed && o == NOTE_TYPE.center) || (rightPressed && o == NOTE_TYPE.right));
  }

  boolean canBeSelected() {
    return ((leftSelectable && o == NOTE_TYPE.left) || (centerSelectable && o == NOTE_TYPE.center) || (rightSelectable && o == NOTE_TYPE.right));
  }

  String toString() {
    return s;
  }

  int compareTo(Note b) {
    return Float.compare(b.posY, posY);
  }
}

class NoteComparator implements Comparator<Note> {
  int compare(Note a, Note b) {
    return a.compareTo(b);
  }
}