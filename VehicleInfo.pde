/************************************************************
 This class called VehicleInfo is used for store the data as 
 well as manipulate and output the data of each bus.
*************************************************************/

class VehicleInfo {  
  String operator;                 // Define the parameters
  int IdNumber;
  int lineID;

  /************************************************************
   Create six arraylists to show the information of each bus. 
   Use PVector to describe a two or three dimensional vector, 
   usually to describe a position. 
   
   Code ideas reference by
   https://processing.org/reference/PVector.html  
   *************************************************************/

  ArrayList<PVector> coordinate;
  ArrayList<Integer> busDelay;
  ArrayList<Integer> time;
  ArrayList<Integer> stopNumber;
  ArrayList<Integer> atStopOrNot;
  ArrayList<Integer> congestionOrNot;

  int numOfRecord;             // This parameter is the number of record of each bus

  VehicleInfo() {
    numOfRecord=0;
    coordinate=new ArrayList<PVector>();
    busDelay=new ArrayList<Integer>();
    time=new ArrayList<Integer>();
    stopNumber=new ArrayList<Integer>();
    atStopOrNot=new ArrayList<Integer>();  
    congestionOrNot=new ArrayList<Integer>();
  }

  /************************************************************
   Store the bus information including new data under the name 
   of the corresponding bus
   *************************************************************/

  void addNewRecord(
  String Id, String lineNumber, String opCode, 
  String lontitude, String latitude, String busTime, 
  String stop, String atStop, String delay, String congestion
    )
  {   

    float x;
    float y;
    operator=opCode;
    IdNumber=Integer.parseInt(Id);         // Trasnsfer the datatype of Id and lineNumber
    lineID=Integer.parseInt(lineNumber);

    /************************************************************    
     Code ideas reference by
     http://processing.github.io/processing-javadocs/core/processing/core/PVector.html
     https://forum.processing.org/one/topic/string-to-float-problems.html
     *************************************************************/

    PVector AB=proj.transformCoords
      (
    new PVector(Float.parseFloat(lontitude), Float.parseFloat(latitude))   // Use parseFloat to convert to float datatype
      );

    x=map(AB.x, topLeftCorner.x, bottomRightCorner.x, 0, mapWidth);
    y=map(AB.y, topLeftCorner.y, bottomRightCorner.y, 0, mapHeight);

    coordinate.add(new PVector(x, y));
    time.add(timeTrans(busTime));

    /************************************************************    
     Code ideas reference by
     https://processing.org/reference/String_equals_.html
     *************************************************************/

    if (stop.equals("null") == true)
    {
      stopNumber.add(0);
    } else
    {
      stopNumber.add(Integer.parseInt(stop));
    }
    atStopOrNot.add(Integer.parseInt(atStop));
    busDelay.add(Integer.parseInt(delay));
    congestionOrNot.add(Integer.parseInt(congestion));
    numOfRecord++;
  }

  int timeTrans(String time) {                   // Transform time to second
    int second=Integer.parseInt(time)-1356998400;
    return second;
  }

  void addVehicle(int currentTime, int mode)   // Show the bus information on the map
  {
    if (numOfRecord==0)
    {
      return;
    }
    int i=0;

    /************************************************************    
     Code ideas reference by
     https://processing.org/reference/pushStyle_.html
     https://processing.org/reference/ellipse_.html
     https://processing.org/reference/popStyle_.html
     *************************************************************/

    while ( (time.get (i)<currentTime))             // There are two mode which are accumulated mode and real-time mode
    {                
      if ((i>=0) && (mode==1)||
        ((mode==0)&&(time.get(i)>=currentTime-freq)))
      {
        pushStyle();
        noStroke();
        switch(baseControl.colorMode) {
        case 0: 
          if (busDelay.get(i)==1)
          {
            fill(220, 34, 34);
            ellipse(coordinate.get(i).x, coordinate.get(i).y, 20, 20);
          } else if (congestionOrNot.get(i)==1)
          {
            fill(255, 154, 0);
            ellipse(coordinate.get(i).x, coordinate.get(i).y, 18, 18);
          } else
          {
            fill(90, 175, 41);
            ellipse(coordinate.get(i).x, coordinate.get(i).y, 6, 6);
          }
          break;
        case 1: 
          switch (busDelay.get(i)) {
          case 1 : 
            fill(220, 34, 34);
            ellipse(coordinate.get(i).x, coordinate.get(i).y, 20, 20);
          }
          break;
        case 2: 
          switch (congestionOrNot.get(i)) {
          case 1 : 
            fill(255, 154, 0);
            ellipse(coordinate.get(i).x, coordinate.get(i).y, 18, 18);
          }
          break;
        }
        popStyle();               // Restore original style
      }
      i++;
      if (i>numOfRecord-1)
      {
        break;
      }
    }
  }
}


