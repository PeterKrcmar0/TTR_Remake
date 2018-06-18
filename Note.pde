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
  boolean missed;
  float start;

  Note(NOTE_TYPE o, float l, float start) {
    switch(o) {
    case left:
      posX = leftPos+lineOffset;
      finalX = leftPos;
      c = color(255, 100, 100);
      s = "L";
      break;
    case center:
      posX = centerPos;
      finalX = centerPos;
      c = color(100, 255, 100);
      s = "C";
      break;
    case right:
      posX = rightPos-lineOffset;
      finalX = rightPos;
      c = color(100, 100, 255);
      s = "R";
      break;
    }
    if (l > 40)
      this.l = l;
    this.posY = -start;
    this.start = start;
    this.o = o;
    this.s = s+" "+l+" "+start;
  }

  Note(NOTE_TYPE o, float l) {
    this(o, l, currentTime-l);
  }

  void display() {
    noStroke();
    if (l > 0) {
      fill(selected ? color(c, 150) : color(c, 100));
      triangle(x-noteWidth/2, posY, f(posY-l), posY-l, x+noteWidth/2, posY);
    }
    fill(0, 0, 0, alpha(c));
    ellipse(x, posY+3, noteWidth, noteHeight);
    fill(selected || isInsideCircle() ? c : color(c, 200));
    ellipse(x, posY, noteWidth, noteHeight);
  }

  void updatePos() {
    if (selected) {
      l -= speed;
      if (l < 0)
        c = color(red(c), green(c), blue(c), alpha(c)-8*speed);
    } else {
      posY = currentTime-start;
      x = f(posY);
    }
  }
  
  boolean isFaded(){
    return alpha(this.c) == 0.0;
  }

  int distToCenter() {
    return (int)posY-playerY;
  }

  float f(float y) {
    return ((finalX-posX)/height)*(y) + posX; // x = a*y + b
  }

  boolean isInsideCircle() {
    return posY >= playerY-maxImprecision && posY <= playerY+maxImprecision;
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