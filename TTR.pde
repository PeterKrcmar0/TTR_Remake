Player player;
//ArrayList<Note> notes = new ArrayList<Note>();
ArrayList<Note> notes;
float speed = 2;

void setup() {
  size(400, 600, P2D);
  player = new Player();
  notes = new Track("test.track").notes;
}

//TODO: create track and than play it, save in file or whatever
enum MODE {
  edit, 
    play
}

void draw() {
  background(222, 184, 135);
  drawGUI();
  updateTrails();
  player.display();
  updateNotes();
  drawNotes();
}

void drawGUI() {
  noStroke();
  fill(80, 0, 0);
  triangle(0, 0, width/4, 0, 0, 2*height);
  triangle(3*width/4, 0, width, 0, width, 2*height);
  stroke(127, 50);
  line(width/4+50, 0, width/4, height);
  line(width/2, 0, width/2, height);
  line(3*width/4-50, 0, 3*width/4, height);
}

void updateTrails() {
  if (qPressed) leftLength += speed;
  if (wPressed) centerLength += speed;
  if (ePressed) rightLength += speed;
}

boolean keyReleased;

float leftLength;
float centerLength;
float rightLength;
boolean qPressed;
boolean wPressed;
boolean ePressed;
boolean leftPressed;
boolean centerPressed;
boolean rightPressed;

boolean leftSelectable = true;
boolean centerSelectable = true;
boolean rightSelectable = true;

void keyPressed() {
  keyReleased = false;
  switch(keyCode) {
  case 'Q':
    leftLength = 0;
    qPressed = true;
    break;
  case 'W':
    centerLength = 0;
    wPressed = true;
    break;
  case'E':
    rightLength = 0;
    ePressed = true;
    break;

  case LEFT:
    leftPressed = true;
    break;
  case DOWN:
    centerPressed = true;
    break;
  case RIGHT:
    rightPressed = true;
    break;

  case 'F':
    speed += 0.2;
    break;
  case 'D':
    speed -= 0.2;
    break;
  }
}

void mousePressed() {
}

void keyReleased() {
  keyReleased = true;
  switch(keyCode) {
  case 'Q':
    if (qPressed) {
      notes.add(new Note(NOTE_TYPE.left, leftLength));
      qPressed = false;
    }
    break;
  case 'W':
    if (wPressed) {
      notes.add(new Note(NOTE_TYPE.center, centerLength));
      wPressed = false;
    }
    break;
  case'E':
    if (ePressed) {
      notes.add(new Note(NOTE_TYPE.right, rightLength));
      ePressed = false;
    }
    break;

  case LEFT:
    leftPressed = false;
    leftSelectable = true;
    break;
  case DOWN:
    centerPressed = false;
    centerSelectable = true;
    break;
  case RIGHT:
    rightPressed = false;
    rightSelectable = true;
    break;
  }
}

Note firstNoteOfKind(NOTE_TYPE type) {
  for (int i = 0; i < notes.size(); ++i) {
    Note n = notes.get(i);
    if (n.o == type && n.posY < player.posY+30)
      return n;
  }
  return null;
}

ArrayList<Note> firstNotes = new ArrayList<Note>(3);
void updateNotes() {

  // update positions of all nodes
  for (int i = 0; i < notes.size(); ++i) {
    Note n = notes.get(i);
    n.updatePos();
    // remove if outside of screen
    if (n.posY > height) {
      //TODO: generate miss text
      notes.remove(i);
      player.score -= 50;
    }
  }

  // get only first notes
  firstNotes.clear();
  firstNotes.add(firstNoteOfKind(NOTE_TYPE.left));
  firstNotes.add(firstNoteOfKind(NOTE_TYPE.center));
  firstNotes.add(firstNoteOfKind(NOTE_TYPE.right));
  for (int i = 0; i < 3; ++i) {
    Note n = firstNotes.get(i);
    if (n != null && n.isInsideCircle()) {
      if (n.l < 0 || (n.selected && !n.isCorrectPressed())) { // negative trail or wrong key pressed -> remove
        notes.remove(n);
      } else if (n.canBeSelected() && n.isCorrectPressed() && !n.selected) {
        player.score += 100; // new note -> add 100
        n.selected = true;
        updateSelectable(n.o, false);
      } else if (n.isCorrectPressed() && n.selected) {
        player.score += 5; // trailing note -> add 5 each frame
      }
    } /*else {
      if (leftSelectable && leftPressed) {
        player.score -= 50;
        updateSelectable(NOTE_TYPE.left, false);
      } else if (centerSelectable && centerPressed) {
        player.score -= 50;
        updateSelectable(NOTE_TYPE.center, false);
      } else if (rightSelectable && rightPressed) {
        player.score -= 50;
        updateSelectable(NOTE_TYPE.right, false);
      }
    }*/
  }
}

void updateSelectable(NOTE_TYPE type, boolean b) {
  switch(type) {
  case left: 
    leftSelectable = b;
    break;
  case center: 
    centerSelectable = b;
    break;
  case right: 
    rightSelectable = b;
    break;
  }
}

void drawNotes() {
  for (int i = 0; i < notes.size(); ++i)
    notes.get(i).display();
}