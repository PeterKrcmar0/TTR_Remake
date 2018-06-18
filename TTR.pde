Player player;
//ArrayList<Note> notes = new ArrayList<Note>();
final Track emptyTrack = new Track();
Track currentTrack;
ArrayList<Note> notes;
float speed = 2;
MODE currentMode = MODE.menu;
boolean paused = false;
PrintWriter writer;

int maxImprecision = 30;
int missed = 0;
int totalPassed = 0;

float currentTime = 0;
boolean animation = true;
float animationTime = 0;

void setup() {
  size(600, 800, P2D);
  textMode(SHAPE);
  player = new Player();
  leftPos = width/4;
  centerPos = width/2;
  rightPos = (3*width)/4;
  playerY = height-50;
  playerWidth = centerPos-leftPos;
  triangleOffset = (int)map(lineOffset, 0, width, 0, height);
  notes = new Track("intro.track").notes;
  trackToAdd = new ArrayList<String>(Arrays.asList(new File(sketchPath("tracks")).list()));
}

enum MODE {
  create, 
    play, 
    menu
}

void draw() {
  if (!paused) {
    updateTrails();
    updateNotes();
    currentTime += speed;
    if (animation)
      animationTime += speed;
  }
  drawGUI();
  drawIntro(); //if animation
  if (currentTrack != null && currentTime > currentTrack.duration && currentMode == MODE.play)
    goToMenu();
}

void updateTrails() {
  if (qPressed) leftLength += speed;
  if (wPressed) centerLength += speed;
  if (ePressed) rightLength += speed;
}

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
  if (inputing) {
    typingKey();
    return;
  }

  if (keyCode == 'P') {
    if (!animation)
      paused = !paused;
  }

  if (!paused) {
    switch(keyCode) {

    case SHIFT:
      if (!animation && !inputing)
        toggleCreateMode();
      break;
    case ' ':
      switch(currentMode) {
      case create:
        if (!inputing) {
          if (creating)
            inputing = true;
          creating = !creating;
          createTrack();
        }
        break;
      case menu:
        if (animation)
          goToMenu();
        break;
      case play:
        break;
      }
      break;

    case RETURN :
    case ENTER :
      if (currentMode == MODE.menu)
        for (TrackBox t : tracks)
          t.keyPressed();
      break;

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
      if (currentMode == MODE.menu)
        findSelectedTrackBoxAndUpdate(true);
      else
        centerPressed = true;
      break;
    case RIGHT:
      rightPressed = true;
      break;
    case UP:
      if (currentMode == MODE.menu)
        findSelectedTrackBoxAndUpdate(false);
      break;

    case 'F':
      speed += 0.2;
      break;
    case 'D':
      speed -= 0.2;
      break;
    }
  }
}

void keyReleased() {
  switch(keyCode) {
  case 'Q':
    if (qPressed && !inputing && currentMode != MODE.menu) {
      notes.add(new Note(NOTE_TYPE.left, leftLength));
      addNoteToTrack(NOTE_TYPE.left);
      qPressed = false;
    }
    break;
  case 'W':
    if (wPressed && !inputing && currentMode != MODE.menu) {
      notes.add(new Note(NOTE_TYPE.center, centerLength));
      addNoteToTrack(NOTE_TYPE.center);
      wPressed = false;
    }
    break;
  case'E':
    if (ePressed && !inputing && currentMode != MODE.menu) {
      notes.add(new Note(NOTE_TYPE.right, rightLength));
      addNoteToTrack(NOTE_TYPE.right);
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

void mousePressed() {
  for (TrackBox t : tracks)
    t.mousePressed();
}

void goToMenu() {
  reset();
  tracks.clear();
  for (String s : trackToAdd) //add all tracks to menu
    addTrack(s);
  tracks.add(new TrackBox(tracks.size())); //adding ´create new track´ box
  trackSelectOffset = classicOffset; // reset scroll offset
  animation = false;
  currentMode = MODE.menu;
}

void reset() {
  if (notes!=null) notes.clear();
  missed = totalPassed = 0;
  if (player != null) player.lastHit = player.score = 0;
  currentTime = animationTime = 0;
}

Note firstNoteOfKind(NOTE_TYPE type) {
  for (int i = 0; i < notes.size(); ++i) {
    Note n = notes.get(i);
    if (n.o == type && n.posY < playerY+maxImprecision)
      if (!n.selected || n.selected && n.l > 0)
        return n;
  }
  return null;
}

ArrayList<Note> firstNotes = new ArrayList<Note>(3);
void updateNotes() {
  //  println(totalPassed + " "+ missed);
  if (!paused) {
    //during intro loop on intro nodes
    if (animation && notes.isEmpty()) {
      currentTime = 0;
      notes = new Track("intro.track").notes;
    }
    // update positions of all nodes
    for (int i = 0; i < notes.size(); ++i) {
      Note n = notes.get(i);
      n.updatePos();
      // signal a MISS
      if (!n.missed && n.posY > playerY+maxImprecision) {
        n.missed = true;
        msgBottomLeft = "MISS";
        missTimer = 255;
        missed += 1;
        totalPassed += 1;
        player.updateScore(-50);
      }
      // remove if outside of screen
      if (n.posY-n.l > height) {
        notes.remove(i);
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
        if (n.isFaded() || (n.selected && !n.isCorrectPressed() && n.l > 0)) { // done fading or key released -> remove
          notes.remove(n);
        } else if (n.canBeSelected() && n.isCorrectPressed() && !n.selected) {
          player.updateLastHit(n.distToCenter()); // new note -> add score according to precision
          n.selected = true;
          totalPassed += 1;
          updateSelectable(n.o, false);
        } else if (n.isCorrectPressed() && n.selected && alpha(n.c) == 255) {
          player.updateScore((int)speed); // trailing note -> add ´speed´ each frame
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

void toggleCreateMode() {
  switch(currentMode) {
  case menu:
    msgTopCenter = "";
    currentMode = MODE.create;
    break;
  case play:
    break;
  case create:
    goToMenu();
    break;
  }
}