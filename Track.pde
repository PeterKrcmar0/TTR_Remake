import java.util.Scanner;
import java.io.FileReader;
import java.util.Comparator;

class Track {
  ArrayList<Note> notes;
  int totalNotes;
  float duration;
  String name = "";
  float maxScore;

  Track(String fileName) {
    notes = getInfoFromFile(sketchPath("tracks\\"+fileName));
    totalNotes = notes.size();
    for (Note n : notes) {
      maxScore += player.maxHit + n.l*speed;
    }
    if (totalNotes > 0) {
      Note n = notes.get(notes.size()-1);
      duration += -n.posY+n.l+(playerY)+300;
    }
  }

  Track() {
    notes = new ArrayList<Note>();
  }

  ArrayList<Note> getNotes() {
    return new ArrayList<Note>(notes);
  }

  ArrayList<Note> getInfoFromFile(String fileName) {
    ArrayList<Note> no = new ArrayList<Note>();
    try {
      Scanner s = new Scanner(new FileReader(fileName));
      if (s.hasNext()) this.name = s.nextLine();
      while (s.hasNext()) {
        NOTE_TYPE o;
        switch(s.next()) {
        case "L": 
          o = NOTE_TYPE.left;
          break;
        case "C": 
          o = NOTE_TYPE.center;
          break;
        case "R": 
          o = NOTE_TYPE.right;
          break;
        default:
          println("woopsie");
          throw new Error();
        }
        no.add(new Note(o, s.nextFloat(), s.nextFloat()));
      }
      s.close();
    } 
    catch(Exception e) {
      e.printStackTrace();
      return new ArrayList<Note>();
    }
    no.sort(new NoteComparator());
    return no;
  }
}

// -----------------------
//   WHEN IN CREATE MODE
// -----------------------
boolean creating;
ArrayList<Note> newTrackNotes = new ArrayList<Note>();
String trackName = "";
void createTrack() {
  if (creating) {
    notes.clear();
    newTrackNotes.clear();
    currentTime = 0;
    msgTopCenter = "Creating...";
  } else {
    if (inputing) {
      trackName = "";
    } else {
      writer = createWriter("tracks/"+trackName+".track"); 
      writer.println(trackName);
      for (Note n : newTrackNotes)
        writer.println(n);
      msgTopCenter = "Created track: \""+trackName+"\"";
      trackToAdd.add(trackName+".track");
      writer.flush();
      writer.close();
      writer = null;
    }
  }
}

void addNoteToTrack(NOTE_TYPE type) {
  if (creating) {
    switch(type) {
    case left:
      newTrackNotes.add(new Note(NOTE_TYPE.left, leftLength, currentTime-leftLength));
      break;
    case center:
      newTrackNotes.add(new Note(NOTE_TYPE.center, centerLength, currentTime-centerLength));
      break;
    case right:
      newTrackNotes.add(new Note(NOTE_TYPE.right, rightLength, currentTime-rightLength));
      break;
    }
  }
}