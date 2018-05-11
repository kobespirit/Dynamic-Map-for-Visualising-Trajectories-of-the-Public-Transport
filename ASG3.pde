/***************************************************************
GEOM90007 Major Project
Group Member:
Gang Fu      709659
Shen Zhang   707496
Jie Pu       765316
Changjian Ma 653909

This project is to develop an exploratory user interface including various functions using Processing.
The dataset our group used is the "Dublin Bus" dataset.

This interface runs in Processing 2.2.1.
***************************************************************/

import java.awt.*;                                            // To load some necessary pack
import java.util.Arrays;
import java.awt.*;
import java.awt.event.*;
import org.gicentre.utils.spatial.*;


public static final int mapWidth=1000;                        // Define the size of the map and window
public static final int mapHeight=800;
public static final int windowWidth=1440;
public static final int windowHeight=800;
public static final int freq=60;

/************************************************************    
Code ideas reference by
https://www.processing.org/reference/PImage.html
https://processing.org/reference/PVector.html
https://processing.org/tutorials/pvector/
*************************************************************/   

PImage baseMap;                         // Store the image
PVector tlConer=new PVector(-6.4991, 53.4273);
PVector brConer=new PVector(-6.0885, 53.2471);
PVector topLeftCorner, bottomRightCorner; 

String[] operatorList= {"RD", "D1", "CD", "HN", "PO", "SL"};  // lists all the operator, line and vehicle
ArrayList<Integer> lineID;             
ArrayList<Integer> vehicleID;

VehicleInfo[] bus=new VehicleInfo[1000];                      // To store and manipulate the information of bus
WebMercator proj;                                             // Use WGS84 projection
controlSetting baseControl;                                   // All the buttons and menus
showLinechart chart;                                          // Three static statistical line charts
Timer baseTimer;                                              // Control the time progress

float limit_x=0.0;                                            // Set the Variables for the time bar 
float bar_y=740.0;
float pointer_x=200.00;
boolean overSliderCubeCube=false;
boolean ifLock=false;
float pressed;

void readData()                             // Read data from datasets
{                          
  int minTime;
  for (int i=0; i<1000; i++) 
  {
    bus[i]=new VehicleInfo();               // Create an object for each vehicle
  }
  
/************************************************************
Code ideas reference by
https://processing.org/discourse/beta/num_1169318286.html
https://forum.processing.org/two/discussion/5280/extracting-minutes-from-a-timestamp
*************************************************************/  

  Table gpsTable=loadTable("dataset.csv", "header");
  TableRow eachRow;
  for (int i=0; i<gpsTable.getRowCount (); i++) {
    eachRow=gpsTable.getRow(i);
    minTime= (eachRow.getInt("Time Stamp")-1356998400)/60;
   
    if (eachRow.getInt("Congestion")==1)             // Add congestion record for the line charts
    {
      chart.addCong(minTime);
    }
    
    if (eachRow.getFloat("Delay")>0)                 // Add delay record for the line charts
    {
      chart.addDelay(minTime, eachRow.getFloat("Delay"));
      chart.recordBus(minTime);
    }
    
    if (lineID.indexOf(eachRow.getInt("Line"))==-1)  // Record all lineID
    {
      lineID.add(Integer.parseInt(eachRow.getString("Line")));
    }
    
    if (vehicleID.indexOf(eachRow.getInt("Vehicle")) != -1)  // Store all data for each vehicle
    {
      bus[vehicleID.indexOf(eachRow.getInt("Vehicle"))].addNewRecord(eachRow.getString("Vehicle"), eachRow.getString("Line"), 
      eachRow.getString("Operator"), eachRow.getString("Long"), eachRow.getString("Lat"), eachRow.getString("Time Stamp"), 
      eachRow.getString("Stop"), eachRow.getString("At Stop"), eachRow.getString("Delay"), eachRow.getString("Congestion"));
    } 
    else 
    {
      vehicleID.add(Integer.parseInt(eachRow.getString("Vehicle")));
      bus[vehicleID.size()-1].addNewRecord(eachRow.getString("Vehicle"), eachRow.getString("Line"), 
      eachRow.getString("Operator"), eachRow.getString("Long"), eachRow.getString("Lat"), eachRow.getString("Time Stamp"), 
      eachRow.getString("Stop"), eachRow.getString("At Stop"), eachRow.getString("Delay"), eachRow.getString("Congestion"));
    }
  }
}

void drawLegend()               
{
  String legend = "";
  fill(0);
  textSize(18);
  for (int i=0; i<3; i++) {
    switch(i) {
    case 0: 
      fill(220, 34, 34);
      legend = "Delay";
      break;
    case 1: 
      fill(255, 154, 0);
      legend = "Congestion";
      break;
    case 2: 
      fill(90, 175, 41);
      legend = "On Schedule";
      break;
    }
    ellipse(1070, 730 + i * 30, 10, 10);
    fill(0);
    textSize(16);
    text(legend, 1080, 733 + i * 30);
  }
}

void setMainTexts()                        // Naming the title of each linecharts and the main map
{
  pushStyle();
  textSize(36);
  fill(0);
  text("Dublin Bus System Delay Analysis", 360, 40);
  textSize(20);
  text("Jan 1st, 2013", 816, 70);
  text("Number of Congestion", 1110, 25);
  text("Average Time of Delay", 1100, 265);
  text("Number of Delay", 1120, 505);
  popStyle();
}

