/************************************************************ 
This class is used to control the time of the entire application
*************************************************************/  

class Timer{
  int startTime=0;         // Define the parameters
  int endTime=24*60*60;
  int current;
  boolean pause;

/************************************************************
The timer can control the time line and also the user can pause 
or reset the time line at anytime. There are two buttons which are
the prev and the next. They can use to adjust to a accurate time.

Code ideas reference by
https://forum.processing.org/one/topic/how-to-trigger-a-timer-in-processing.html
https://forum.processing.org/one/topic/how-to-start-a-timer-on-command.html
https://forum.processing.org/one/topic/timer-in-processing.html
*************************************************************/

  Timer()                  // Set the time controller
  {
    initializeTime();
  }
  
  void initializeTime()
  {
    current=startTime;
    pause=true;
  }
  
  void runTime()
  {
    if(!pause)
      current+=freq;
    if(current>endTime)
    {
      pause=true;
      current=endTime;
    }
  }
  
  void pauseTime()                 // To pause time
  {
    pause=true;
  }
  
  void startTime()
  {
    pause=false;
  }
  
  int getTime()
  {
    return current;
  }
  
  void setTime(float a)
  {
    if (a>endTime)
       current=endTime;
    else if(a<startTime)
      a=startTime;
    else
      current=(int)a;
  }
  
  void prevTime() 
  {
    current-=freq;
  }
  
  void nextTime() 
  {
    current+=freq;
  }
  
  String displayTime()          // Set time format
  {
    int min=(current/60)%60;
    int h=current/3600;
    String hour = String.format("%1$02d",h);
    String minute = String.format("%1$02d",min);

    String timeStamp=""+hour+":"+minute;
    return timeStamp;
  }
}
