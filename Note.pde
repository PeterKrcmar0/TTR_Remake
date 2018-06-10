enum NOTE_TYPE {
  left, 
    center, 
    right
};

class Note {
  NOTE_TYPE o;
  float h;
  float w;
  float x;
  float posX;
  float posY = 0;
  color c;
  float l = 0;
  boolean selected;
  String s;

  Note(NOTE_TYPE o, float l, float start) {
    switch(o) {
    case left:
      posX = width/4+50;
      c = color(200, 0, 0);
      s = "L";
      break;
    case center:
      posX = width/2;
      c = color(0, 200, 0);
      s = "C";
      break;
    case right:
      posX = 3*width/4-50;
      c = color(0, 0, 200);
      s = "R";
      break;
    }
    if(l > 40)
      this.l = l;
    this.posY = -start;
    this.o = o;
    this.w = 40;
    this.h = 30;
    this.s = s+" "+l+" "+start;
  }

  Note(NOTE_TYPE o, float l) {
    this(o, l, -l);
  }

  void display() {
    fill(selected ? c : color(c, 200));
    noStroke();
    ellipse(x, posY, w, h);
    if (l != 0) {
      fill(selected ? color(c, 150) : color(c, 100));
      triangle(x-w/2, posY, f(posY-l), posY-l, x+w/2, posY);
    }
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
    return (posX-width/2)/height*(y) + posX; // x = a*y + b
  }

  boolean isInsideCircle() {
    return posY >= player.posY-30 && posY <= player.posY+30;
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

class NoteComparator implements Comparator<Note>{
  int compare(Note a, Note b){
    return a.compareTo(b);
  }
}