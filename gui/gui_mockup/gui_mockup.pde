/**
*****************************************************************************
*  GUI for Bioreactor control system.                                       *
*****************************************************************************
*  Made to work with MSP430 Launchpad.                                      *
*  Allows user to see data from control system and adjust system parameters *
*    in graphical user interface.                                           *
*****************************************************************************
*  VARUN MATHUR 2015                                                        *
*****************************************************************************
*/  


import controlP5.*;
import processing.serial.*;
ControlP5 cp5;

final int GRAPH_HEIGHT= 200;
final int GRAPH_WIDTH= 500;
final int TOP_MARGIN= 100;
final int G_LEFT_MARGIN= 350;
final int G_SPACING = TOP_MARGIN+GRAPH_HEIGHT;
final int SPACE_BETWEEN = 50;
final int TEXT_SPACING =10;
final int MAX_TEMP= 50;
final int MAX_PH= 17;
final int MAX_RPM= 2000;
Table log;
Chart tempChart;
Chart phChart;
Chart RPMChart;

Textfield temp_input;
Textfield ph_input;
Textfield rpm_input;

Launchpad lp;
PFont f;
int count;

void setup() {
  fullScreen();
  smooth();
  background(color(100,100,100));
  count = 0;

  f = createFont("Helvetica", 16, true);
  ControlFont font = new ControlFont(f,32);
  log = new Table();
  log.addColumn("time");
  log.addColumn("id");
  log.addColumn("target_temp");
  log.addColumn("target_ph");
  log.addColumn("target_rpm");
  log.addColumn("actual_temp");
  log.addColumn("actual_ph");
  log.addColumn("actual_rpm");
  
  String[] fontList = PFont.list();
  printArray(fontList);
  lp = new Launchpad(this,9600,Serial.list()[1]);
  lp.target_temp = 37.0;
  lp.target_ph = 7.0;
  lp.target_rpm = 120.0;
  
  cp5 = new ControlP5(this);
  
  cp5.addTab("Temperature")
     .setColorBackground(color(0, 160, 100))
     .setColorLabel(color(255))
     .setColorActive(color(255,128,0))
     ;
  cp5.addTab("Ph")
     .setColorBackground(color(0, 100, 160))
     .setColorLabel(color(255))
     .setColorActive(color(255,128,0))
     ;
  cp5.addTab("Stirring")
     .setColorBackground(color(160, 0, 100))
     .setColorLabel(color(255))
     .setColorActive(color(255,128,0))
     ;
  
  cp5.getTab("default")
     .activateEvent(true)
     .setLabel("Console")
     .setId(1)
     ;

  cp5.getTab("Temperature")
     .activateEvent(true)
     .setId(2)
     ;
  cp5.getTab("Ph")
     .activateEvent(true)
     .setId(3)
     ;

  cp5.getTab("Stirring")
     .activateEvent(true)
     .setId(4)
     ;
  
  ControlFont infont = new ControlFont(f,80); 
  temp_input = cp5.addTextfield("temp_input")
    .setPosition(1000, 100)
      .setText("37.0")
        .setSize(250, GRAPH_HEIGHT)
          .setFont(infont)
            .setFocus(true)
              .setColor(color(255, 125, 125))
                ;
 
  ph_input = cp5.addTextfield("ph_input")
    .setPosition(1000, TOP_MARGIN+GRAPH_HEIGHT+SPACE_BETWEEN)
      .setText("7.0")
        .setSize(250, GRAPH_HEIGHT)
          .setFont(infont)
            .setFocus(false)
              .setColor(color(255, 125, 125))
                ;
 
 rpm_input = cp5.addTextfield("rpm_input")
    .setPosition(1000, TOP_MARGIN+(GRAPH_HEIGHT*2)+SPACE_BETWEEN*2)
      .setText("120.0")
        .setSize(250, GRAPH_HEIGHT)
          .setFont(infont)
            .setFocus(false)
              .setColor(color(255, 125, 125))
                ;
 
  
                  
  tempChart = cp5.addChart("Temperature")
               .setPosition(G_LEFT_MARGIN, TOP_MARGIN)
               .setSize(GRAPH_WIDTH,GRAPH_HEIGHT)
               .setRange(0,MAX_TEMP)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               ;

  tempChart.getColor().setBackground(color(#60CEB7));
  tempChart.addDataSet("temp");
  tempChart.addDataSet("target");
  tempChart.setColors("temp", color(#FFF079),color(255,0,0));
  tempChart.setColors("target", color(255,0,0),color(255,0,0));
  tempChart.setData("temp", new float[30]);
  
  phChart = cp5.addChart("pH")
               .setPosition(G_LEFT_MARGIN, TOP_MARGIN+GRAPH_HEIGHT+SPACE_BETWEEN)
               .setSize(GRAPH_WIDTH,GRAPH_HEIGHT)
               .setRange(0,MAX_PH)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               ;

  phChart.getColor().setBackground(color(#60CEB7));


  phChart.addDataSet("ph");
  phChart.addDataSet("MA");
  phChart.addDataSet("target");
  phChart.setColors("ph", color(#FFF079),color(255,0,0));
  phChart.setColors("target", color(255,0,0),color(255,0,0));

  phChart.setData("ph", new float[30]);
  phChart.setData("MA", new float[30]);
  
  RPMChart = cp5.addChart("RPM")
      .setPosition(G_LEFT_MARGIN, TOP_MARGIN+(GRAPH_HEIGHT*2)+SPACE_BETWEEN*2)
               .setSize(GRAPH_WIDTH,GRAPH_HEIGHT)
               .setRange(0,MAX_RPM)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               ;

  RPMChart.getColor().setBackground(color(#60CEB7));


  RPMChart.addDataSet("RPM");
  RPMChart.addDataSet("target");
  RPMChart.setColors("RPM", color(#FFF079),color(255,0,0));
  RPMChart.setColors("target", color(255,0,0),color(255,0,0));
  RPMChart.setData("RPM", new float[30]);


}


void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
    Textfield t = (Textfield)theEvent.getController();
    String n = t.getName();
    if(n.equals("temp_input")){
      println("temp");
      String snew_temp = t.getText();
      float fnew_temp = float(snew_temp);
      println(fnew_temp);
      if (!Float.isNaN(fnew_temp))
        lp.target_temp = fnew_temp;
    }
    
    if(n.equals("ph_input")){
      println("ph");
      String snew_ph = t.getText();
      float fnew_ph = float(snew_ph);
      println(fnew_ph);
      if (!Float.isNaN(fnew_ph))
        lp.target_ph = fnew_ph;
    }
    
    if(n.equals("rpm_input")){
      println("rpm");
      String snew_rpm = t.getText();
      float fnew_rpm = float(snew_rpm);
      println(fnew_rpm);
      if (!Float.isNaN(fnew_rpm))
        lp.target_rpm = fnew_rpm;
    }
    
   
  
    println("controlEvent: accessing a string from controller '"
      +t.getName()+"': "+t.getText()
      );

    // Textfield.isAutoClear() must be true
    print("controlEvent: trying to setText, ");

    t.setText("controlEvent: changing text.");
    if (t.isAutoClear()==false) {
      println(" success!");
    } 
    else {
      println(" but Textfield.isAutoClear() is false, could not setText here.");
    }
  }
}


void draw() {
  background(color(100,100,100));
  int x = 340;
  int y = 180;
  // unshift: add data from left to right (first in)
  // push: add data from right to left (last in)
  textFont(f,32);
  text("TEMPERATURE", G_LEFT_MARGIN-TEXT_SPACING, TOP_MARGIN+32); 
  text("PH LEVEL", G_LEFT_MARGIN-TEXT_SPACING, TOP_MARGIN+32+GRAPH_HEIGHT+SPACE_BETWEEN);
  text("RPM", G_LEFT_MARGIN-TEXT_SPACING, TOP_MARGIN+32+(SPACE_BETWEEN+GRAPH_HEIGHT)*2);
  
  textFont(f,80);
  textAlign(RIGHT);

  float temp = ((float)Math.random()*2.0+35.0);
  text(temp, x,250);
  tempChart.push("temp", temp);
  tempChart.push("target", lp.target_temp);
  
  float pH = ((float)Math.random()*5.0+7.0);
  if(count > 30){
    float[] last30 = phChart.getDataSet("ph").getValues();
    int sum = 0;
    for(int i = 0; i < 10; i++){
      sum += last30[i];
    }
    phChart.push("MA",sum/10.0);
  }
  text(pH, x,500);
  phChart.push("ph",pH);
  phChart.push("target",lp.target_ph);
  
  float RPM = ((float)Math.random()*10+120);
  text(RPM, x, 750);
  RPMChart.push("RPM",RPM);
  RPMChart.push("target", lp.target_rpm);
  count++;
  lp.update();
  TableRow row = log.addRow();
  row.setInt("time",millis());
  row.setInt("id",count);
  row.setFloat("target_temp", lp.target_temp);
  row.setFloat("target_ph", lp.target_ph);
  row.setFloat("target_rpm", lp.target_rpm);
  row.setFloat("actual_temp", lp.cur_temp);
  row.setFloat("actual_ph", lp.cur_temp);
  row.setFloat("actual_rpm", lp.cur_temp);
  
  if(!temp_input.isFocus())
    temp_input.setText(lp.target_temp+"");
  if(!ph_input.isFocus())
    ph_input.setText(lp.target_ph+"");
  if(!rpm_input.isFocus())
    rpm_input.setText(lp.target_rpm+"");
  
  delay(125);
}

void stop(){
    String name = year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second();
    saveTable(log, "data/"+name+".csv");
}
