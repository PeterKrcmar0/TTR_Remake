import java.util.Scanner;
import java.io.FileReader;
import java.util.Comparator;

class Track {
  ArrayList<Note> notes;

  Track(String fileName) {
    notes = getNotesFromFile(sketchPath("tracks/"+fileName));
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
        no.add(new Note(o, s.nextInt(), s.nextInt()));
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