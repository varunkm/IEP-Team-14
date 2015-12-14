import processing.serial.*;

public class Launchpad {
  int baudrate;
  String portname;
  Serial port;
  PApplet parent;
  int commID;
  final int lf = 10;
  float cur_temp;
  float cur_ph;
  float cur_rpm;

  float target_temp;
  float target_ph;
  float target_rpm;

  public Launchpad(PApplet parent, int baudrate, String portname) {
    this.parent=parent;
    this.baudrate = baudrate;
    this.portname = portname;
    this.port = new Serial(parent, portname, baudrate);
  }

  private void writeData(float temp, float ph, float rpm) {
    String comm = ""+commID+", 0";
    comm += ", "+temp+", "+ph+", "+rpm;
    port.write(comm);
    commID++;
  }

  private void readData() {
    if (port.available()>0) {
      String data = port.readStringUntil(lf);
      if (data != null) {
        String[] pieces = split(data, ", ");
        cur_temp = float(pieces[2]);
        cur_ph   = float(pieces[3]);
        cur_rpm  = float(pieces[4]);
        
      }
    }
  }

  public void update() {
    writeData(target_temp, target_ph, target_rpm);
    readData();
  }
}