void drawBar() 
{
  pushStyle();
  noStroke();
  fill(0);
  textSize(17); 
  text(""+baseTimer.displayTime(), 520, bar_y - 20);      // Display current time
  popStyle();
  
  if (mouseX>=pointer_x-3&&mouseX<=pointer_x+3&&            // Check whether the mouse is over the time pointer
    mouseY>=bar_y-11&&mouseY<=bar_y+11) 
  {
    overSliderCubeCube=true;
    if (!ifLock)                                          // if over the time pointer, color the pointer 
    {     
      stroke(125); 
      fill(125);
    }
  } 
  else                                                    
  {            
    stroke(0);
    fill(0);
    overSliderCubeCube=false;
  }

  if (!ifLock)     // when the mouse is not dragging the pointer, the pointer is led by the timer 
  {    
    pointer_x=map(baseTimer.getTime(), 0, 86400, 200, 885);
  } 

/************************************************************
Code ideas reference by
https://processing.org/reference/rect_.html
https://www.processing.org/reference/rectMode_.html
*************************************************************/  
 
  rectMode(CORNERS);
  noStroke();
  fill(130);
  rect(200, bar_y-4, pointer_x, bar_y+4);
  fill(190);
  rect(pointer_x, bar_y-4, 885, bar_y+4);

  fill(0);
  pushStyle();
  stroke(125);
  tint(255, 125);
  // draw the time indicator on the charts
  line((pointer_x - 200)/685 * 370 + 1030, 30, (pointer_x - 200)/685 * 370 + 1030, 710);
  popStyle(); 
  // draw the slider 
  rectMode(RADIUS);                                
  rect(pointer_x, bar_y, 4, 10);
}

/************************************************************
Code ideas reference by
https://processing.org/reference/mousePressed.html
https://processing.org/reference/mouseDragged_.html
*************************************************************/ 

void mousePressed() 
{
  if (overSliderCubeCube) 
  {
    baseTimer.pauseTime();
    ifLock=true;
    fill(230);
    stroke(200);
  } 
  else 
  {
    ifLock= false;
  }
  limit_x= mouseX-pointer_x;
}

void mouseDragged()            // When the mouse is dragging the pointer, the pointer moves with the mouse 
{ 
  if (ifLock) 
  {
    if (mouseX-limit_x<200) 
    {
      pointer_x=200;
    } 
    else if (mouseX-limit_x>885) 
    {
      pointer_x=885;
    } 
    else 
    {
      pointer_x=mouseX-limit_x;
    }
  }
  baseTimer.setTime(map((pointer_x-200), 0, 685, 0, 24*60*60));
}

void mouseReleased() 
{
  ifLock=false;
}

void projection() 
{
  proj=new WebMercator();
  topLeftCorner=proj.transformCoords(tlConer);
  bottomRightCorner=proj.transformCoords(brConer);
}

void setup() 
{
  background(255);
  size(windowWidth, windowHeight);

/************************************************************    
Code ideas reference by
https://processing.org/reference/pushStyle_.html
https://processing.org/reference/popStyle_.html
*************************************************************/   

  pushStyle();
  imageMode(CORNERS);
  baseMap=loadImage("map.jpg");                               // Load the map of Dublin
  popStyle();
  projection();                                               // Set WGS84 coordinates
  lineID=new ArrayList<Integer>();
  vehicleID=new ArrayList<Integer>();
  chart=new showLinechart();
  baseControl=new controlSetting();                           // Set and initialize buttons and menus
  baseTimer= new Timer();                                     // Set and initialize timer
  readData();                                                 // Call the class loaddata 
  frameRate(baseControl.frame);
}

void draw()                                                   // Draw the chart and other components
{
  pushStyle();
  tint(255, 255);
  image(baseMap, 0, 0, mapWidth, mapHeight);
  filter(POSTERIZE, 18);                     
  popStyle();
  chart.drawLinechart();
  fill(0);
  triangle(30, 120, 50, 105, 50, 80);
  triangle(70, 120, 50, 105, 50, 80);
  drawBar();                                                  // Draw the time bar

/************************************************************
The following for loop draws points on the map according to 
the map mode and the parameters chosen to show
*************************************************************/  

  for (int i=0; i<vehicleID.size (); i++) 
  {    
    if ((baseControl.showVariable==0)||(baseControl.showLayer==0&&
       Arrays.asList(operatorList).indexOf(bus[i].operator)==
       (baseControl.showVariable-1))||
       (baseControl.showLayer==1&&lineID.indexOf(bus[i].lineID)==
       (baseControl.showVariable-1))||
       (baseControl.showLayer==2&&vehicleID.indexOf(bus[i].IdNumber)==
       (baseControl.showVariable-1))) {
       bus[i].addVehicle(baseTimer.getTime(), baseControl.mapLayer);
    }
  }

  frameRate((baseControl.frame+1)*5);
  baseTimer.runTime();                               // Set the time for next frame of animation
  drawLegend();                                     // Draw the legend
  setMainTexts();
}



