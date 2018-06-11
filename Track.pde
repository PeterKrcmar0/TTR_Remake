import java.util.Scanner;
import java.io.FileReader;
import java.util.Comparator;

class Track {
  ArrayList<Note> notes;
  int totalNotes;
  float duration;

  Track(String fileName) {
    notes = getNotesFromFile(sketchPath("tracks/"+fileName+".track"));
    totalNotes = notes.size();
    if (totalNotes > 0){
      Note n = notes.get(notes.size()-1);
      duration = -n.posY+n.l+(playerY);
    }
  }

  Track() {
    notes = new ArrayList<Note>();
  }

  ArrayList<Note> getNotes() {
    return new ArrayList<Note>(notes);
  }

  ArrayList<Note> getNotesFromFile(String fileName) {
    ArrayList<Note> no = new ArrayList<Note>();
    try {
      Scanner s = new Scanner(new FileReader(fileName));
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
    }
    no.sort(new NoteComparator());
    return no;
  }
}

// -----------------------
//   WHEN IN CREATE MODE
// -----------------------

String trackName = "";
void createTrack() {
  if (writer == null) {
    trackName = "output"+(int)random(10); // TODO: should be able to select custom track name
    writer = createWriter("tracks/"+trackName+".track"); 
    notes.clear();
    currentTime = 0;
    msgTopCenter = "Creating...";
  } else {
    msgTopCenter = "Created track: \""+trackName+"\"";
    writer.flush();
    writer.close();
    writer = null;
  }
}

void addNoteToTrack(NOTE_TYPE type) {
  if (writer != null) {
    switch(type) {
    case left:
      writer.println(new Note(NOTE_TYPE.left, leftLength, currentTime-leftLength));
      break;
    case center:
      writer.println(new Note(NOTE_TYPE.center, centerLength, currentTime-centerLength));
      break;
    case right:
      writer.println(new Note(NOTE_TYPE.right, rightLength, currentTime-rightLength));
      break;
    }
  }
}