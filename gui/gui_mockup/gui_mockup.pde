/**
* ControlP5 Chart
*
* find a list of public methods available for the Chart Controller
* at the bottom of this sketch.
*
* by Andreas Schlegel, 2012
* www.sojamo.de/libraries/controlp5
*
*/


import controlP5.*;

ControlP5 cp5;

Chart tempChart;
Chart phChart;
Chart RPMChart;
PFont f;
int count;

void setup() {
  fullScreen();
  smooth();
  background(color(100,100,100));
  count = 0;
  
  f = createFont("Helvetica", 16, true);
  String[] fontList = PFont.list();
  printArray(fontList);
  
  cp5 = new ControlP5(this);
  tempChart = cp5.addChart("Temperature")
               .setPosition(350, 50)
               .setSize(500, 200)
               .setRange(0, 50)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               ;

  tempChart.getColor().setBackground(color(#60CEB7));


  tempChart.addDataSet("world");
  tempChart.setColors("world", color(#FFF079),color(255,0,0));
  tempChart.setData("world", new float[30]);
  
  phChart = cp5.addChart("pH")
               .setPosition(350, 300)
               .setSize(500, 200)
               .setRange(0, 17)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               ;

  phChart.getColor().setBackground(color(#60CEB7));


  phChart.addDataSet("ph");
  phChart.addDataSet("MA");
  phChart.setColors("ph", color(#FFF079),color(255,0,0));
  phChart.setData("ph", new float[30]);
  phChart.setData("MA", new float[30]);
  
  RPMChart = cp5.addChart("RPM")
               .setPosition(350, 550)
               .setSize(500, 200)
               .setRange(0, 200)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               ;

  RPMChart.getColor().setBackground(color(#60CEB7));


  RPMChart.addDataSet("RPM");
  RPMChart.setColors("RPM", color(#FFF079),color(255,0,0));
  RPMChart.setData("RPM", new float[30]);


}


void draw() {
  background(color(100,100,100));
  int x = 340;
  int y = 180;
  // unshift: add data from left to right (first in)
  // push: add data from right to left (last in)
  textFont(f,32);
  text("TEMPERATURE", x, y); 
  text("PH LEVEL", x, y+250);
  text("RPM", x, y+500);
  
  textFont(f,80);
  textAlign(RIGHT);

  float temp = ((float)Math.random()*2.0+35.0);
  text(temp, x,250);
  tempChart.push("world", temp);
  
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
  
  float RPM = ((float)Math.random()*10+120);
  text(RPM, x, 750);
  RPMChart.push("RPM",RPM);
  count++;
  delay(125);
}