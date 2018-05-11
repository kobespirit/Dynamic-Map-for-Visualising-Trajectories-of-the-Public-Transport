/***************************************************************
This class generates three line charts for statistical analysis.
One is the number of congestion record, one is the average value 
of delay in second and one is the number of delay record.
***************************************************************/

class showLinechart{
  float[] delay;                // Define the parameters
  int[] congestion;
  int[] numOfVehicle;

  showLinechart() 
  {
    delay=new float[24*60];
    congestion=new int[24*60];  
    numOfVehicle=new int[24*60];
  }

/************************************************************    
Code ideas reference by
https://processing.org/reference/pushStyle_.html
https://processing.org/reference/popStyle_.html
*************************************************************/   

  void drawLinechart()       // Create the linechart
  {
    pushStyle();             // Build on the current style information
    setBackground();
    drawCongestion();
    drawAVGofDelay();
    drawNumOfDelay();
    popStyle();              // Restores the prior settings
  }

  void drawCongestion()      // Show the number of congestion record
  {
    float x1=1030;
    float y1=220;
    float x2=1030;
    float y2=220;
    pushStyle();
    textSize(10);
    fill(0);
    map((pointer_x-1030), 0, 370, 0, 24*60*60);
    stroke(255, 205, 0);
    strokeWeight(1);
    for (int i=0; i<24*60; i++) {
      x2=map(i, 0, 24*60, 1030, 1400);
      y2=map(congestion[i], 0, 20, 220, 60);
      line(x1, y1, x2, y2);
      x1=x2;
      y1=y2;
    }
    popStyle();
  }

  void drawAVGofDelay()      // Show the average value of dalay
  {
    float x1=1030;
    float y1=240;
    float x2=1030;
    float y2=240;
    pushStyle();
    stroke(204, 24, 24);
    strokeWeight(1);
    for (int i=0; i<24*60; i++) {  
      x2=map(i, 0, 24*60, 1030, 1400);
      y2=map(delay[i]/numOfVehicle[i], 0, 1000, 460, 300);
      line(x1, y1, x2, y2);
      x1=x2;
      y1=y2;
    }
    popStyle();
  }

  void drawNumOfDelay()       // Show the number of delay record
  {  
    float x1=1030;
    float y1=540;
    float x2=1030;
    float y2=540;
    pushStyle();
    stroke(255, 25, 25);
    strokeWeight(1);
    for (int i=0; i<24*60; i++) {
      x2=map(i, 0, 24*60, 1030, 1400);
      y2=map(numOfVehicle[i], 0, 100, 700, 440);
      line(x1, y1, x2, y2);
      x1=x2;
      y1=y2;
    }
    stroke(0);
    line(1030, 540, 1030, 700);
    popStyle();
  }
  
  void addCong(int i) 
  {
    congestion[i]++;
  }

  void addDelay(int i, float j) 
  {
    delay[i]+=j;
  }

  void recordBus(int i) 
  {
    numOfVehicle[i]++;
  }

/************************************************************    
Create the background of three linecharts including the X, Y 
arrows, its values and lines.
*************************************************************/  

  void setBackground() 
  {
    pushStyle();
    strokeWeight(1);
    fill(248);
    rectMode(CORNERS);
    noStroke();
    rect(1001, 0, 1440, 800);

    stroke(0);
    line(1030, 220, 1420, 220);
    line(1030, 220, 1030, 30);
    line(1030, 30, 1028, 36);
    line(1030, 30, 1032, 36);
    line(1420, 220, 1414, 218);
    line(1420, 220, 1414, 222);

    line(1030, 460, 1420, 460);
    line(1030, 460, 1030, 270);
    line(1030, 270, 1028, 276);
    line(1030, 270, 1032, 276);
    line(1420, 460, 1414, 462);
    line(1420, 460, 1414, 458);

    line(1030, 510, 1030, 700);
    line(1030, 700, 1420, 700);
    line(1030, 510, 1028, 514);
    line(1030, 510, 1032, 514);
    line(1420, 700, 1414, 702);
    line(1420, 700, 1414, 698);

    for (int i=0; i<5; i++) {
      textSize(8);
      fill(0);
      line(1028, 220-i*40, 1400, 220-i*40);
      text(""+5*i, 1003, 220-i*40);
      line(1028, 460-i*40, 1400, 460-i*40);
      text(""+250*i, 1003, 460-i*40);
      line(1028, 700-i*40, 1400, 700-i*40);
      text(""+25*i, 1003, 700-i*40);
    }
    popStyle();
  }  
}

